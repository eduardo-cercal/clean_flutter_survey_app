import 'dart:async';

import 'package:clean_flutter_login_app/ui/pages/splash/splash_page.dart';
import 'package:clean_flutter_login_app/ui/pages/splash/splash_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/helpers.dart';

class MockSplashPresenter extends Mock implements SplashPresenter {}

void main() {
  late SplashPresenter presenter;
  late StreamController<String?> navigateToController;

  setUp(() {
    presenter = MockSplashPresenter();
    navigateToController = StreamController<String?>();
  });

  void mockLoadCurrentAccount() {
    when(() => presenter.checkAccount()).thenAnswer((_) async {});
  }

  void mockStreams() {
    when(() => presenter.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
  }

  Future<void> loadPage(WidgetTester tester) async {
    mockLoadCurrentAccount();
    mockStreams();
    await tester.pumpWidget(
      makePage(
        path: '/',
        page: () => SplashPage(
          presenter: presenter,
        ),
      ),
    );
  }

  tearDown(() {
    navigateToController.close();
  });

  testWidgets('should present loading on page load', (tester) async {
    await loadPage(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should call loadCurrentAccount on page load', (tester) async {
    await loadPage(tester);

    verify(() => presenter.checkAccount()).called(1);
  });

  testWidgets('should load page', (tester) async {
    await loadPage(tester);

    navigateToController.add('/any_route');
    await tester.pumpAndSettle();

    expect(currentRoute, '/any_route');
    expect(find.text('fake page'), findsOneWidget);
  });

  testWidgets('should not change page', (tester) async {
    await loadPage(tester);

    navigateToController.add('');
    await tester.pump();
    expect(currentRoute, '/');

    navigateToController.add(null);
    await tester.pump();
    expect(currentRoute, '/');
  });
}
