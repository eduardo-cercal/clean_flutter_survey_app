import '../i18n/resources.dart';

enum UiError {
  requiredField,
  invalidField,
  unexpected,
  invalidCredentials,
}

extension UiErrorExtension on UiError {
  String get description {
    switch (this) {
      case UiError.requiredField:
        return R.strings.msgRequiredField;
      case UiError.invalidField:
        return 'Campo invalido';
      case UiError.invalidCredentials:
        return 'Credenciais invalidas';
      default:
        return 'Algo inesperado ocorreu. Tente novamente em breve';
    }
  }
}
