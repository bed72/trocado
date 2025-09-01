import 'package:tostore/tostore.dart';
import 'package:flutter/foundation.dart';

import 'package:trocado/modules/core/data/clients/database_client.dart';

import 'package:trocado/modules/core/domain/constant/database_constant.dart';

import 'package:trocado/modules/core/infrastructure/clients/database/user_schema.dart';

final class TostoreDatabaseClient implements DatabaseClient {
  @override
  ToStore get database => ToStore(
    config: _config,
    schemas: _schemas,
    dbName: DatabaseConstant.databaseName.name,
  );

  @override
  Future<void> ensureInitialized() async {
    database.initialize();
  }

  DataStoreConfig get _config => DataStoreConfig(
    enableLog: kDebugMode,
    logLevel: LogLevel.debug,
    dbName: DatabaseConstant.databaseName.name,
  );

  List<TableSchema> get _schemas => [userSchema];
}
