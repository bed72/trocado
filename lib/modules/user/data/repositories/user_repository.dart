import 'package:either_dart/either.dart';

import 'package:trocado/modules/user/data/dtos/user_dto.dart';
import 'package:trocado/modules/core/domain/constant/database_constant.dart';

typedef AllUserRepository = Either<String, UserDto>;

abstract interface class UserRepository {
  Future<void> drop();
  Future<AllUserRepository> all({required DatabaseConstant table});
  Future<void> update({required UserDto data, required DatabaseConstant table});
  Future<void> insert({required UserDto data, required DatabaseConstant table});
}
