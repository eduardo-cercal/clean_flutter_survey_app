import 'package:carousel_slider/carousel_slider.dart';
import 'package:clean_flutter_login_app/ui/pages/surveys/surveys_presenter.dart';
import 'package:flutter/material.dart';

import '../survey_viewmodel.dart';
import 'survey_item.dart';

class SurveyItens extends StatelessWidget {
  final List<SurveyViewModel> viewModel;
  final SurveysPresenter presenter;

  const SurveyItens({
    super.key,
    required this.viewModel,
    required this.presenter,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      child: CarouselSlider(
        items: viewModel
            .map((viewModel) => SurveyItem(
                  viewModel: viewModel,
                  onTap: () => presenter.goToSurveyResult(viewModel.id),
                ))
            .toList(),
        options: CarouselOptions(
          enlargeCenterPage: true,
          aspectRatio: 1,
        ),
      ),
    );
  }
}
