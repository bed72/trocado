import 'package:modugo/modugo.dart';

import 'package:trocado/modules/core/data/clients/database_client.dart';
import 'package:trocado/modules/core/data/datasources/database_datasource.dart';

import 'package:trocado/modules/core/infrastructure/clients/database/tostore_database_client.dart';
import 'package:trocado/modules/core/infrastructure/datasources/local/local_database_datasource.dart';

final class CoreModule extends Module {
  @override
  void binds() {
    i
      ..registerLazySingleton<DatabaseClient>(TostoreDatabaseClient.new)
      ..registerLazySingleton<DatabaseDatasource>(
        () => LocalDatabaseDatasource(client: i.get<DatabaseClient>()),
      );
  }
}
