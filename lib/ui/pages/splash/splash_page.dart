import 'package:clean_flutter_login_app/ui/mixins/navigation_manager.dart';
import 'package:clean_flutter_login_app/ui/pages/splash/splash_presenter.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget with NavigationManager {
  final SplashPresenter presenter;

  const SplashPage({super.key, required this.presenter});

  @override
  Widget build(BuildContext context) {
    presenter.checkAccount();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clean Flutter'),
        centerTitle: true,
      ),
      body: Builder(builder: (context) {
        handleNavigation(
          context: context,
          stream: presenter.navigateToStream,
          clear: true,
        );

        return const Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}
