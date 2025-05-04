import 'dart:async';
import 'dart:math';
import 'package:chomskyspark/screens/home/views/home_screen.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:chomskyspark/models/object_detection_attempt_model.dart';
import 'package:chomskyspark/models/recognized_object.dart';
import 'package:chomskyspark/providers/object_detection_attempt_provider.dart';
import 'package:chomskyspark/providers/object_detection_provider.dart';
import 'package:chomskyspark/route/route_constants.dart';
import 'package:chomskyspark/utils/auth_helper.dart';
import 'package:chomskyspark/utils/speech_messages.dart';
import 'package:chomskyspark/utils/text_to_speech_helper.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class FindObjectsPage extends StatefulWidget {
  FindObjectsPage({Key? key}) : super(key: key);

  @override
  _FindObjectsPageState createState() => _FindObjectsPageState();
}

class _FindObjectsPageState extends State<FindObjectsPage> {
  final TextToSpeechHelper ttsService = TextToSpeechHelper();
  final ObjectDetectionAttemptProvider objectDetectionAttemptProvider = ObjectDetectionAttemptProvider();
  late ConfettiController _confettiController;
  late String randomWord = "";
  late List<String> foundObjects;
  late List<RecognizedObject> recognizedObjects = [];
  late String imageUrl = "https://api.thorhof-bestellungen.at/uploads/chomskyspark/find-object/7.png";

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
    _confettiController = ConfettiController(duration: const Duration(seconds: 10));
    setData();
  }

  setData() async {
    setState(() {
      isLoading = true;
    });

    try {
      foundObjects = [];

      ObjectDetectionProvider objectDetectionProvider = ObjectDetectionProvider();
      var response = await objectDetectionProvider.getRandomRecognizedObject();

      if (response.isNotEmpty) {
        recognizedObjects =
            response['recognizedObjects'] as List<RecognizedObject>;
        imageUrl = response['imageUrl'] as String;
      }

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
      ttsService.findObject(randomWord, sentenceTemplate: SpeechMessages.Find);
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    ttsService.stop();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF9D58D5),
              Color(0xFF422A74),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white), // Icon color
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Find Objects',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Text color
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/clock.png',
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${_formatDuration(elapsedTime)}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    //Row(
                    //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //  children: [
                    //    Text(
                    //      'Multilingual',
                    //      style: TextStyle(fontSize: 16),
                    //    ),
                    //    Switch(
                    //      value: Authorization.useBothLanguages,
                    //      onChanged: (value) {
                    //        setState(() {
                    //          Authorization.useBothLanguages = value;
                    //        });
                    //      },
                    //      activeColor: Colors.purple,
                    //    ),
                    //  ],
                    //),
                    SizedBox(
                      height: 35, // Podesi željenu visinu
                      child: LiteRollingSwitch(
                        value: Authorization.useBothLanguages,
                        textOn: 'Multilingual',
                        textOff: 'Multilingual',
                        iconOn: Icons.done,
                        iconOff: Icons.remove_circle_outline,
                        onChanged: (bool value) {
                          setState(() {
                            Authorization.useBothLanguages = value;
                          });
                        },
                        textSize: 12.0,
                        width: 125,
                        colorOn: Colors.white10,
                        colorOff: Colors.white54,
                        onDoubleTap: () {},
                        onSwipe: () {},
                        onTap: () {},
                      ),
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/archery-board.png',
                          width: 30,
                          height: 30,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          "${foundObjects.length}/${recognizedObjects.length}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius:
                      BorderRadius.vertical(top: Radius.circular(40)),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Image.network(
                            key: imageKey,
                            imageUrl,
                            loadingBuilder:
                                (context, child, loadingProgress) {
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
                                  ),
                                );
                              }
                              return Center(child: CircularProgressIndicator());
                            },
                          );
                        },
                      ),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF9D58D5),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.refresh),
                          color: Colors.white,
                          onPressed: () {
                            setState(() {
                              _refreshImage();
                            });
                          },
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                          onPressed: () {
                            if (objectRecognized) {
                              ttsService.findObject(randomWord,
                                  sentenceTemplate:
                                  SpeechMessages.Find);
                            }
                          },
                          child: Text(randomWord),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(40)),
                            ),
                            backgroundColor: Color(0xFF9D58D5),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _refreshImage() {
    foundObjects.clear();
    recognizedObjects.clear();
    setData();
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
              border: foundObjects.contains(object.name)
                  ? null
                  : Border.all(color: Colors.transparent, width: 0),
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
      barrierDismissible: false, // Prevent closing the dialog without interaction
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: SizedBox(
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Confetti animation with star-shaped particles
              ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                // Custom colors (purple and other playful colors)
                colors: [Color(0xFF9D58D5), Color(0xFF422A74), Colors.yellow, Colors.pink, Colors.blue],
                emissionFrequency: 0.1, // More frequent emissions
                gravity: 0.5, // Increased gravity for faster fall
                maxBlastForce: 30, // Maximum blast force
                minBlastForce: 10, // Minimum blast force
                numberOfParticles: 25, // More particles per emission
                maximumSize: const Size(25, 25), // Larger stars
                minimumSize: const Size(15, 15), // Smaller stars
                particleDrag: 0.02, // Reduced drag for smoother movement
                strokeWidth: 0, // Remove borders
                createParticlePath: (Size size) {
                  // Create a star-shaped path for the particles
                  double degToRad(double deg) => deg * (pi / 180.0);

                  const numberOfPoints = 5;
                  final halfWidth = size.width / 2;
                  final externalRadius = halfWidth;
                  final internalRadius = halfWidth / 2.5;
                  final degreesPerStep = degToRad(360 / numberOfPoints);
                  final halfDegreesPerStep = degreesPerStep / 2;
                  final path = Path();
                  final fullAngle = degToRad(360);

                  path.moveTo(size.width, halfWidth);

                  for (double step = 0; step < fullAngle; step += degreesPerStep) {
                    path.lineTo(
                        halfWidth + externalRadius * cos(step),
                        halfWidth + externalRadius * sin(step));
                    path.lineTo(
                        halfWidth + internalRadius * cos(step + halfDegreesPerStep),
                        halfWidth + internalRadius * sin(step + halfDegreesPerStep));
                  }
                  path.close();
                  return path;
                },
              ),
              // Text in the pop-up
              const Text(
                "Congratulations! 🎉",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();

              if (foundObjects.length != recognizedObjects.length) {
                setState(() {
                  randomWord = getRandomObjectName(recognizedObjects);
                  ttsService.findObject(randomWord,
                      sentenceTemplate: SpeechMessages.Find);
                });
              }
              _confettiController.stop();
            },
            child: const Text("OK", style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );

    _confettiController.play();

    ttsService.findObject(randomWord, sentenceTemplate: "You found the {word}");
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }
}
