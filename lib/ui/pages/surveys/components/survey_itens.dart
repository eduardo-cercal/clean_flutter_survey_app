import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../survey_viewmodel.dart';
import 'survey_item.dart';

class SurveyItens extends StatelessWidget {
  final List<SurveyViewModel> viewModel;

  const SurveyItens({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      child: CarouselSlider(
        items: viewModel
            .map((viewModel) => SurveyItem(viewModel: viewModel))
            .toList(),
        options: CarouselOptions(
          enlargeCenterPage: true,
          aspectRatio: 1,
        ),
      ),
    );
  }
}
