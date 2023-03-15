import 'package:equatable/equatable.dart';

class AddAccountParamsEntity extends Equatable {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  const AddAccountParamsEntity({
    required this.email,
    required this.password,
    required this.name,
    required this.passwordConfirmation,
  });

  @override
  List<Object?> get props => [
        name,
        email,
        password,
        passwordConfirmation,
      ];
}
