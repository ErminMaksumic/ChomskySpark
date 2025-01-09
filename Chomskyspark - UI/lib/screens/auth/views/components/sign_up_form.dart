import 'package:flutter/material.dart';
import '../../../../constants.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.passwordController,
    required this.passwordConfirmationController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController passwordConfirmationController;

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          _buildTextField(
            controller: widget.firstNameController,
            hintText: "First Name",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your first name';
              }
              return null;
            },
          ),
          const SizedBox(height: defaultPadding),
          _buildTextField(
            controller: widget.lastNameController,
            hintText: "Last Name",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your last name';
              }
              return null;
            },
          ),
          const SizedBox(height: defaultPadding),
          _buildTextField(
            controller: widget.emailController,
            hintText: "Email Address",
            validator: (value) {
              if (value == null || !value.contains('@')) {
                return 'Please enter a valid email address';
              }
              return null;
            },
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: defaultPadding),
          _buildTextField(
            controller: widget.passwordController,
            hintText: "Password",
            validator: (value) {
              if (value == null || value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
            obscureText: true,
          ),
          const SizedBox(height: defaultPadding),
          _buildTextField(
            controller: widget.passwordConfirmationController,
            hintText: "Confirm Password",
            validator: (value) {
              if (value == null ||
                  value != widget.passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
            obscureText: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String? Function(String?) validator,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}