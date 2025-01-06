import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title Section
              const Text(
                "Chomskyspark",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              // Subtitle Section
              const Text(
                "Join the Word Quest - Snap, Seek and Speak",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),
              // Image Section with Shadow
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25), // Shadow color
                        spreadRadius: 5, // Shadow spread
                        blurRadius: 7, // Shadow blur effect
                        offset: const Offset(0, 3), // Shadow direction
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/chomskyspark.png', // Replace with your image path
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Button Section with Shadow
              ElevatedButton.icon(
                onPressed: () {
                  // Add button action here
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 5, // Add shadow to the button
                ),
                icon: const Icon(
                  Icons.camera_alt_outlined, // Camera icon
                  color: Colors.white,
                ),
                label: const Text(
                  "Take a picture",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
