import 'package:flutter/material.dart';
import 'package:shop/models/recognized_object.dart';
import 'package:shop/providers/object_detection_attempt_provider.dart';
import 'package:shop/providers/object_detection_provider.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/utils/text_to_speech_helper.dart';

class DiscoverWordPage extends StatefulWidget {

  DiscoverWordPage({Key? key}) : super(key: key);

  @override
  _DiscoverWordPageState createState() => _DiscoverWordPageState();
}

class _DiscoverWordPageState extends State<DiscoverWordPage> {
  late List<RecognizedObject> recognizedObjects = [];
  late String imageUrl = "";

  final TextToSpeechHelper ttsService = TextToSpeechHelper();
  final ObjectDetectionAttemptProvider objectDetectionAttemptProvider = ObjectDetectionAttemptProvider();
  late String word = "Please select any object...";
  late List<String> foundObjects = [];

  double imageWidth = 1;
  double imageHeight = 1;
  bool objectRecognized = false;

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
      ObjectDetectionProvider objectDetectionProvider = ObjectDetectionProvider();
      var response = await objectDetectionProvider.getRandomRecognizedObject();

      if (response.isNotEmpty) {
        recognizedObjects = response['recognizedObjects'] as List<RecognizedObject>;
        imageUrl = response['imageUrl'] as String;
      }
      foundObjects = [];
      ttsService.speak(word);

    } catch (e) {
      print("Error loading data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
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
        title: Text('Discover a Word'),
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Column(
        children: [
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
                  ttsService.tellWhatIsInThePicture(word);
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
            _showDialog();
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

  void _showDialog() {
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
              "Today you discovered the word $word",
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
                Navigator.of(context).pushReplacementNamed(homeScreenRoute);
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

    ttsService.speak("Today you discovered the word $word");
  }
}
