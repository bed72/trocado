import 'package:either_dart/either.dart';

import 'package:trocado/modules/user/data/dtos/user_dto.dart';
import 'package:trocado/modules/user/data/repositories/user_repository.dart';

import 'package:trocado/modules/core/domain/constant/database_constant.dart';

import 'package:trocado/modules/core/data/datasources/database_datasource.dart';

final class LocalUserRepository implements UserRepository {
  final DatabaseDatasource _datasource;

  LocalUserRepository({required DatabaseDatasource datasource})
    : _datasource = datasource;

  @override
  Future<void> drop() async {
    _datasource.drop();
  }

  @override
  Future<AllUserRepository> all({required DatabaseConstant table}) async =>
      _datasource
          .all(table.name)
          .mapRight((data) => UserDto.fromJsons(data).first)
          .mapLeft(
            (_) => 'Opss, não encontramos seus dados, tente mais tarde!',
          );

  @override
  Future<void> insert({
    required UserDto data,
    required DatabaseConstant table,
  }) async {
    _datasource.upsert(table.name, data.toJson());
  }

  @override
  Future<void> update({
    required UserDto data,
    required DatabaseConstant table,
  }) async {
    _datasource.upsert(table.name, data.toJson());
  }
}
