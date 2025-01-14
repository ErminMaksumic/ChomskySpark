import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/constants.dart';
import 'package:shop/providers/object_detection_provider.dart';
import 'package:shop/providers/user_provider.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/screens/interactive-page/object-detection.dart';
import 'package:shop/utils/auth_helper.dart';
import 'package:shop/utils/colors_util.dart';
import '../../../providers/file_provider.dart';
import 'components/login_form.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late UserProvider _userProvider;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of(context, listen: false);
    _emailController.text = "ime.prezime@edu.fit.ba";
    _passwordController.text = "Test1234";
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Modern Image Styling
            Container(
              margin: const EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3), // Shadow color
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: Offset(4, 4), // Shadow position
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25), // Match container radius
                child: Image.asset(
                  "assets/images/log2.jpg",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200, // Adjust height as needed
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Back Text
                  Text(
                    "Welcome back!",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF422A74), // Purple color
                    ),
                  ),
                  const SizedBox(height: defaultPadding),
                  LogInForm(
                      formKey: _formKey,
                      emailController: _emailController,
                      passwordController: _passwordController),
                  Align(
                    child: TextButton(
                      child: const Text("Forgot password"),
                      onPressed: () {
                        Navigator.pushNamed(
                            context, passwordRecoveryScreenRoute);
                      },
                    ),
                  ),
                  SizedBox(
                    height: defaultPadding / 2,  // Reduced space
                  ),
                  // Redesigned Log In Button
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF9D58D5), // Use your color palette
                      borderRadius: BorderRadius.circular(15), // Rounded corners
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
                      onPressed: () async {
                        try {
                          if (_formKey.currentState!.validate()) {
                            Authorization.user = await _userProvider.login(
                                _emailController.text, _passwordController.text);
                            Navigator.popAndPushNamed(
                                context, emptyPaymentScreenRoute);
                          }
                        } on Exception {
                          _emailController.text = _passwordController.text = "";
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text("Login failed"),
                              content:
                                  const Text("Invalid username and/or password"),
                              actions: [
                                TextButton(
                                  child: const Text("Ok"),
                                  onPressed: () => Navigator.pop(context),
                                )
                              ],
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent, // Transparent to show shadow
                        foregroundColor: Colors.white, // White text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15), // Rounded corners
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15), // Button height
                        minimumSize: Size(double.infinity, 50), // Full width
                      ),
                      child: const Text("Log in"),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, signUpScreenRoute);
                        },
                        child: const Text("Sign up"),
                      )
                    ],
                  ),
                  ElevatedButton(
                    onPressed: testFileUpload,
                    child: Text('Upload File'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "tts");
                        },
                        child: const Text("Text to Speech Test"),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "interactive-page");
                        },
                        child: const Text("interactive-page"),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> testFileUpload() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      File file = File(pickedFile.path);

      FileProvider fileProvider = FileProvider();
      var imageUrl = await fileProvider.sendFile(file);
      imageUrl = "https://api.thorhof-bestellungen.at${imageUrl}";

      ObjectDetectionProvider objectDetectionProvider = ObjectDetectionProvider();
      final recognizedObjects = await objectDetectionProvider.detectImage(imageUrl);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ObjectDetectionPage(
            recognizedObjects: recognizedObjects,
            imageUrl: imageUrl,
          ),
        ),
      );

      print(recognizedObjects);
    } else {
      print('No file selected.');
    }
  }
}