import 'package:trocado/modules/core/domain/either.dart';

import 'package:trocado/modules/core/data/clients/database_client.dart';
import 'package:trocado/modules/core/data/datasources/database_datasource.dart';

final class LocalDatabaseDatasource implements DatabaseDatasource {
  final DatabaseClient _client;

  LocalDatabaseDatasource({required DatabaseClient client}) : _client = client;

  @override
  Future<void> drop() async {
    await _client.database.deleteDatabase();
  }

  @override
  Future<AllDatabaseDatasource> all(String table) async {
    final response = await _client.database.query(table);

    return response.isSuccess ? Right(response.data) : Left(null);
  }

  @override
  Future<void> delete(String table, String? id) async {
    if (id == null) return;

    await _client.database.delete(table).where('id', '=', id);
  }

  @override
  Future<void> upsert(String table, Map<String, dynamic> data) async {
    await _client.database.upsert(table, data).where('id', '=', data['id']);
  }
}
