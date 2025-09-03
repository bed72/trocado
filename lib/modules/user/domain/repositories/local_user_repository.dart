import 'package:trocado/modules/user/data/dtos/user_dto.dart';
import 'package:trocado/modules/user/data/mappers/user_mapper.dart';
import 'package:trocado/modules/user/data/repositories/user_repository.dart';

import 'package:trocado/modules/core/domain/constant/database_constant.dart';
import 'package:trocado/modules/core/data/datasources/database_datasource.dart';

final class LocalUserRepository implements UserRepository {
  final UserMapper _mapper;
  final DatabaseDatasource _datasource;

  LocalUserRepository({
    required UserMapper mapper,
    required DatabaseDatasource datasource,
  }) : _mapper = mapper,
       _datasource = datasource;

  @override
  Future<void> drop() async {
    _datasource.drop();
  }

  @override
  Future<AllUserRepository> all({required DatabaseConstant table}) async {
    final data = await _datasource.all(table.name);

    return data
        .mapLeft((_) => 'Opss, não encontramos seus dados, tente mais tarde!')
        .flatMap(
          (values) =>
              _mapper.fromJsons(values).mapRight((users) => users.first),
        );
  }

  @override
  Future<void> insert({
    required UserDto data,
    required DatabaseConstant table,
  }) async {
    _datasource.upsert(table.name, _mapper.toJson(data));
  }

  @override
  Future<void> update({
    required UserDto data,
    required DatabaseConstant table,
  }) async {
    _datasource.upsert(table.name, _mapper.toJson(data));
  }
}
