import 'package:clean_flutter_login_app/ui/mixins/keyboard_manager.dart';
import 'package:clean_flutter_login_app/ui/mixins/loading_manager.dart';
import 'package:clean_flutter_login_app/ui/mixins/navigation_manager.dart';
import 'package:clean_flutter_login_app/ui/mixins/ui_error_manager.dart';
import 'package:clean_flutter_login_app/ui/pages/signup/signup_presenter.dart';
import 'package:flutter/material.dart';

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

class _SignUpPageState extends State<SignUpPage>
    with KeyboardManager, LoadingManager, UiErrorManager, NavigationManager {
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
          handleLoading(
            context: context,
            stream: widget.presenter?.isLoadingStream,
          );

          handleMainError(
            context: context,
            stream: widget.presenter?.mainErrorStream,
          );

          handleNavigation(
            widget.presenter?.navigateToStream,
            clear: true,
          );

          return GestureDetector(
            onTap: () => hideKeyboard(context),
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
                              stream: widget.presenter?.isFormValidStream,
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
                            onPressed: widget.presenter?.goToLogin,
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
}
