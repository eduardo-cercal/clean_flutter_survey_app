import 'package:clean_flutter_login_app/presentation/presenters/surveys/getx_surveys_presenter.dart';
import 'package:clean_flutter_login_app/ui/pages/surveys/surveys_presenter.dart';

import '../../usecases/load_surveys_factory.dart';

SurveysPresenter makeSurveysPresenter() =>
    GetxSurveysPresenter(makeRemoteLoadSurveysWithLocalFallback());
