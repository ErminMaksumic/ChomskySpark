import 'package:flutter/material.dart';
import '../../../../constants.dart';
import '../../../../models/language.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm(
      {super.key,
      required this.formKey,
      required this.firstNameController,
      required this.lastNameController,
      required this.emailController,
      required this.passwordController,
      required this.passwordConfirmationController,
      required this.languages,
      required this.onLanguageSelected});

  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController passwordConfirmationController;
  final List<Language> languages;
  final Function(int?, int?) onLanguageSelected;

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  int? primaryLanguageId;
  int? secondaryLanguageId;
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
          const SizedBox(height: 16),
          _buildDropdownField(
            context: context,
            hintText: "Primary Language",
            value: primaryLanguageId,
            languages: widget.languages,
            onChanged: (value) {
              setState(() {
                primaryLanguageId = value;
              });
              widget.onLanguageSelected(primaryLanguageId, secondaryLanguageId);
            },
          ),
          const SizedBox(height: 16),
          _buildDropdownField(
            context: context,
            hintText: "Secondary Language",
            value: secondaryLanguageId,
            languages: widget.languages,
            onChanged: (value) {
              setState(() {
                secondaryLanguageId = value;
              });
              widget.onLanguageSelected(primaryLanguageId, secondaryLanguageId);
            },
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
              if (value == null || value != widget.passwordController.text) {
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

  Widget _buildDropdownField({
    required BuildContext context,
    required String hintText,
    required int? value,
    required List<Language> languages,
    required ValueChanged<int?> onChanged,
  }) {
    return DropdownButtonFormField<int>(
      value: value,
      decoration: InputDecoration(hintText: hintText),
      items: languages.map((item) {
        return DropdownMenuItem<int>(
          value: item.id,
          child: Text(item.name ?? ''),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
