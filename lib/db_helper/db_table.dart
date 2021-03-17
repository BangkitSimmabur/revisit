import 'table_main.dart' as table;

abstract class DatabaseTable {
  static const String columnId = 'ID';

  static const String TokenTable = '''
    CREATE TABLE ${table.TableUser.tokenTableName} (
      ID INTEGER PRIMARY KEY NOT NULL,
      Token TEXT
    )
  ''';

}
