import 'package:carousel_slider/carousel_slider.dart';
import 'package:clean_flutter_login_app/ui/helpers/i18n/resources.dart';
import 'package:clean_flutter_login_app/ui/pages/surveys/survey_viewmodel.dart';
import 'package:clean_flutter_login_app/ui/pages/surveys/surveys_presenter.dart';
import 'package:flutter/material.dart';

import '../../components/loading_dialog.dart';
import 'components/survey_item.dart';

class SurveysPage extends StatelessWidget {
  final SurveysPresenter? presenter;

  const SurveysPage({super.key, required this.presenter});

  @override
  Widget build(BuildContext context) {
    presenter!.loadData();
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
          return StreamBuilder<List<SurveyViewModel>?>(
              stream: presenter?.surveysStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          snapshot.error.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: presenter?.loadData,
                          child: Text(R.strings.reload),
                        )
                      ],
                    ),
                  );
                }
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    child: CarouselSlider(
                      items: snapshot.data!
                          .map((viewModel) => SurveyItem(viewModel: viewModel))
                          .toList(),
                      options: CarouselOptions(
                        enlargeCenterPage: true,
                        aspectRatio: 1,
                      ),
                    ),
                  );
                }
                return Container();
              });
        },
      ),
    );
  }
}
