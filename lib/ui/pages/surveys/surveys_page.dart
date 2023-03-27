import 'package:carousel_slider/carousel_slider.dart';
import 'package:clean_flutter_login_app/ui/helpers/i18n/resources.dart';
import 'package:clean_flutter_login_app/ui/pages/surveys/survey_viewmodel.dart';
import 'package:clean_flutter_login_app/ui/pages/surveys/surveys_presenter.dart';
import 'package:flutter/material.dart';

import '../../components/loading_dialog.dart';
import '../../components/reload_screen.dart';
import 'components/survey_item.dart';
import 'components/survey_itens.dart';

class SurveysPage extends StatelessWidget {
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
                  );
                }
                return Container();
              });
        },
      ),
    );
  }
}
