import 'package:clean_flutter_login_app/ui/helpers/errors/ui_error.dart';
import 'package:flutter/material.dart';

class LoginTextFormField extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool isPassword;
  final Function(String text)? onChanged;
  final Stream<UiError?>? stream;

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
    return StreamBuilder<UiError?>(
        stream: stream,
        builder: (context, snapshot) {
          return TextFormField(
            decoration: InputDecoration(
              labelText: text,
              icon: Icon(
                icon,
                color: Theme.of(context).primaryColorLight,
              ),
              errorText: snapshot.hasData ? snapshot.data?.description : null,
            ),
            obscureText: isPassword,
            onChanged: onChanged,
          );
        });
  }
}
