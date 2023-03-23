import 'package:clean_flutter_login_app/data/usecases/load_surveys/remote_load_surveys.dart';
import 'package:clean_flutter_login_app/domain/entities/survey_entity.dart';
import 'package:clean_flutter_login_app/domain/usecases/load_surveys_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class RemoteLoadSurveysWithLocalFallback implements LoadSurveys {
  final RemoteLoadSurveys remoteLoadSurveys;

  RemoteLoadSurveysWithLocalFallback(this.remoteLoadSurveys);
  @override
  Future<List<SurveyEntity>> load() async {
    return await remoteLoadSurveys.load();
  }
}

class MockRemoteLoadSurveys extends Mock implements RemoteLoadSurveys {}

void main() {
  late RemoteLoadSurveys remoteLoadSurveys;
  late LoadSurveys systemUnderTest;

  When mockRemoteLoadSurveysCall() => when(() => remoteLoadSurveys.load());

  void mockRemoteLoadSurveys() =>
      mockRemoteLoadSurveysCall().thenAnswer((_) async => <SurveyEntity>[]);

  setUp(() {
    remoteLoadSurveys = MockRemoteLoadSurveys();
    systemUnderTest = RemoteLoadSurveysWithLocalFallback(remoteLoadSurveys);
    mockRemoteLoadSurveys();
  });

  test('should remote load', () async {
    await systemUnderTest.load();

    verify(() => remoteLoadSurveys.load()).called(1);
  });
}
