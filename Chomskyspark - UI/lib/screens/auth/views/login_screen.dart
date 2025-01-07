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
            Image.asset(
              "assets/images/login.png",
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome back!",
                    style: Theme.of(context).textTheme.headlineSmall,
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
                    height:
                        size.height > 700 ? size.height * 0.1 : defaultPadding,
                  ),
                  ElevatedButton(
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
                    child: const Text("Log in"),
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

  //TODO: Remove after testing
  Future<void> testFileUpload2() async {

      var imageUrl = "/uploads/chomskyspark/20250107_001739_914122bb-47ac-4e9b-b112-48c8598e56f3(1).jpg";//await fileProvider.sendFile(file);
      imageUrl = "/uploads/chomskyspark/Screenshot_1_95019f70-79eb-40aa-9498-6868e1a81690.png";
      ObjectDetectionProvider objectDetectionProvider = ObjectDetectionProvider();
      final recognizedObjects = await objectDetectionProvider.detectImage("https://api.thorhof-bestellungen.at${imageUrl}");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ObjectDetectionPage(
            recognizedObjects: recognizedObjects,
            imageUrl: "https://api.thorhof-bestellungen.at${imageUrl}",
          ),
        ),
      );
      print(recognizedObjects);
  }
}


