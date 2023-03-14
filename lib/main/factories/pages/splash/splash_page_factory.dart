import 'package:clean_flutter_login_app/main/factories/pages/splash/splash_presenter_factory.dart';
import 'package:flutter/widgets.dart';

import '../../../../ui/pages/splash/splash_page.dart';

Widget makeSplashPage() => SplashPage(presenter: makeGetxSplashPresenter());
