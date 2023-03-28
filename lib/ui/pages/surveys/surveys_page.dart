import 'package:clean_flutter_login_app/ui/helpers/i18n/resources.dart';
import 'package:clean_flutter_login_app/ui/mixins/loading_manager.dart';
import 'package:clean_flutter_login_app/ui/pages/surveys/survey_viewmodel.dart';
import 'package:clean_flutter_login_app/ui/pages/surveys/surveys_presenter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/loading_dialog.dart';
import '../../components/reload_screen.dart';
import 'components/survey_itens.dart';

class SurveysPage extends StatelessWidget with LoadingManager {
  final SurveysPresenter? presenter;

  const SurveysPage({super.key, required this.presenter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(R.strings.surveys),
      ),
      body: Builder(
        builder: (context) {
          handleLoading(
            context: context,
            stream: presenter!.isLoadingStream,
          );
          presenter!.isSessionExpiredStream.listen(
            (isExpired) {
              if (isExpired != null && isExpired) {
                Get.offAllNamed('/login');
              }
            },
          );
          presenter!.navigateToStream.listen((page) {
            if (page != null && page.isNotEmpty) {
              Get.toNamed(page);
            }
          });
          presenter!.loadData();
          return StreamBuilder<List<SurveyViewModel>?>(
              stream: presenter?.surveysStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return ReloadScreen(
                    error: snapshot.error.toString(),
                    reload: presenter!.loadData,
                  );
                }
                if (snapshot.hasData) {
                  return SurveyItens(
                    viewModel: snapshot.data!,
                    presenter: presenter!,
                  );
                }
                return Container();
              });
        },
      ),
    );
  }
}
