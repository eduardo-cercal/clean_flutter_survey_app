import 'package:clean_flutter_login_app/ui/components/loading_dialog.dart';
import 'package:clean_flutter_login_app/ui/components/snack_bar_error.dart';
import 'package:clean_flutter_login_app/ui/helpers/errors/ui_error.dart';
import 'package:clean_flutter_login_app/ui/pages/login/components/login_text_form_field.dart';
import 'package:clean_flutter_login_app/ui/pages/login/login_presenter.dart';
import 'package:clean_flutter_login_app/ui/pages/signup/signup_presenter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helpers/i18n/resources.dart';
import '../../components/headline_1.dart';
import '../../components/login_header.dart';
import 'components/signup_text_form_field.dart';

class SignUpPage extends StatefulWidget {
  final SignUpPresenter? presenter;

  const SignUpPage({super.key, required this.presenter});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
              snackBarError(context: context, error: error.description);
            }
          });

          widget.presenter?.navigateToStream?.listen((page) {
            if (page != null && page.isNotEmpty) {
              Get.offAllNamed(page);
            }
          });
          return GestureDetector(
            onTap: _hideKeyboard,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const LoginHeader(),
                  Headline1(text: R.strings.addAccount),
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Form(
                      child: Column(
                        children: [
                          SignUpTextFormField(
                            text: R.strings.name,
                            icon: Icons.person,
                            isPassword: false,
                            onChanged: widget.presenter?.validateName,
                            stream: widget.presenter?.nameErrorStream,
                            keyboardType: TextInputType.name,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: SignUpTextFormField(
                              text: R.strings.email,
                              icon: Icons.email,
                              isPassword: false,
                              onChanged: widget.presenter?.validateEmail,
                              stream: widget.presenter?.emailErrorStream,
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          SignUpTextFormField(
                            text: R.strings.password,
                            icon: Icons.lock,
                            isPassword: true,
                            onChanged: widget.presenter?.validatePassword,
                            stream: widget.presenter?.passwordErrorStream,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 32),
                            child: SignUpTextFormField(
                              text: R.strings.confirmPassword,
                              icon: Icons.lock,
                              isPassword: true,
                              onChanged: widget
                                  .presenter?.validatePasswordConfirmation,
                              stream: widget
                                  .presenter?.passwordConfirmationErrorStream,
                            ),
                          ),
                          StreamBuilder<bool>(
                              stream: widget.presenter?.formValidStream,
                              builder: (context, snapshot) {
                                return ElevatedButton(
                                  onPressed: snapshot.data == true
                                      ? widget.presenter?.signUp
                                      : null,
                                  child:
                                      Text(R.strings.addAccount.toUpperCase()),
                                );
                              }),
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.exit_to_app),
                            label: Text(R.strings.login),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _hideKeyboard() {
    final currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}
