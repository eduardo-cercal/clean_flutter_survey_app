enum DomainError { unexpected, invalidCredentials }

extension DomainErrorExtension on DomainError {
  String get description {
    switch (this) {
      case DomainError.unexpected:
        return 'Algo inesperado aconteceu. Tente novamente em breve';
      case DomainError.invalidCredentials:
        return 'Credenciais invalidas';
      default:
        return '';
    }
  }
}
