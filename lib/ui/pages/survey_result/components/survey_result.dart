import 'package:clean_flutter_login_app/ui/pages/survey_result/components/survey_answer.dart';
import 'package:clean_flutter_login_app/ui/pages/survey_result/components/survey_header.dart';
import 'package:clean_flutter_login_app/ui/pages/survey_result/survey_answer_viewmodel.dart';
import 'package:clean_flutter_login_app/ui/pages/survey_result/survey_result_viewmodel.dart';
import 'package:flutter/material.dart';

import 'active_icon.dart';
import 'disable_icon.dart';

class SurveyResult extends StatelessWidget {
  final SurveyResultViewModel viewModel;

  const SurveyResult({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index == 0) {
          return SurveyHeader(question: viewModel.question);
        }
        final item = viewModel.answers[index - 1];
        return SurveyAnswer(item: item);
      },
      itemCount: viewModel.answers.length + 1,
    );
  }
}
