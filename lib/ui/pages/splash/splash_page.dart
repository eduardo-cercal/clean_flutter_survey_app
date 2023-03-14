import 'package:clean_flutter_login_app/ui/pages/splash/splash_presenter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends StatelessWidget {
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
        presenter.navigateToStream.listen((page) {
          if (page != null && page.isNotEmpty) {
            Get.offAllNamed(page);
          }
        });
        return const Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}
