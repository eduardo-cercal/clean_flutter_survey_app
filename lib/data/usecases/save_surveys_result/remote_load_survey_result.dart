import '../../../domain/entities/survey_result_entity.dart';
import '../../../domain/helpers/errors/domain_error.dart';
import '../../../domain/usecases/save_survey_result.dart';
import '../../http/http.error.dart';
import '../../http/http_client.dart';
import '../../models/remote_survey_result_model.dart';

class RemoteSaveSurveyResult implements SaveSurveyResult {
  final HttpClient httpClient;
  final String url;

  RemoteSaveSurveyResult({required this.httpClient, required this.url});

  @override
  Future<SurveyResultEntity> save({required String answer}) async {
    try {
      final response = await httpClient
          .request(url: url, method: 'put', body: {'answer': answer});
      return RemoteSurveyResultModel.fromJson(response).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.forbiden
          ? DomainError.accessDenied
          : DomainError.unexpected;
    }
  }
}
