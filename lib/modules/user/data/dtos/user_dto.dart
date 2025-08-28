import 'package:trocado/modules/user/domain/models/user_model.dart';

final class UserDto {
  final String? id;
  final String name;
  final String email;
  final String password;

  UserDto({
    this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  UserDto copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
  }) => UserDto(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    password: password ?? this.password,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'email': email,
    'password': password,
  };

  UserModel toModel() =>
      UserModel(name: name, email: email, password: password);

  factory UserDto.toDto(UserModel model) => UserDto(
    id: model.id,
    name: model.name,
    email: model.email,
    password: model.password,
  );

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
    name: json['name'] as String,
    email: json['email'] as String,
    password: json['password'] as String,
    id: json['id'] != null ? json['id'] as String : null,
  );

  static List<UserDto> fromJsons(List<Map<String, dynamic>> jsons) =>
      jsons.map((json) => UserDto.fromJson(json)).toList();
}
