import 'package:clean_flutter_login_app/data/usecases/load_surveys/local_load_surveys.dart';
import 'package:clean_flutter_login_app/data/usecases/load_surveys/remote_load_surveys.dart';
import 'package:clean_flutter_login_app/domain/entities/survey_entity.dart';
import 'package:clean_flutter_login_app/domain/helpers/errors/domain_error.dart';
import 'package:clean_flutter_login_app/domain/usecases/load_surveys_use_case.dart';
import 'package:clean_flutter_login_app/main/composites/remote_load_surveys_with_local_fallback.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/fake_surveys_factory.dart';

class MockRemoteLoadSurveys extends Mock implements RemoteLoadSurveys {}

class MockLocalLoadSurveys extends Mock implements LocalLoadSurveys {}

void main() {
  late RemoteLoadSurveys remoteLoadSurveys;
  late LocalLoadSurveys localLoadSurveys;
  late LoadSurveys systemUnderTest;
  late List<SurveyEntity> surveys;

  When mockRemoteLoadSurveysCall() => when(() => remoteLoadSurveys.load());

  When mockLocalLoadSurveysSaveCall() =>
      when(() => localLoadSurveys.save(any()));

  When mockLocalLoadSurveysValidateCall() =>
      when(() => localLoadSurveys.validate());

  When mockLocalLoadSurveysLoadCall() => when(() => localLoadSurveys.load());

  void mockRemoteLoadSurveys() {
    surveys = FakeSurveysFactory.makeEntities();
    mockRemoteLoadSurveysCall().thenAnswer((_) async => surveys);
  }

  void mockLocalLoadSurveysSave() =>
      mockLocalLoadSurveysSaveCall().thenAnswer((_) async {});

  void mockLocalLoadSurveysLoad() {
    surveys = FakeSurveysFactory.makeEntities();
    mockLocalLoadSurveysLoadCall().thenAnswer((_) async => surveys);
  }

  void mockLocalLoadSurveysValidate() =>
      mockLocalLoadSurveysValidateCall().thenAnswer((_) async {});

  void mockRemoteLoadSurveysError(DomainError error) =>
      mockRemoteLoadSurveysCall().thenThrow(error);

  void mockLocalLoadSurveysLoadError() =>
      mockLocalLoadSurveysLoadCall().thenThrow(DomainError.unexpected);

  setUp(() {
    remoteLoadSurveys = MockRemoteLoadSurveys();
    localLoadSurveys = MockLocalLoadSurveys();
    systemUnderTest = RemoteLoadSurveysWithLocalFallback(
      remoteLoadSurveys: remoteLoadSurveys,
      localLoadSurveys: localLoadSurveys,
    );
    mockRemoteLoadSurveys();
    mockLocalLoadSurveysSave();
    mockLocalLoadSurveysValidate();
    mockLocalLoadSurveysLoad();
  });

  test('should remote load', () async {
    await systemUnderTest.load();

    verify(() => remoteLoadSurveys.load()).called(1);
  });

  test('should call loacal save with remote data', () async {
    await systemUnderTest.load();

    verify(() => localLoadSurveys.save(surveys)).called(1);
  });

  test('should return remote data', () async {
    final result = await systemUnderTest.load();

    expect(result, surveys);
  });

  test('should rethrow if remote load throws AccessDeniedError', () async {
    mockRemoteLoadSurveysError(DomainError.accessDenied);

    final future = systemUnderTest.load();

    expect(future, throwsA(DomainError.accessDenied));
  });

  test('should call local fetch on remote error', () async {
    mockRemoteLoadSurveysError(DomainError.unexpected);

    await systemUnderTest.load();

    verify(() => localLoadSurveys.validate()).called(1);
    verify(() => localLoadSurveys.load()).called(1);
  });

  test('should return local data', () async {
    mockRemoteLoadSurveysError(DomainError.unexpected);

    final result = await systemUnderTest.load();

    expect(result, surveys);
  });

  test('should throw UnexpectedError if remote and local load throws',
      () async {
    mockRemoteLoadSurveysError(DomainError.unexpected);
    mockLocalLoadSurveysLoadError();

    final future = systemUnderTest.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}
