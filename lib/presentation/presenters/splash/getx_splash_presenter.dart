import 'package:get/get.dart';

import '../../../domain/usecases/load_current_account.dart';
import '../../../ui/pages/splash/splash_presenter.dart';

class GetxSplashPresenter extends GetxController implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;
  final _navigateTo = RxnString();

  GetxSplashPresenter(this.loadCurrentAccount);

  @override
  Stream<String?> get navigateToStream => _navigateTo.stream;

  @override
  Future<void> checkAccount({int durationInSeconds = 2}) async {
    await Future.delayed(Duration(seconds: durationInSeconds));
    try {
      final result = await loadCurrentAccount.load();
      _navigateTo.value = result?.token != null ? '/survey' : '/login';
    } catch (error) {
      _navigateTo.value = '/login';
    }
  }
}
