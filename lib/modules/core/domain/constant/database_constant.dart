enum DatabaseConstant {
  databaseName(value: 'tocado'),

  userTableName(value: 'users');

  final String value;

  const DatabaseConstant({required this.value});
}
