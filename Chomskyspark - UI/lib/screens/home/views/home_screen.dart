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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: Drawer(
          child: Stack(
            children: [
              // Background with Scattered Yellow Stars
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF422A74), // Your preferred color
                ),
                child: Stack(
                  children: [
                    // Scattered Yellow Stars
                    Positioned(
                      top: 20,
                      left: 20,
                      child: Icon(
                        Icons.star,
                        color: Colors.yellow, // Yellow stars
                        size: 24,
                      ),
                    ),
                    Positioned(
                      top: 50,
                      right: 30,
                      child: Icon(
                        Icons.star,
                        color: Colors.yellow, // Yellow stars
                        size: 18,
                      ),
                    ),
                    Positioned(
                      bottom: 40,
                      left: 40,
                      child: Icon(
                        Icons.star,
                        color: Colors.yellow, // Yellow stars
                        size: 22,
                      ),
                    ),
                    Positioned(
                      bottom: 80,
                      right: 20,
                      child: Icon(
                        Icons.star,
                        color: Colors.yellow, // Yellow stars
                        size: 20,
                      ),
                    ),
                    Positioned(
                      top: 100,
                      left: 100,
                      child: Icon(
                        Icons.star,
                        color: Colors.yellow, // Yellow stars
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
              // Drawer Content
              ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Custom Header (Replaces DrawerHeader)
                  Container(
                    height: 150, // Adjust height as needed
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star, // Yellow star icon
                          size: 48,
                          color: Colors.yellow, // Yellow stars
                        ),
                      ],
                    ),
                  ),
                  // QR Code Section
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        // QR Code Placeholder (Replace with actual QR code widget)
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.qr_code,
                              size: 100,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Link the child\'s device',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Menu Items
                  _buildDrawerItem(
                    context,
                    icon: Icons.pie_chart,
                    title: 'Child Statistic',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChildStatisticsPage(
                            userId: Authorization.user!.id!,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.format_quote,
                    title: 'Child Word Statistic',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChildWordsStatisticsPage(
                            userId: Authorization.user!.id!,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.date_range,
                    title: 'Child Daily Statistic',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChildDailyStatistics(
                            userId: Authorization.user!.id!,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.show_chart_outlined,
                    title: 'Child Improvement Areas',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChildImprovementAreasPage(
                            userId: Authorization.user!.id!,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),

              ListTile(
                leading: Icon(Icons.qr_code),
                title: Text("Connect your child's device"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GenerateQrPage()

                    ),
                  );
                },
              ),

            ],
          ),
        ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
                      Builder(
                        builder: (context) => IconButton(
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                          icon: Icon(Icons.menu, color: Colors.white),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF9D58D5),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  offset: Offset(2, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FindObjectsPage(),
                                  ),
                                );
                              },
                              icon: Icon(Icons.search, color: Colors.white),
                              label: Text(
                                'Find Object',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF9D58D5),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  offset: Offset(2, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => DiscoverWordsPage(),
                                  ),
                                );
                              },
                              icon: Icon(Icons.lightbulb_outline, color: Colors.white),
                              label: Text(
                                'Discover a Word',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Container(
                        height: 300,
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
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF9D58D5),
                          borderRadius: BorderRadius.circular(15),
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
                          label: Text(
                            'Take a Picture',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
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

  // Helper method to build Drawer items
  Widget _buildDrawerItem(BuildContext context,
      {required IconData icon, required String title, required VoidCallback onTap}) {
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
    var imageUrl = "/uploads/chomskyspark/20250107_001739_914122bb-47ac-4e9b-b112-48c8598e56f3(1).jpg";
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