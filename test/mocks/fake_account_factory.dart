import 'package:clean_flutter_login_app/data/helpers/constants.dart';
import 'package:clean_flutter_login_app/domain/entities/account_entity.dart';
import 'package:faker/faker.dart';

class FakeAccountFactory {
  static Map<String, dynamic> makeApiJson() => {
        tokenKey: faker.guid.guid(),
        nameKey: faker.person.name(),
      };

  static AccountEntity makeEntity() => AccountEntity(faker.guid.guid());
}
