import 'package:clean_flutter_login_app/main/factories/pages/login/login_presenter_factory.dart';
import 'package:clean_flutter_login_app/ui/pages/login/login_page.dart';
import 'package:flutter/widgets.dart';

Widget makeLoginPage() => LoginPage(presenter: makeLoginPresenter());
