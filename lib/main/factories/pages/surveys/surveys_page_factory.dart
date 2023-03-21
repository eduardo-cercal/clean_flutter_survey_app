import 'package:clean_flutter_login_app/main/factories/pages/surveys/surveys_presenter.factory.dart';
import 'package:flutter/material.dart';

import '../../../../ui/pages/surveys/surveys_page.dart';

Widget makeSurveysPage() => SurveysPage(
      presenter: makeSurveysPresenter(),
    );
