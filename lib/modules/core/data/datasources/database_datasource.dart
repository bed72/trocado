import 'package:either_dart/either.dart';

typedef AllDatabaseDatasource = Either<Null, List<Map<String, dynamic>>>;

abstract class DatabaseDatasource {
  Future<void> drop();
  Future<void> delete(String table, String? id);
  Future<AllDatabaseDatasource> all(String table);
  Future<void> upsert(String table, Map<String, dynamic> data);
}
