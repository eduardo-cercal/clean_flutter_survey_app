import 'package:clean_flutter_login_app/ui/mixins/loading_manager.dart';
import 'package:clean_flutter_login_app/ui/mixins/navigation_manager.dart';
import 'package:clean_flutter_login_app/ui/mixins/ui_error_manager.dart';
import 'package:clean_flutter_login_app/ui/pages/login/components/login_text_form_field.dart';
import 'package:clean_flutter_login_app/ui/pages/login/login_presenter.dart';
import 'package:flutter/material.dart';

import '../../helpers/i18n/resources.dart';
import '../../components/headline_1.dart';
import '../../components/login_header.dart';
import '../../mixins/keyboard_manager.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter? presenter;

  const LoginPage({super.key, required this.presenter});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
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
            context: context,
            stream: widget.presenter?.navigateToStream,
            clear: true,
          );

          return GestureDetector(
            onTap: () => hideKeyboard(context),
            child: SingleChildScrollView(
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
                              stream: widget.presenter?.isFormValidStream,
                              builder: (context, snapshot) {
                                return ElevatedButton(
                                  onPressed: snapshot.data == true
                                      ? widget.presenter?.auth
                                      : null,
                                  child: Text('Entrar'.toUpperCase()),
                                );
                              }),
                          TextButton.icon(
                            onPressed: widget.presenter?.goToSignUp,
                            icon: const Icon(Icons.person),
                            label: Text(R.strings.addAccount),
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
