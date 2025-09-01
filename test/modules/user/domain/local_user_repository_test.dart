import 'package:mocktail/mocktail.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:trocado/modules/core/domain/constant/database_constant.dart';
import 'package:trocado/modules/core/data/datasources/database_datasource.dart';

import 'package:trocado/modules/user/data/dtos/user_dto.dart';
import 'package:trocado/modules/user/data/repositories/user_repository.dart';
import 'package:trocado/modules/user/domain/repositories/local_user_repository.dart';

final class MockDatabaseDatasource extends Mock implements DatabaseDatasource {}

void main() {
  late UserRepository repository;
  late DatabaseDatasource datasource;

  setUp(() {
    datasource = MockDatabaseDatasource();
    repository = LocalUserRepository(datasource: datasource);
  });

  group('LocalUserRepository', () {
    final table = DatabaseConstant.userTableName;
    final userDto = UserDto(
      id: '1',
      name: 'Gabriel',
      password: '123',
      email: 'gabriel@test.com',
    );

    group('all', () {
      test('should return first user on success', () async {
        when(
          () => datasource.all(table.name),
        ).thenAnswer((_) async => Right([userDto.toJson()]));

        final response = await repository.all(table: table);

        expect(response.isRight, isTrue);
        expect(response.right.id, equals('1'));
        expect(response.right.name, equals('Gabriel'));
        verify(() => datasource.all(table.name)).called(1);
      });

      test('should return error message on failure', () async {
        when(
          () => datasource.all(table.name),
        ).thenAnswer((_) async => Left(null));

        final result = await repository.all(table: table);

        expect(result.isLeft, isTrue);
        expect(
          result.left,
          'Opss, não encontramos seus dados, tente mais tarde!',
        );
        verify(() => datasource.all(table.name)).called(1);
      });
    });

    group('insert', () {
      test('should call upsert with correct parameters', () async {
        when(
          () => datasource.upsert(table.name, any()),
        ).thenAnswer((_) async {});

        await repository.insert(data: userDto, table: table);

        verify(() => datasource.upsert(table.name, userDto.toJson())).called(1);
      });
    });

    group('update', () {
      test('should call upsert with correct parameters', () async {
        when(
          () => datasource.upsert(table.name, any()),
        ).thenAnswer((_) async {});

        await repository.update(data: userDto, table: table);

        verify(() => datasource.upsert(table.name, userDto.toJson())).called(1);
      });
    });

    group('delete', () {
      test('should call delete database', () async {
        when(() => datasource.drop()).thenAnswer((_) async {});

        await repository.drop();

        verify(() => datasource.drop()).called(1);
      });
    });
  });
}
