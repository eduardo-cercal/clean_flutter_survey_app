import 'package:clean_flutter_login_app/domain/entities/account_entity.dart';
import 'package:clean_flutter_login_app/domain/usecases/load_current_account.dart';
import 'package:clean_flutter_login_app/presentation/presenters/splash/getx_splash_presenter.dart';
import 'package:clean_flutter_login_app/ui/pages/splash/splash_presenter.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoadCurrentAccount extends Mock implements LoadCurrentAccount {}

void main() {
  late LoadCurrentAccount loadCurrentAccount;
  late SplashPresenter systemUnderTest;

  When mockLoadCurrentAccountCall() => when(() => loadCurrentAccount.load());

  void mockLoadCurrentAccount(AccountEntity? account) {
    mockLoadCurrentAccountCall().thenAnswer((_) async => account);
  }

  void mockLoadCurrentAccountError() {
    mockLoadCurrentAccountCall().thenThrow(Exception());
  }

  setUp(() {
    loadCurrentAccount = MockLoadCurrentAccount();
    systemUnderTest = GetxSplashPresenter(loadCurrentAccount);
    mockLoadCurrentAccount(AccountEntity(faker.guid.guid()));
  });

  test('should call LoadCurrentAccout', () async {
    await systemUnderTest.checkAccount();

    verify(() => loadCurrentAccount.load()).called(1);
  });

  test('should go to survey page on success', () async {
    systemUnderTest.navigateToStream.listen(expectAsync1(
      (page) => expect(page, '/survey'),
    ));

    await systemUnderTest.checkAccount();
  });

  test('should go to login page on null result', () async {
    mockLoadCurrentAccount(null);

    systemUnderTest.navigateToStream.listen(expectAsync1(
      (page) => expect(page, '/login'),
    ));

    await systemUnderTest.checkAccount();
  });

  test('should go to login page on null token', () async {
    mockLoadCurrentAccount(const AccountEntity(null));

    systemUnderTest.navigateToStream.listen(expectAsync1(
      (page) => expect(page, '/login'),
    ));

    await systemUnderTest.checkAccount();
  });

  test('should go to login page on error', () async {
    mockLoadCurrentAccountError();

    systemUnderTest.navigateToStream.listen(expectAsync1(
      (page) => expect(page, '/login'),
    ));

    await systemUnderTest.checkAccount();
  });
}
