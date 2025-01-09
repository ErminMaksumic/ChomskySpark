import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/constants.dart';
import 'package:shop/providers/user_provider.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/utils/auth_helper.dart';
import 'components/login_form.dart';

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

            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.asset(
                "assets/images/cute.png",
                fit: BoxFit.cover,
              ),
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
                    height: defaultPadding / 2,  // Reduced space
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        if (_formKey.currentState!.validate()) {
                          Authorization.user = await _userProvider.login(
                              _emailController.text, _passwordController.text);
                          Navigator.popAndPushNamed(
                              context, homeScreenRoute);
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,  // Purple background color
                      foregroundColor: Colors.white,  // White text color
                      minimumSize: Size(double.infinity, 60),  // Button height
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),  // Oval corners
                      ),
                      elevation: 15,  // Stronger shadow
                      shadowColor: Colors.black.withOpacity(0.4), // More pronounced shadow
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
