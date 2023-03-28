import 'package:clean_flutter_login_app/ui/mixins/loading_manager.dart';
import 'package:clean_flutter_login_app/ui/mixins/session_manager.dart';
import 'package:clean_flutter_login_app/ui/pages/survey_result/survey_result_presenter.dart';
import 'package:flutter/material.dart';

import '../../components/reload_screen.dart';
import 'components/survey_result.dart';

class SurveyResultPage extends StatelessWidget
    with LoadingManager, SessionManager {
  final SurveyResultPresenter? presenter;

  const SurveyResultPage({super.key, required this.presenter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enquente'),
        centerTitle: true,
      ),
      body: Builder(builder: (context) {
        handleLoading(
          context: context,
          stream: presenter!.isLoadingStream,
        );

        handleSession(
          context: context,
          stream: presenter!.isSessionExpiredStream,
        );

        presenter?.loadData();
        return StreamBuilder(
            stream: presenter!.surveyResultStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return ReloadScreen(
                  error: snapshot.error.toString(),
                  reload: presenter!.loadData,
                );
              }
              if (snapshot.hasData) {
                return SurveyResult(
                  viewModel: snapshot.data!,
                );
              }
              return Container();
            });
      }),
    );
  }
}
