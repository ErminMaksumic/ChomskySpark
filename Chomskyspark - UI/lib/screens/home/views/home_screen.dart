import 'dart:io';
import 'package:chomskyspark/providers/learned_word_provider.dart';
import 'package:chomskyspark/providers/user_provider.dart';
import 'package:chomskyspark/screens/paretns-monitoring/children_page.dart';
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
import 'package:qr_flutter/qr_flutter.dart';
import '../../../utils/auth_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LearnedWordProvider learnedWordProvider = LearnedWordProvider();
  final UserProvider userProvider = UserProvider();
  int learnerWordsCounter = 0;

  List<MapEntry<int, String>> childrenList = [];

  @override
  void initState() {
    super.initState();
    loadChildren();
  }

  Future<void> loadLearnedWordsCounter() async {
    try {
      int counter = await learnedWordProvider.getLearnedWordsCount(Authorization.childLogged ? Authorization.user!.id! : Authorization.selectedChildId!);
      setState(() {
        learnerWordsCounter = counter;
      });
    } catch (error) {
      print("Error loading learned words counter: $error");
    }
  }

  Future<void> loadChildren() async {
    var data = await userProvider.getDropdownChildren();

    if (data.isNotEmpty){
      if (Authorization.selectedChildId == null){
        Authorization.selectedChildId = data.first.key;
        loadLearnedWordsCounter();
      }
    }
    else{
      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.85,
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFFF3E5F5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.child_care_sharp,
                      size: 40,
                      color: Color(0xFF9C27B0),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Add Your First Child',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF422A74),
                    ),
                  ),
                  SizedBox(height: 12),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'To get started with all features, you need to add at least one child account.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: 120,
                          maxWidth: 150,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ChildrenPage()),
                            );
                          },
                          child: Text('Ok'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    setState(() {
      childrenList = data;
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        onDrawerChanged: (isOpened) {
          if (isOpened) {
            loadChildren();
          }
        },
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
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => GenerateQrPage())
                              );
                            },
                            child: Container(
                              width: 170,
                              height: 170,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: QrImageView(
                                  data: "${Authorization.selectedChildId ?? Authorization.user!.id}",
                                  size: 165,
                                  embeddedImageStyle: QrEmbeddedImageStyle(
                                    size: const Size(165, 165),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          // Add the dropdown here
                          if (childrenList.isNotEmpty)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButton<int>(
                                hint: Text('Select Child'),
                                value: Authorization.selectedChildId,
                                icon: Icon(Icons.arrow_drop_down, color: Color(0xFF422A74)),
                                iconSize: 24,
                                elevation: 16,
                                style: TextStyle(color: Color(0xFF422A74)),
                                underline: Container(),
                                isExpanded: true,
                                onChanged: (int? newValue) {
                                  setState(() {
                                    Authorization.selectedChildId = newValue;
                                    loadLearnedWordsCounter();
                                  });
                                },
                                items: childrenList.map<DropdownMenuItem<int>>((child) {
                                  return DropdownMenuItem<int>(
                                    value: child.key,
                                    child: Text(
                                      child.value,
                                      style: TextStyle(fontSize: 14),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
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
                            userId: Authorization.selectedChildId!,
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
                            userId: Authorization.selectedChildId!,
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
                            userId: Authorization.selectedChildId!,
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
                            userId: Authorization.selectedChildId!,
                          ),
                        ),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.bookmarks_outlined,
                    title: 'Words for Images',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WordForImagePage(),
                        ),
                      );
                    },
                  ),
                  //Divider(),
                  _buildDrawerItem(
                    context,
                    icon: Icons.child_care_sharp,
                    title: 'Children',
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChildrenPage(),
                        ),
                      );
                      loadChildren();
                    },
                  ),
                ],
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
                      Authorization.childLogged ? SizedBox(height: 48) :
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
                                learnerWordsCounter.toString(),
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF422A74),
                                ),
                              ),
                              Text(
                                'Learned\nWords',
                                textAlign: TextAlign.center,
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
                //Spacer(),
                SizedBox(height: 80),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
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
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FindObjectsPage(),
                                      ),
                                    );
                                    loadLearnedWordsCounter();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        'assets/images/find_object.png',
                                        fit: BoxFit.cover,
                                        height: 95,
                                        width: 95,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Find Objects',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF9D58D5),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 9),
                          Column(
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
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DiscoverWordsPage(),
                                      ),
                                    );
                                    loadLearnedWordsCounter();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        'assets/images/discover_word.png',
                                        fit: BoxFit.cover,
                                        height: 95,
                                        width: 95,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Discover Words',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF9D58D5),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 9),
                          Column(
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
                                child: ElevatedButton(
                                  onPressed: () {
                                    testFileUpload(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        'assets/images/take_photo.png',
                                        fit: BoxFit.cover,
                                        height: 95,
                                        width: 95,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Take Photo',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF9D58D5),
                                ),
                              ),
                            ],
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

      //var imageUrl = "https://images.unsplash.com/photo-1592199279376-d48388291e22?q=80&w=2076&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ObjectDetectionPage(
            imageUrl: imageUrl,
          ),
        ),
      );
      loadLearnedWordsCounter();
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
    imageUrl = "https://images.unsplash.com/photo-1592199279376-d48388291e22?q=80&w=2076&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ObjectDetectionPage(
          imageUrl: "${imageUrl}",
        ),
      ),
    );
  }
}
