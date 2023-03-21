import '../../../domain/entities/survey_entity.dart';
import '../../../domain/helpers/errors/domain_error.dart';
import '../../../domain/usecases/load_surveys_use_case.dart';
import '../../http/http.error.dart';
import '../../http/http_client.dart';
import '../../models/remote_survey_model.dart';

class RemoteLoadSurveys implements LoadSurveys {
  final HttpClient httpClient;
  final String url;

  RemoteLoadSurveys({required this.httpClient, required this.url});

  @override
  Future<List<SurveyEntity>> load() async {
    try {
      final list = await httpClient.request(url: url, method: 'get');
      return list!
          .map<SurveyEntity>(
              (element) => RemoteSurveyModel.fromJson(element).toEntity())
          .toList();
    } on HttpError catch (error) {
      throw error == HttpError.forbiden
          ? DomainError.accessDenied
          : DomainError.unexpected;
    }
  }
}
