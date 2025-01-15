import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop/providers/file_provider.dart';
import 'package:shop/screens/interactive-page/discover_words.dart';
import 'package:shop/screens/interactive-page/find_objects.dart';
import 'package:shop/screens/interactive-page/object_detection.dart';
import 'package:shop/screens/paretns-monitoring/child_improvement_areas.dart';
import 'package:shop/screens/paretns-monitoring/child_statistics.dart';
import 'package:shop/screens/paretns-monitoring/child_words_statistics.dart';
import 'package:shop/screens/paretns-monitoring/child_daily_statistics.dart';
import 'package:shop/screens/qr_code/generate_qr.dart';
import '../../../utils/auth_helper.dart';

class ChildHomeScreen extends StatelessWidget {
  const ChildHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  margin: const EdgeInsets.only(top: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.02),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Chomskyspark',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Pacifico',
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // Counter Circle with Shadow
                Padding(
                  padding: const EdgeInsets.only(top: 9.0),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        // Add button functionality
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.2),
                              spreadRadius: 4,
                              blurRadius: 8,
                              offset: Offset(4, 4), // Shadow position
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '0',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('Counter'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(),

                // Main Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      // Welcome Text
                      Text(
                        'You are doing Excellent,',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Nickname',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      SizedBox(height: 20),

                      // Buttons Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Find Object Button
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.purple,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  offset: Offset(2, 4), // Drop shadow position
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FindObjectsPage(),
                                  ),
                                );
                              },
                              child: Text('Find Objects'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent, // Set background to transparent to show the shadow
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 23, vertical: 10),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),

                          // Discover a Word Button
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.purple,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  offset: Offset(2, 4), // Drop shadow position
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DiscoverWordsPage(),
                                  ),
                                );
                              },
                              child: Text('Discover a Word'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent, // Set background to transparent to show the shadow
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      // Image Container with Shadow
                      Container(
                        height: 245,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: AssetImage('assets/images/try_image.png'),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: Offset(4, 4), // Position of the shadow
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),

                      // Take a Picture Button with Shadow
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(2, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            testFileUpload2(context);
                          },
                          icon: Icon(Icons.camera_alt, color: Colors.white),
                          label: Text('Take a Picture'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent, // Set background to transparent to show the shadow
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> testFileUpload(BuildContext context) async {

    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      File file = File(pickedFile.path);

      FileProvider fileProvider = FileProvider();
      var imageUrl = await fileProvider.sendFile(file);
      imageUrl = "https://api.thorhof-bestellungen.at${imageUrl}";

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ObjectDetectionPage(
            imageUrl: imageUrl,
          ),
        ),
      );
    } else {
      print('No file selected.');
    }
  }

  //TODO: Remove after testing
  Future<void> testFileUpload2(BuildContext context) async {

    var imageUrl = "/uploads/chomskyspark/20250107_001739_914122bb-47ac-4e9b-b112-48c8598e56f3(1).jpg";//await fileProvider.sendFile(file);
    imageUrl = "/uploads/chomskyspark/20250107_152052_1bdf3a8f-2d6e-48b2-bc5e-b0eeffa5ac29.jpg";
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ObjectDetectionPage(
          imageUrl: "https://api.thorhof-bestellungen.at${imageUrl}",
        ),
      ),
    );
  }
}
