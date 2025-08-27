import 'package:tostore/tostore.dart';

abstract interface class DatabaseClient {
  ToStore get database;

  Future<void> ensureInitialized();
}
