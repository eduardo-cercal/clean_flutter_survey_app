import 'package:clean_flutter_login_app/main/factories/pages/login/login_presenter_factory.dart';
import 'package:clean_flutter_login_app/main/factories/pages/sign_up/sign_up_presenter_factory.dart';
import 'package:clean_flutter_login_app/ui/pages/login/login_page.dart';
import 'package:flutter/widgets.dart';

import '../../../../ui/pages/signup/signup_page.dart';

Widget makeSignUpPage() => SignUpPage(presenter: makeGetxSignUpPresenter());
