import '../../../domain/entities/survey_result_entity.dart';
import '../../../domain/helpers/errors/domain_error.dart';
import '../../../domain/usecases/load_survey_result.dart';
import '../../http/http.error.dart';
import '../../http/http_client.dart';
import '../../models/remote_survey_result_model.dart';

class RemoteLoadSurveyResult implements LoadSurveyResult {
  final HttpClient httpClient;
  final String url;

  RemoteLoadSurveyResult({required this.httpClient, required this.url});

  @override
  Future<SurveyResultEntity> loadBySurvey({String? surveyId}) async {
    try {
      final response = await httpClient.request(url: url, method: 'get');
      return RemoteSurveyResultModel.fromJson(response).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.forbiden
          ? DomainError.accessDenied
          : DomainError.unexpected;
    }
  }
}
