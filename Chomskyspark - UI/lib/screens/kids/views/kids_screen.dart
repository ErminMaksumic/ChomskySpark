import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class KidsScreen extends StatefulWidget {
  const KidsScreen({super.key});

  @override
  _KidsScreenState createState() => _KidsScreenState();
}

class _KidsScreenState extends State<KidsScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    // Initialize the confetti controller with a duration of 10 seconds.
    _confettiController = ConfettiController(duration: const Duration(seconds: 10));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _showConfettiPopup() {
    // Show a dialog with the confetti animation
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
              Navigator.pop(context); // Close the dialog
              _confettiController.stop(); // Stop confetti animation when the dialog is closed
            },
            child: const Text("OK", style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );

    // Start the confetti animation when the popup is shown
    _confettiController.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      body: Center(
        child: ElevatedButton(
          onPressed: _showConfettiPopup,
          child: const Text("Show Confetti!", style: TextStyle(fontSize: 18)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent, // Correct way to set the button background color
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),
    );
  }
}



