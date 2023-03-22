import '../../../domain/entities/survey_entity.dart';
import '../../../domain/helpers/errors/domain_error.dart';
import '../../../domain/usecases/load_surveys_use_case.dart';
import '../../cache/cache_storage.dart';
import '../../models/local_survey_model.dart';

class LocalLoadSurveys implements LoadSurveys {
  final CacheStorage cacheStorage;

  LocalLoadSurveys(this.cacheStorage);

  @override
  Future<List<SurveyEntity>> load() async {
    try {
      final data = await cacheStorage.fetch('surveys');
      if (data == null) throw Exception();
      if (data.isEmpty) throw Exception();
      return _toSurveyEntitytList(data);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  Future<void> validate() async {
    try {
      final data = await cacheStorage.fetch('surveys');
      _toSurveyEntitytList(data);
    } catch (error) {
      await cacheStorage.delete('surveys');
    }
  }

  Future<void> save(List<SurveyEntity> surveys) async {
    try {
      await cacheStorage.save(key: 'surveys', value: _toJsonList(surveys));
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  List<SurveyEntity> _toSurveyEntitytList(
          List<Map<String, dynamic>> list) =>
      list
          .map<SurveyEntity>(
              (json) => LocalSurveyModel.fromJson(json).toEntity())
          .toList();

  List<Map<String, String>> _toJsonList(List<SurveyEntity> surveys) => surveys
      .map<Map<String, String>>(
          (entity) => LocalSurveyModel.fromEntity(entity).toJson())
      .toList();
}
