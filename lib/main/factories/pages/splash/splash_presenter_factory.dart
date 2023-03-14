import 'package:clean_flutter_login_app/presentation/presenters/splash/getx_splash_presenter.dart';

import '../../../../ui/pages/splash/splash_presenter.dart';
import '../../usecases/load_current_account_factory.dart';

SplashPresenter makeGetxSplashPresenter() =>
    GetxSplashPresenter(makeLocalLoadCurrentAccount());
