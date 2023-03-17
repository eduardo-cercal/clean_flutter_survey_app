import 'package:clean_flutter_login_app/main/factories/pages/sign_up/sign_up_validation_factory.dart';

import '../../../../presentation/presenters/signup/getx_signup_presenter.dart';
import '../../../../ui/pages/signup/signup_presenter.dart';
import '../../usecases/add_account_factory.dart';
import '../../usecases/save_current_account_factory.dart';

SignUpPresenter makeGetxSignUpPresenter() => GetxSignUpPresenter(
      validation: makeSignUpValidation(),
      saveCurrentAccount: makeLocalSaveCurrentAccount(),
      addAccount: makeRemoteAddAccount(),
    );
