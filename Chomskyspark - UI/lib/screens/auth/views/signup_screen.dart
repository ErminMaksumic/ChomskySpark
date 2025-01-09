import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/user_provider.dart';
import 'package:shop/screens/auth/views/components/sign_up_form.dart';
import 'package:shop/route/route_constants.dart';
import '../../../constants.dart';
import '../../../models/language.dart';
import '../../../providers/language_provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late UserProvider _userProvider;
  late LanguageProvider _languageProvider;
  late Future<List<Language>> _languagesFuture;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();

  int? primaryLanguageId;
  int? secondaryLanguageId;

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _languageProvider = Provider.of(context, listen: false);

    _languagesFuture = _fetchLanguages();
  }

  Future<List<Language>> _fetchLanguages() async {
    return await _languageProvider.get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/images/signup.png",
              height: MediaQuery.of(context).size.height * 0.35, // Adjusted height
              width: double.infinity,
              fit: BoxFit.cover, // Ensures the image is fully visible and fits the space
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Let’s get started!",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  const Text(
                    "Please complete the form below to register your account.",
                  ),
                  const SizedBox(height: defaultPadding),
                  FutureBuilder<List<Language>>(
                    future: _languagesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else if (snapshot.hasData) {
                        return SignUpForm(
                          formKey: _formKey,
                          firstNameController: _firstNameController,
                          lastNameController: _lastNameController,
                          emailController: _emailController,
                          passwordController: _passwordController,
                          passwordConfirmationController:
                              _passwordConfirmationController,
                          languages: snapshot.data!,
                          onLanguageSelected: (primaryId, secondaryId) {
                            primaryLanguageId = primaryId;
                            secondaryLanguageId = secondaryId;
                          },
                        );
                      } else {
                        return const Text("No languages available");
                      }
                    },
                  ),
                  const SizedBox(height: defaultPadding * 2),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple, // Purple background color
                      foregroundColor: Colors.white, // White text color
                      padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15), // Padding similar to HomeScreen button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Rounded corners
                      ),
                      shadowColor: Colors.black.withOpacity(0.4), // Increased shadow opacity
                      elevation: 15, // Increased elevation for stronger shadow
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _register();
                      }
                    },
                    child: const Text("Submit", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Do you have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, logInScreenRoute);
                        },
                        child: const Text("Log in"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _register() async {
    try {
      var user = await _userProvider.register({
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'passwordConfirmation': _passwordConfirmationController.text,
        'primaryLanguageId': primaryLanguageId,
        'secondaryLanguageId': secondaryLanguageId,
      });

      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Success"),
          content: Text(
              "You are registered as ${_firstNameController.text} ${_lastNameController.text}"),
          actions: [
            TextButton(
              onPressed: () async => await Navigator.popAndPushNamed(
                context,
                emptyPaymentScreenRoute,
              ),
              child: const Text("Ok"),
            ),
          ],
        ),
      );
    } on Exception catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Error"),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Ok"),
            ),
          ],
        ),
      );
    }
  }
}
