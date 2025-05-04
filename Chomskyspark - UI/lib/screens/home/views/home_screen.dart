import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:chomskyspark/providers/file_provider.dart';
import 'package:chomskyspark/screens/interactive-page/discover_words.dart';
import 'package:chomskyspark/screens/interactive-page/find_objects.dart';
import 'package:chomskyspark/screens/interactive-page/object_detection.dart';
import 'package:chomskyspark/screens/story/story_page.dart'; // ✅ one canonical import
import 'package:chomskyspark/screens/paretns-monitoring/child_improvement_areas.dart';
import 'package:chomskyspark/screens/paretns-monitoring/child_statistics.dart';
import 'package:chomskyspark/screens/paretns-monitoring/child_words_statistics.dart';
import 'package:chomskyspark/screens/paretns-monitoring/child_daily_statistics.dart';
import 'package:chomskyspark/screens/paretns-monitoring/word_for_image.dart';
import 'package:chomskyspark/screens/qr_code/generate_qr.dart';

import 'package:qr_flutter/qr_flutter.dart';
import '../../../utils/auth_helper.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: _AppDrawer(),
        body: Stack(
          children: [
            // ---- background image -------------------------------------------------
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // ---- main content -----------------------------------------------------
            Column(
              children: [
                // ---------- header (title + menu) ---------------------------------
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF422A74).withOpacity(.2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Chomskyspark',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Pacifico',
                          color: Colors.white,
                        ),
                      ),
                      if (!Authorization.childLogged)
                        Builder(
                          builder: (context) => IconButton(
                            icon: const Icon(Icons.menu, color: Colors.white),
                            onPressed: () => Scaffold.of(context).openDrawer(),
                          ),
                        ),
                    ],
                  ),
                ),

                // ---------- counter badge -----------------------------------------
                Padding(
                  padding: const EdgeInsets.only(top: 9),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF9D58D5).withOpacity(.3),
                          spreadRadius: 4,
                          blurRadius: 8,
                          offset: const Offset(4, 4),
                        ),
                      ],
                    ),
                    child: const CircleAvatar(
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
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF422A74),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // ---------- four action buttons ------------------------------------
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 9,
                    runSpacing: 20,
                    children: [
                      _HomeActionButton(
                        asset: 'assets/images/find_object.png',
                        label: 'Find Objects',
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => FindObjectsPage()),
                        ),
                      ),
                      _HomeActionButton(
                        asset: 'assets/images/discover_word.png',
                        label: 'Discover Words',
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => DiscoverWordsPage()),
                        ),
                      ),
                      _HomeActionButton(
                        asset: 'assets/images/take_photo.png',
                        label: 'Take Photo',
                        onPressed: () => testFileUpload(context),
                      ),
                      _HomeActionButton(
                        asset: 'assets/images/story.png',
                        label: 'Stories',
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const StoryPage()),
                        ),
                      ),
                    ],
                  ),
                ),

                // ---------- promo / hero image -------------------------------------
                Container(
                  height: 230,
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/image.png'),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.3),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(4, 4),
                      ),
                    ],
                  ),
                ),

                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------- helpers ------------------------------------------

  Future<void> testFileUpload(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile == null) {
      debugPrint('No file selected.');
      return;
    }

    final file = File(pickedFile.path);
    final fileProvider = FileProvider();

    String imageUrl = await fileProvider.sendFile(file);
    imageUrl = "https://api.thorhof-bestellungen.at$imageUrl";

    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ObjectDetectionPage(imageUrl: imageUrl),
      ),
    );
  }
}

// ==============================================================================
//  SMALL WIDGETS
// ==============================================================================

class _HomeActionButton extends StatelessWidget {
  const _HomeActionButton({
    required this.asset,
    required this.label,
    required this.onPressed,
  });

  final String asset;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF9D58D5),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.2),
                spreadRadius: 2,
                blurRadius: 2,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  asset,
                  height: 95,
                  width: 95,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF9D58D5),
          ),
        ),
      ],
    );
  }
}

class _AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          // --------- purple background + scattered stars ------------------------
          Container(
            decoration: const BoxDecoration(color: Color(0xFF422A74)),
            child: const _ScatteredStars(),
          ),

          // --------- main drawer content ---------------------------------------
          ListView(
            padding: EdgeInsets.zero,
            children: [
              // Header
              Container(
                height: 150,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                alignment: Alignment.centerLeft,
                child: const Icon(Icons.star, size: 48, color: Colors.yellow),
              ),

              // QR code
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => GenerateQrPage()),
                      ),
                      child: Container(
                        width: 170,
                        height: 170,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: QrImageView(
                            data: "${Authorization.user!.id}",
                            size: 165,
                            embeddedImageStyle: const QrEmbeddedImageStyle(
                                size: Size(165, 165)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Link the child's device",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Menu items
              _drawerItem(
                context,
                icon: Icons.pie_chart,
                title: 'Child Statistic',
                builder: (_) => ChildStatisticsPage(
                  userId: Authorization.user!.id!,
                ),
              ),
              _drawerItem(
                context,
                icon: Icons.format_quote,
                title: 'Child Word Statistic',
                builder: (_) => ChildWordsStatisticsPage(
                  userId: Authorization.user!.id!,
                ),
              ),
              _drawerItem(
                context,
                icon: Icons.date_range,
                title: 'Child Daily Statistic',
                builder: (_) => ChildDailyStatistics(
                  userId: Authorization.user!.id!,
                ),
              ),
              _drawerItem(
                context,
                icon: Icons.show_chart_outlined,
                title: 'Child Improvement Areas',
                builder: (_) => ChildImprovementAreasPage(
                  userId: Authorization.user!.id!,
                ),
              ),
              _drawerItem(
                context,
                icon: Icons.bookmarks_outlined,
                title: 'Words for Images',
                builder: (_) => WordForImagePage(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Drawer helper
  Widget _drawerItem(BuildContext context,
      {required IconData icon,
      required String title,
      required WidgetBuilder builder}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: builder)),
      hoverColor: Colors.purple.withOpacity(.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}

class _ScatteredStars extends StatelessWidget {
  const _ScatteredStars();

  @override
  Widget build(BuildContext context) {
    // just a handful of positioned icons for the decorative background
    return const Stack(
      children: [
        Positioned(
            top: 20,
            left: 20,
            child: Icon(Icons.star, color: Colors.yellow, size: 24)),
        Positioned(
            top: 50,
            right: 30,
            child: Icon(Icons.star, color: Colors.yellow, size: 18)),
        Positioned(
            bottom: 40,
            left: 40,
            child: Icon(Icons.star, color: Colors.yellow, size: 22)),
        Positioned(
            bottom: 80,
            right: 20,
            child: Icon(Icons.star, color: Colors.yellow, size: 20)),
        Positioned(
            top: 100,
            left: 100,
            child: Icon(Icons.star, color: Colors.yellow, size: 16)),
      ],
    );
  }
}
