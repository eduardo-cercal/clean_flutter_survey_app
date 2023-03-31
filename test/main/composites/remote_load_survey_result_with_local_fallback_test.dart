import 'package:clean_flutter_login_app/data/usecases/load_surveys_result/local_load_survey_result.dart';
import 'package:clean_flutter_login_app/data/usecases/load_surveys_result/remote_load_survey_result.dart';
import 'package:clean_flutter_login_app/domain/entities/survey_result_entity.dart';
import 'package:clean_flutter_login_app/domain/helpers/errors/domain_error.dart';
import 'package:clean_flutter_login_app/domain/usecases/load_survey_result.dart';
import 'package:clean_flutter_login_app/main/composites/remote_load_survey_result_with_local_fallback.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/fake_survey_result_factory.dart';

class MockRemoteLoadSurveyResult extends Mock
    implements RemoteLoadSurveyResult {}

class MockLocalLoadSurveyResult extends Mock implements LocalLoadSurveyResult {}

void main() {
  late LocalLoadSurveyResult local;
  late RemoteLoadSurveyResult remote;
  late LoadSurveyResult systemUnderTest;
  late String surveyId;
  late SurveyResultEntity surveyResult;

  When mockRemoteLoadSurveyResultCall() =>
      when(() => remote.loadBySurvey(surveyId: any(named: 'surveyId')));

  void mockRemoteLoadSurveyResult(SurveyResultEntity data) {
    surveyResult = data;
    mockRemoteLoadSurveyResultCall().thenAnswer((_) async => surveyResult);
  }

  void mockRemoteLoadSurveyResultError(DomainError error) =>
      mockRemoteLoadSurveyResultCall().thenThrow(error);

  When mockLocalLoadSurveyResultSaveCall() => when(() => local.save(any()));

  void mockLocalLoadSurveyResultSave() {
    mockLocalLoadSurveyResultSaveCall().thenAnswer((_) async {});
  }

  When mockLocalLoadSurveyResultValidateCall() =>
      when(() => local.validate(any()));

  void mockLocalLoadSurveyResultValidate() {
    mockLocalLoadSurveyResultValidateCall().thenAnswer((_) async {});
  }

  When mockLocalLoadSurveyResultLoadBySurveyCall() =>
      when(() => local.loadBySurvey(surveyId: any(named: 'surveyId')));

  void mockLocalLoadSurveyResultLoadBySurvey(SurveyResultEntity data) {
    surveyResult = data;
    mockLocalLoadSurveyResultLoadBySurveyCall()
        .thenAnswer((_) async => surveyResult);
  }

  void mockLocalLoadSurveyResultLoadBySurveyError() =>
      mockLocalLoadSurveyResultLoadBySurveyCall()
          .thenThrow(DomainError.unexpected);

  setUp(() {
    remote = MockRemoteLoadSurveyResult();
    local = MockLocalLoadSurveyResult();
    systemUnderTest = RemoteLoadSurveyResultWithLocalFallback(
      remote: remote,
      local: local,
    );
    surveyResult = FakeSurveyResultFactory.makeEntity();
    surveyId = faker.guid.guid();
    registerFallbackValue(surveyResult);
    mockRemoteLoadSurveyResult(FakeSurveyResultFactory.makeEntity());
    mockLocalLoadSurveyResultSave();
    mockLocalLoadSurveyResultValidate();
    mockLocalLoadSurveyResultLoadBySurvey(FakeSurveyResultFactory.makeEntity());
  });

  test('should call remote load by survey', () async {
    await systemUnderTest.loadBySurvey(surveyId: surveyId);

    verify(() => remote.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('should call local save with remote data', () async {
    await systemUnderTest.loadBySurvey(surveyId: surveyId);

    verify(() => local.save(surveyResult)).called(1);
  });

  test('should return remote data', () async {
    final result = await systemUnderTest.loadBySurvey(surveyId: surveyId);

    expect(result, surveyResult);
  });

  test('should rethrow if remote loadBySurvey throws AccessDeniedError',
      () async {
    mockRemoteLoadSurveyResultError(DomainError.accessDenied);

    final future = systemUnderTest.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.accessDenied));
  });

  test('should call local loadBySurvey on remote error', () async {
    mockRemoteLoadSurveyResultError(DomainError.unexpected);

    await systemUnderTest.loadBySurvey(surveyId: surveyId);

    verify(() => local.validate(surveyId)).called(1);
    verify(() => local.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('should return local data', () async {
    mockRemoteLoadSurveyResultError(DomainError.unexpected);

    final result = await systemUnderTest.loadBySurvey(surveyId: surveyId);

    expect(result, surveyResult);
  });

  test('should throw if local loadBySurvey fail', () async {
    mockRemoteLoadSurveyResultError(DomainError.unexpected);
    mockLocalLoadSurveyResultLoadBySurveyError();

    final future = systemUnderTest.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.unexpected));
  });
}
