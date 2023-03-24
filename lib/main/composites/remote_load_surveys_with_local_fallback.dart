import '../../data/usecases/load_surveys/local_load_surveys.dart';
import '../../data/usecases/load_surveys/remote_load_surveys.dart';
import '../../domain/entities/survey_entity.dart';
import '../../domain/helpers/errors/domain_error.dart';
import '../../domain/usecases/load_surveys_use_case.dart';

class RemoteLoadSurveysWithLocalFallback implements LoadSurveys {
  final RemoteLoadSurveys remoteLoadSurveys;
  final LocalLoadSurveys localLoadSurveys;

  RemoteLoadSurveysWithLocalFallback({
    required this.remoteLoadSurveys,
    required this.localLoadSurveys,
  });
  @override
  Future<List<SurveyEntity>> load() async {
    try {
      final surveys = await remoteLoadSurveys.load();
      await localLoadSurveys.save(surveys);
      return surveys;
    } catch (error) {
      if (error == DomainError.accessDenied) rethrow;
      await localLoadSurveys.validate();
      return await localLoadSurveys.load();
    }
  }
}
