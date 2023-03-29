import 'package:clean_flutter_login_app/data/usecases/load_surveys_result/remote_load_survey_result.dart';

import '../../data/usecases/load_surveys_result/local_load_survey_result.dart';
import '../../domain/entities/survey_result_entity.dart';
import '../../domain/helpers/errors/domain_error.dart';
import '../../domain/usecases/load_survey_result.dart';

class RemoteLoadSurveyResultWithLocalFallback implements LoadSurveyResult {
  final RemoteLoadSurveyResult remote;
  final LocalLoadSurveyResult local;

  RemoteLoadSurveyResultWithLocalFallback({
    required this.remote,
    required this.local,
  });

  @override
  Future<SurveyResultEntity> loadBySurvey({String? surveyId}) async {
    try {
      final result = await remote.loadBySurvey(surveyId: surveyId);
      await local.save(result);
      return result;
    } catch (error) {
      if (error == DomainError.accessDenied) rethrow;
      await local.validate(surveyId!);
      return await local.loadBySurvey(surveyId: surveyId);
    }
  }
}
