import 'package:clean_flutter_login_app/ui/components/loading_dialog.dart';
import 'package:clean_flutter_login_app/ui/components/snack_bar_error.dart';
import 'package:clean_flutter_login_app/ui/pages/login/components/login_text_form_field.dart';
import 'package:clean_flutter_login_app/ui/pages/login/login_presenter.dart';
import 'package:flutter/material.dart';

import '../../components/headline_1.dart';
import '../../components/login_header.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter? presenter;

  const LoginPage({super.key, required this.presenter});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    widget.presenter?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          widget.presenter?.loadingStream?.listen((isLoading) {
            if (isLoading) {
              loadingDialog(context);
            } else {
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              }
            }
          });
          widget.presenter?.mainErrorStream?.listen((error) {
            if (error != null) {
              snackBarError(context: context, error: error);
            }
          });
          return SingleChildScrollView(
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
                        LoginTextFormField(
                          text: 'Email',
                          icon: Icons.email,
                          isPassword: false,
                          onChanged: widget.presenter?.validateEmail,
                          stream: widget.presenter?.emailErrorStream,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 8.0,
                            bottom: 32,
                          ),
                          child: LoginTextFormField(
                            text: 'Senha',
                            icon: Icons.lock,
                            isPassword: true,
                            onChanged: widget.presenter?.validatePassword,
                            stream: widget.presenter?.passwordErrorStream,
                          ),
                        ),
                        StreamBuilder<bool>(
                            stream: widget.presenter?.formValidStream,
                            builder: (context, snapshot) {
                              return ElevatedButton(
                                onPressed: snapshot.data == true
                                    ? widget.presenter?.auth
                                    : null,
                                child: Text('Entrar'.toUpperCase()),
                              );
                            }),
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
          );
        },
      ),
    );
  }
}
