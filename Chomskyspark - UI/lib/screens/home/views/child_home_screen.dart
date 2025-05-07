import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chomskyspark/providers/file_provider.dart';
import 'package:chomskyspark/screens/interactive-page/discover_words.dart';
import 'package:chomskyspark/screens/interactive-page/find_objects.dart';
import 'package:chomskyspark/screens/interactive-page/object_detection.dart';
import 'package:chomskyspark/screens/paretns-monitoring/child_improvement_areas.dart';
import 'package:chomskyspark/screens/paretns-monitoring/child_statistics.dart';
import 'package:chomskyspark/screens/paretns-monitoring/child_words_statistics.dart';
import 'package:chomskyspark/screens/paretns-monitoring/child_daily_statistics.dart';
import 'package:chomskyspark/screens/paretns-monitoring/word_for_image.dart';
import 'package:chomskyspark/screens/qr_code/generate_qr.dart';
import 'package:chomskyspark/screens/story/story_page.dart';
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
                  image: AssetImage('assets/images/bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  margin: const EdgeInsets.only(top: 20.0),
                  decoration: BoxDecoration(
                    color: Color(0xFF422A74).withOpacity(0.2),
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
                Padding(
                  padding: const EdgeInsets.only(top: 9.0),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF9D58D5).withOpacity(0.3),
                              spreadRadius: 4,
                              blurRadius: 8,
                              offset: Offset(4, 4),
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
                                  color: Color(0xFF422A74),
                                ),
                              ),
                              Text(
                                'Counter',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF422A74),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        alignment: WrapAlignment.center,
                        children: [
                          _buildMenuItem(
                            context,
                            'Find Objects',
                            'assets/images/find_object.png',
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FindObjectsPage(),
                              ),
                            ),
                          ),
                          _buildMenuItem(
                            context,
                            'Discover Words',
                            'assets/images/discover_word.png',
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DiscoverWordsPage(),
                              ),
                            ),
                          ),
                          _buildMenuItem(
                            context,
                            'Take Photo',
                            'assets/images/take_photo.png',
                            () => testFileUpload2(context),
                          ),
                          _buildMenuItem(
                            context,
                            'Story Time',
                            'assets/images/story.png',
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StoryPage(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      Container(
                        height: 230,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: AssetImage('assets/images/image.png'),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: Offset(4, 4),
                            ),
                          ],
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

  // Helper method to build Drawer items
  Widget _buildDrawerItem(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white, // Changed to white
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white, // White text color
        ),
      ),
      onTap: onTap,
      hoverColor: Colors.purple.withOpacity(0.1), // Hover effect
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Rounded corners
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
    var imageUrl =
        "/uploads/chomskyspark/20250107_001739_914122bb-47ac-4e9b-b112-48c8598e56f3(1).jpg";
    imageUrl =
        "/uploads/chomskyspark/20250107_152052_1bdf3a8f-2d6e-48b2-bc5e-b0eeffa5ac29.jpg";
    imageUrl =
        "https://plus.unsplash.com/premium_photo-1663075817635-90ecf218ee5f?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ObjectDetectionPage(
          imageUrl: "${imageUrl}",
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, String imagePath,
      VoidCallback onPressed) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Color(0xFF9D58D5),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF9D58D5),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
