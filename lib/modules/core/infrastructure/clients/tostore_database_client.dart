import 'package:tostore/tostore.dart';

import 'package:trocado/modules/core/data/clients/database_client.dart';

import 'package:trocado/modules/core/domain/constant/database_constant.dart';

final class TostoreDatabaseClient implements DatabaseClient {
  @override
  ToStore get database => ToStore(dbName: DatabaseConstant.databaseName.value);

  @override
  Future<void> ensureInitialized() async {
    database.initialize(dbName: DatabaseConstant.databaseName.value);
  }
}
