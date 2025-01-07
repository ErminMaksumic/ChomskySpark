import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shop/models/recognized_object.dart';
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
  late String randomWord;

  double imageWidth = 1;
  double imageHeight = 1;
  double containerWidth = 1;
  double containerHeight = 1;
  bool objectRecognized = false;

  final GlobalKey imageKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    randomWord = getRandomObjectName(widget.recognizedObjects);

    if (objectRecognized){
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
                              imageWidth = image?.image?.width?.toDouble() ?? 0;
                              imageHeight = image?.image?.height?.toDouble() ?? 0;
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
                        )
                      );
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
                if (objectRecognized){
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

    //final RenderBox? renderBox = imageKey.currentContext?.findRenderObject() as RenderBox?;

    return widget.recognizedObjects.map((object) {
      return Positioned(
        left: object.x,
        top: object.y,
        child: GestureDetector(
          onTap: () {
            if (object.name == randomWord) {
              ttsService.speak("Well done! You found the object you were looking for.");
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
    if (objects.length == 0) {
      return "No object recognized";
    }

    objectRecognized = true;
    final random = Random();
    final randomIndex = random.nextInt(objects.length);
    return objects[randomIndex].name;
  }
}
