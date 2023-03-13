import 'package:clean_flutter_login_app/main/factories/pages/login/login_validation_factory.dart';
import 'package:clean_flutter_login_app/main/factories/usecases/authentication_factory.dart';
import 'package:clean_flutter_login_app/presentation/presenters/login/stream_login_presenter.dart';
import 'package:clean_flutter_login_app/ui/pages/login/login_presenter.dart';

LoginPresenter makeLoginPresenter() => StreamLoginPresenter(
      validation: makeLoginValidation(),
      authentication: makeRemoteAuthentication(),
    );
