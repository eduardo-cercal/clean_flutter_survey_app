import 'package:clean_flutter_login_app/data/models/local_survey_result_model.dart';
import 'package:clean_flutter_login_app/domain/entities/survey_result_entity.dart';
import 'package:clean_flutter_login_app/domain/usecases/load_survey_result.dart';

import '../../../domain/entities/survey_entity.dart';
import '../../../domain/helpers/errors/domain_error.dart';
import '../../cache/cache_storage.dart';

class LocalLoadSurveyResult implements LoadSurveyResult {
  final CacheStorage cacheStorage;

  LocalLoadSurveyResult(this.cacheStorage);

  @override
  Future<SurveyResultEntity> loadBySurvey({String? surveyId}) async {
    try {
      final data = await cacheStorage.fetch('survey_result/$surveyId');
      if (data == null) throw Exception();
      if (data.isEmpty) throw Exception();
      return LocalSurveyResultModel.fromJson(data).toEntity();
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  Future<void> validate(String surveyId) async {
    try {
      final data = await cacheStorage.fetch('survey_result/$surveyId');
      LocalSurveyResultModel.fromJson(data).toEntity();
    } catch (error) {
      await cacheStorage.delete('survey_result/$surveyId');
    }
  }

  Future<void> save({
    required String key,
    required SurveyResultEntity value,
  }) async {
    try {
      await cacheStorage.save(
          key: 'survey_result/$key',
          value: LocalSurveyResultModel.fromEntity(value).toJson());
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
