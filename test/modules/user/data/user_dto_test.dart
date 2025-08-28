import 'package:flutter_test/flutter_test.dart';

import 'package:trocado/modules/user/data/dtos/user_dto.dart';
import 'package:trocado/modules/user/domain/models/user_model.dart';

void main() {
  group('UserDto tests', () {
    const mockId = '123';
    const mockName = 'Gabriel';
    const mockPassword = '123456';
    const mockEmail = 'gabriel@example.com';

    final userDto = UserDto(
      id: mockId,
      name: mockName,
      email: mockEmail,
      password: mockPassword,
    );

    test('copyWith should overwrite only the fields provided', () {
      final copy = userDto.copyWith(name: 'Novo Nome');

      expect(copy.id, mockId);
      expect(copy.email, mockEmail);
      expect(copy.name, 'Novo Nome');
      expect(copy.password, mockPassword);
    });

    test('toMap should return the correct Map', () {
      final map = userDto.toJson();

      expect(map, {
        'id': mockId,
        'name': mockName,
        'email': mockEmail,
        'password': mockPassword,
      });
    });

    test('fromMap should return the correct UserDto', () {
      final map = {
        'id': mockId,
        'name': mockName,
        'email': mockEmail,
        'password': mockPassword,
      };

      final dto = UserDto.fromJson(map);

      expect(dto.id, mockId);
      expect(dto.name, mockName);
      expect(dto.email, mockEmail);
      expect(dto.password, mockPassword);
    });

    test('fromJson must create UserDto correctly', () {
      final json = <String, String>{
        'id': mockId,
        'name': mockName,
        'email': mockEmail,
        'password': mockPassword,
      };

      final dto = UserDto.fromJson(json);

      expect(dto.id, mockId);
      expect(dto.name, mockName);
      expect(dto.email, mockEmail);
      expect(dto.password, mockPassword);
    });

    test('toModel must return an equivalent UserModel', () {
      final model = userDto.toModel();

      expect(model.name, mockName);
      expect(model.email, mockEmail);
      expect(model.password, mockPassword);
    });

    test('toDto must create UserDto from UserModel', () {
      final model = UserModel(
        id: mockId,
        name: mockName,
        email: mockEmail,
        password: mockPassword,
      );

      final dto = UserDto.toDto(model);

      expect(dto.id, model.id);
      expect(dto.name, model.name);
      expect(dto.email, model.email);
      expect(dto.password, model.password);
    });
  });

  test('lista vazia deve retornar lista vazia', () {
    final dtos = UserDto.fromJsons([]);
    expect(dtos, isEmpty);
  });

  test('must convert a list of Map<String, dynamic> to List<UserDto>', () {
    final jsons = [
      {
        'id': '1',
        'name': 'Gabriel',
        'password': '123',
        'email': 'gabriel@test.com',
      },
      {
        'id': '2',
        'name': 'Maria',
        'password': '456',
        'email': 'maria@test.com',
      },
    ];

    final dtos = UserDto.fromJsons(jsons);

    expect(dtos.length, 2);

    expect(dtos[0].id, '1');
    expect(dtos[0].name, 'Gabriel');
    expect(dtos[0].password, '123');
    expect(dtos[0].email, 'gabriel@test.com');

    expect(dtos[1].id, '2');
    expect(dtos[1].name, 'Maria');
    expect(dtos[1].password, '456');
    expect(dtos[1].email, 'maria@test.com');
  });
}
