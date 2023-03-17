import 'package:clean_flutter_login_app/main/factories/pages/login/login_validation_factory.dart';
import 'package:clean_flutter_login_app/main/factories/pages/sign_up/sign_up_validation_factory.dart';
import 'package:clean_flutter_login_app/main/factories/usecases/authentication_factory.dart';
import 'package:clean_flutter_login_app/presentation/presenters/login/stream_login_presenter.dart';
import 'package:clean_flutter_login_app/ui/pages/login/login_presenter.dart';

import '../../../../presentation/presenters/login/getx_login_presenter.dart';
import '../../../../presentation/presenters/signup/getx_signup_presenter.dart';
import '../../../../ui/pages/signup/signup_presenter.dart';
import '../../usecases/add_account_factory.dart';
import '../../usecases/save_current_account_factory.dart';

SignUpPresenter makeGetxSignUpPresenter() => GetxSignUpPresenter(
      validation: makeSignUpValidation(),
      saveCurrentAccount: makeLocalSaveCurrentAccount(),
      addAccount: makeRemoteAddAccount(),
    );
