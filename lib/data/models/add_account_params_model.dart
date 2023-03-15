import '../../domain/entities/add_account_params_entity.dart';
import '../helpers/constants.dart';

class AddAccountParamsModel extends AddAccountParamsEntity {
  const AddAccountParamsModel({
    required super.email,
    required super.password,
    required super.name,
    required super.passwordConfirmation,
  });

  factory AddAccountParamsModel.fromEntity(AddAccountParamsEntity entity) =>
      AddAccountParamsModel(
        email: entity.email,
        password: entity.password,
        name: entity.name,
        passwordConfirmation: entity.passwordConfirmation,
      );

  Map<String, dynamic> toJson() => {
        nameKey: name,
        emailKey: email,
        passwordKey: password,
        passwordConfirmationKey: passwordConfirmation,
      };
}
