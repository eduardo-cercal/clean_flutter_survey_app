import 'package:clean_flutter_login_app/ui/pages/login/components/login_text_form_field.dart';
import 'package:flutter/material.dart';

import '../../components/headline_1.dart';
import '../../components/login_header.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const LoginHeader(),
            const Headline1(text: 'Login'),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                child: Column(
                  children: [
                    const LoginTextFormField(
                      text: 'Email',
                      icon: Icons.email,
                      isPassword: false,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 8.0,
                        bottom: 32,
                      ),
                      child: LoginTextFormField(
                        text: 'Senha',
                        icon: Icons.lock,
                        isPassword: true,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('Entrar'.toUpperCase()),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.person),
                      label: const Text('Criar conta'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
