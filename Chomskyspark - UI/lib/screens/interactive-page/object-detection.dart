import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shop/models/object_detection_attempt_model.dart';
import 'package:shop/models/recognized_object.dart';
import 'package:shop/providers/object_detection_attempt_provider.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/utils/auth_helper.dart';
import 'package:shop/utils/text_to_speech_helper.dart';

class ObjectDetectionPage extends StatefulWidget {
  final List<RecognizedObject> recognizedObjects;
  final String imageUrl;

  ObjectDetectionPage({Key? key, required this.recognizedObjects, required this.imageUrl}) : super(key: key);

  @override
  _ObjectDetectionPageState createState() => _ObjectDetectionPageState();
}

class _ObjectDetectionPageState extends State<ObjectDetectionPage> {
  final TextToSpeechHelper ttsService = TextToSpeechHelper();
  final ObjectDetectionAttemptProvider objectDetectionAttemptProvider = ObjectDetectionAttemptProvider();
  late String randomWord;
  late List<String> foundObjects;

  double imageWidth = 1;
  double imageHeight = 1;
  bool objectRecognized = false;

  int attemptCount = 0;
  late DateTime startTime;

  final GlobalKey imageKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    startTime = DateTime.now();
    foundObjects = [];
    randomWord = getRandomObjectName(widget.recognizedObjects);

    if (objectRecognized) {
      ttsService.tellWhatIsInThePicture(randomWord);
    }
  }

  @override
  void dispose() {
    ttsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Object Detection'),
      ),
      body: Column(
        children: [
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
                        final imageStream = NetworkImage(widget.imageUrl).resolve(imageConfiguration);
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
                  ttsService.tellWhatIsInThePicture(randomWord);
                }
              },
              child: Text(randomWord),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBoundingBoxes() {
    return widget.recognizedObjects.map((object) {
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
    final remainingObjects = objects.where((o) => !foundObjects.contains(o.name)).toList();
    if (remainingObjects.isEmpty) {
      return "No object recognized";
    }

    objectRecognized = true;
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
            "🎉 Great Job!",
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

                if (foundObjects.length == widget.recognizedObjects.length) {
                  Navigator.of(context).pushReplacementNamed(homeScreenRoute);
                } else {
                  setState(() {
                    randomWord = getRandomObjectName(widget.recognizedObjects);
                    ttsService.tellWhatIsInThePicture(randomWord);
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


    ttsService.speak("Well done! You found the object you were looking for.");
  }
}
