import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/object_detection_attempt_model.dart';
import 'package:shop/models/recognized_object.dart';
import 'package:shop/providers/object_detection_attempt_provider.dart';
import 'package:shop/providers/object_detection_provider.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/utils/auth_helper.dart';
import 'package:shop/utils/speech_messages.dart';
import 'package:shop/utils/text_to_speech_helper.dart';

import '../../providers/language_provider.dart';

class ObjectDetectionPage extends StatefulWidget {
  final String imageUrl;

  ObjectDetectionPage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  _ObjectDetectionPageState createState() => _ObjectDetectionPageState();
}

class _ObjectDetectionPageState extends State<ObjectDetectionPage> {
  final TextToSpeechHelper ttsService = TextToSpeechHelper();
  final ObjectDetectionAttemptProvider objectDetectionAttemptProvider =
      ObjectDetectionAttemptProvider();
  late String randomWord;
  late List<String> foundObjects;
  late List<RecognizedObject> recognizedObjects = [];

  double imageWidth = 1;
  double imageHeight = 1;
  bool objectRecognized = false;

  int attemptCount = 0;
  late DateTime startTime;
  Timer? timer;
  Duration elapsedTime = Duration.zero;
  bool isLoading = true;

  final GlobalKey imageKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    setData();
  }

  setData() async {
    setState(() {
      isLoading = true;
    });

    try {
      foundObjects = [];

      ObjectDetectionProvider objectDetectionProvider =
          ObjectDetectionProvider();
      recognizedObjects =
          await objectDetectionProvider.detectImage(widget.imageUrl);

      print(recognizedObjects);
      randomWord = getRandomObjectName(recognizedObjects);

      timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
        setState(() {
          elapsedTime = DateTime.now().difference(startTime);
        });
      });
    } catch (e) {
      print("Error loading data: $e");
    } finally {
      setState(() {
        isLoading = false;
        startTime = DateTime.now();
      });
      if (objectRecognized) {
        ttsService.findObject(randomWord,
            sentenceTemplate: SpeechMessages.Success);
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    ttsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Object Detection'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Time: ${_formatDuration(elapsedTime)}",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(
                          "Found: ${foundObjects.length}/${recognizedObjects.length}",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text("Attempts: $attemptCount",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Image.network(
                        key: imageKey,
                        widget.imageUrl,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              final imageConfiguration = ImageConfiguration();
                              final imageStream = NetworkImage(widget.imageUrl)
                                  .resolve(imageConfiguration);
                              imageStream.addListener(
                                ImageStreamListener((ImageInfo image, _) {
                                  setState(() {
                                    imageWidth = image.image.width.toDouble();
                                    imageHeight = image.image.height.toDouble();
                                  });
                                }),
                              );
                            });

                            return SizedBox.expand(
                                child: FittedBox(
                              fit: BoxFit.fill,
                              alignment: Alignment.center,
                              child: Stack(
                                children: [
                                  child,
                                  ..._buildBoundingBoxes(),
                                ],
                              ),
                            ));
                          }
                          return Center(child: CircularProgressIndicator());
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (objectRecognized) {
                        ttsService.findObject(randomWord,
                            sentenceTemplate: SpeechMessages.Success);
                      }
                    },
                    child: Text(randomWord),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: Colors.purple,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  List<Widget> _buildBoundingBoxes() {
    return recognizedObjects.map((object) {
      return Positioned(
        left: object.x,
        top: object.y,
        child: GestureDetector(
          onTap: () async {
            attemptCount++;
            final elapsedTime = DateTime.now().difference(startTime);
            final success = object.name == randomWord;

            final insertData = ObjectDetectionAttempt(
                targetWord: randomWord,
                selectedWord: object.name,
                success: success,
                attemptNumber: attemptCount,
                elapsedTimeInSeconds: elapsedTime.inSeconds,
                userId: Authorization.user!.id);

            objectDetectionAttemptProvider.insert(insertData);

            if (success) {
              _onObjectFound(object.name);
            } else {
              ttsService.speak("You're close. Try again.");
            }
          },
          child: Container(
            width: object.w,
            height: object.h,
            decoration: BoxDecoration(
              border: Border.all(color: object.color, width: 4),
            ),
          ),
        ),
      );
    }).toList();
  }

  String getRandomObjectName(List<RecognizedObject> objects) {
    final remainingObjects =
        objects.where((o) => !foundObjects.contains(o.name)).toList();
    if (remainingObjects.isEmpty) {
      return "No object recognized";
    }

    setState(() {
      objectRecognized = true;
    });
    final random = Random();
    final randomIndex = random.nextInt(remainingObjects.length);
    return remainingObjects[randomIndex].name;
  }

  void _onObjectFound(String objectName) {
    setState(() {
      foundObjects.add(objectName);
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            "\uD83C\uDF89 Great Job!",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/congrats.png',
              height: 100,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 10),
            Text(
              "You found the object: $objectName",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                backgroundColor: Colors.purple,
              ),
              onPressed: () {
                Navigator.of(context).pop();

                if (foundObjects.length == recognizedObjects.length) {
                  Navigator.of(context).pushReplacementNamed(homeScreenRoute);
                } else {
                  setState(() {
                    randomWord = getRandomObjectName(recognizedObjects);
                    ttsService.findObject(randomWord,
                        sentenceTemplate: SpeechMessages.Find);
                  });
                }
              },
              child: Text(
                "Continue",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    ttsService.findObject(randomWord, sentenceTemplate: SpeechMessages.Success);
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }
}
