import 'package:clean_flutter_login_app/ui/helpers/errors/ui_error.dart';
import 'package:get/get.dart';

mixin UiErrorManager on GetxController {
  final _mainError = Rxn<UiError>();

  Stream<UiError?>? get mainErrorStream => _mainError.stream;

  set mainError(UiError? value) => _mainError.value = value;
}
