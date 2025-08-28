import 'package:modugo/modugo.dart';

import 'package:trocado/modules/core/data/datasources/database_datasource.dart';

import 'package:trocado/modules/user/data/repositories/user_repository.dart';
import 'package:trocado/modules/user/domain/repositories/local_user_repository.dart';

final class UserModule extends Module {
  @override
  void binds() {
    i.registerCachedFactory<UserRepository>(
      () => LocalUserRepository(datasource: i.get<DatabaseDatasource>()),
    );
  }
}
