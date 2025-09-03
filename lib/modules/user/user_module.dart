import 'package:modugo/modugo.dart';

import 'package:trocado/modules/core/data/datasources/database_datasource.dart';

import 'package:trocado/modules/user/data/mappers/user_mapper.dart';
import 'package:trocado/modules/user/data/repositories/user_repository.dart';

import 'package:trocado/modules/user/domain/repositories/local_user_repository.dart';

final class UserModule extends Module {
  @override
  void binds() {
    i
      ..registerFactory<UserMapper>(UserMapper.new)
      ..registerCachedFactory<UserRepository>(
        () => LocalUserRepository(
          mapper: i.get<UserMapper>(),
          datasource: i.get<DatabaseDatasource>(),
        ),
      );
  }
}
