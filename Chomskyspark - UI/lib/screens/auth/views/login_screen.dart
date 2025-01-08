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
                  LogInForm(formKey: _formKey,
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
                    height: size.height > 700
                        ? size.height * 0.1
                        : defaultPadding,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        if (_formKey.currentState!.validate()) {
                          Authorization.user = await _userProvider.login(_emailController.text, _passwordController.text);
                          Navigator.popAndPushNamed(
                              context, homeScreenRoute);
                        }
                      } on Exception {
                        _emailController.text = _passwordController.text = "";
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text("Login failed"),
                            content: const Text("Invalid username and/or password"),
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
<<<<<<< Updated upstream
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
=======
>>>>>>> Stashed changes
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
