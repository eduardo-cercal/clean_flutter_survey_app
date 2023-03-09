import 'package:flutter/material.dart';

class LoginTextFormField extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool isPassword;
  final Function(String text)? onChanged;
  final String? errorText;

  const LoginTextFormField({
    super.key,
    required this.text,
    required this.icon,
    required this.isPassword,
    required this.onChanged,
    required this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: text,
        icon: Icon(
          icon,
          color: Theme.of(context).primaryColorLight,
        ),
        errorText: errorText,
      ),
      obscureText: isPassword,
      onChanged: onChanged,
    );
  }
}
