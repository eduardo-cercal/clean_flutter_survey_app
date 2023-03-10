import 'package:clean_flutter_login_app/data/usecases/remote_authentication_usecase.dart';
import 'package:clean_flutter_login_app/infra/http/http_adapter.dart';
import 'package:clean_flutter_login_app/presentation/presenters/login/stream_login_presenter.dart';
import 'package:clean_flutter_login_app/ui/pages/login/login_page.dart';
import 'package:clean_flutter_login_app/validation/validators/email_validation.dart';
import 'package:clean_flutter_login_app/validation/validators/required_field_validation.dart';
import 'package:clean_flutter_login_app/validation/validators/validation_composite.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';

Widget makeLoginPage() {
  const url = 'http://fordevs.herokuapp.com/api/login';
  final client = Client();
  final httpAdapter = HttpAdapter(client);
  final validationComposite = ValidationComposite([
    RequiredFieldValidation('email'),
    EmailValidation('email'),
    RequiredFieldValidation('password'),
  ]);
  final remoteAuthentication =
      RemoteAuthentication(httpClient: httpAdapter, url: url);
  final streamLoginPresenter = StreamLoginPresenter(
      validation: validationComposite, authentication: remoteAuthentication);
  return LoginPage(presenter: streamLoginPresenter);
}
