import 'package:clean_flutter_login_app/presentation/minixs/navigation_manager.dart';
import 'package:get/get.dart';

import '../../../domain/usecases/load_current_account.dart';
import '../../../ui/pages/splash/splash_presenter.dart';

class GetxSplashPresenter extends GetxController
    with NavigationManager
    implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;

  GetxSplashPresenter(this.loadCurrentAccount);

  @override
  Future<void> checkAccount({int durationInSeconds = 2}) async {
    await Future.delayed(Duration(seconds: durationInSeconds));
    try {
      final result = await loadCurrentAccount.load();
      navigateTo = result?.token != null ? '/survey' : '/login';
    } catch (error) {
      navigateTo = '/login';
    }
  }
}
