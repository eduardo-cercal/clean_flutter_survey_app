import 'package:flutter/material.dart';

class LoginTextFormField extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool isPassword;

  const LoginTextFormField({
    super.key,
    required this.text,
    required this.icon,
    required this.isPassword,
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
      ),
      obscureText: isPassword,
    );
  }
}
