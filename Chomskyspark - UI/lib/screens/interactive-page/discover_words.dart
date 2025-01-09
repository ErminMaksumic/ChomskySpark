import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shop/models/learned_word.dart';
import 'package:shop/models/recognized_object.dart';
import 'package:shop/providers/learned_word_provider.dart';
import 'package:shop/providers/object_detection_attempt_provider.dart';
import 'package:shop/providers/object_detection_provider.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/utils/auth_helper.dart';
import 'package:shop/utils/text_to_speech_helper.dart';

class DiscoverWordsPage extends StatefulWidget {

  DiscoverWordsPage({Key? key}) : super(key: key);

  @override
  _DiscoverWordsPageState createState() => _DiscoverWordsPageState();
}

class _DiscoverWordsPageState extends State<DiscoverWordsPage> {
  late List<RecognizedObject> recognizedObjects = [];
  late String imageUrl = "";

  final TextToSpeechHelper ttsService = TextToSpeechHelper();
  final ObjectDetectionAttemptProvider objectDetectionAttemptProvider = ObjectDetectionAttemptProvider();
  final LearnedWordProvider learnedWordProvider = LearnedWordProvider();
  late String word = "Please select any object...";
  late List<String> foundObjects = [];

  double imageWidth = 1;
  double imageHeight = 1;
  bool objectRecognized = false;

  bool isLoading = true;
  int wordCounter = 0;
  late DateTime startTime;
  Timer? timer;
  Duration elapsedTime = Duration.zero;

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
      ObjectDetectionProvider objectDetectionProvider = ObjectDetectionProvider();
      var response = await objectDetectionProvider.getRandomRecognizedObject();

      if (response.isNotEmpty) {
        recognizedObjects = response['recognizedObjects'] as List<RecognizedObject>;
        imageUrl = response['imageUrl'] as String;
      }
      startTime = DateTime.now();
      foundObjects = [];
      ttsService.speak(word);

    } catch (e) {
      print("Error loading data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
      timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
        setState(() {
          elapsedTime = DateTime.now().difference(startTime);
        });
      });
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
        title: Text('Discover Words'),
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
                Text(
                  "Time: ${_formatDuration(elapsedTime)}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Words: $wordCounter",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Image.network(
                  key: imageKey,
                  imageUrl,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        final imageConfiguration = ImageConfiguration();
                        final imageStream = NetworkImage(imageUrl).resolve(imageConfiguration);
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
                  ttsService.findObject(word);
                }
              },
              child: Text(word),
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
            ttsService.speak("It is a ${object.name}");
            word = object.name;
            if (!foundObjects.contains(object.name)){
              wordCounter++;
              foundObjects.add(word);

              final insertData = LearnedWord(
                  word: object.name,
                  userId: Authorization.user!.id!);
              learnedWordProvider.insert(insertData);
            }

            if (recognizedObjects.length == foundObjects.length && timer!.isActive) {
              timer!.cancel();
              Future.delayed(Duration(seconds: 2), () {
                _showDialog();
              });
            }
          },

          child: Container(
            width: object.w,
            height: object.h,
            decoration: BoxDecoration(
              border: foundObjects.contains(object.name)
                  ? null
                  : Border.all(color: object.color, width: 4),
            ),
          ),
        ),
      );
    }).toList();
  }

  void _showDialog() {
    var objects = foundObjects.join(",");
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
              "You discovered the following words: $objects",
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

    ttsService.speak("Well done! You discovered the following words: ${objects}");
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }
}
