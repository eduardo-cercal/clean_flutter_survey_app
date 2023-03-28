import 'package:clean_flutter_login_app/main/factories/pages/survey_result/survey_result_presenter.factory.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../ui/pages/survey_result/survey_result_page.dart';

Widget makeSurveyResultPage() => SurveyResultPage(
      presenter: makeGetxSurveyResultPresenter(Get.parameters['survey_id']!),
    );
