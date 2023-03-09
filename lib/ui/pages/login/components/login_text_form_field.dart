import 'package:flutter/material.dart';

class LoginTextFormField extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool isPassword;
  final Function(String text)? onChanged;
  final Stream<String?>? stream;

  const LoginTextFormField({
    super.key,
    required this.text,
    required this.icon,
    required this.isPassword,
    required this.onChanged,
    required this.stream,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String?>(
        stream: stream,
        builder: (context, snapshot) {
          return TextFormField(
            decoration: InputDecoration(
              labelText: text,
              icon: Icon(
                icon,
                color: Theme.of(context).primaryColorLight,
              ),
              errorText: snapshot.data?.isEmpty == true ? null : snapshot.data,
            ),
            obscureText: isPassword,
            onChanged: onChanged,
          );
        });
  }
}
