import 'package:clean_flutter_login_app/ui/pages/survey_result/survey_result_presenter.dart';
import 'package:flutter/material.dart';

import '../../components/loading_dialog.dart';
import '../../components/reload_screen.dart';
import 'components/survey_result.dart';

class SurveyResultPage extends StatelessWidget {
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
        presenter!.isLoadingStream.listen(
          (isLoading) {
            if (isLoading) {
              loadingDialog(context);
            } else {
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop();
              }
            }
          },
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
