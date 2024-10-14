import 'package:sqljocky5/sqljocky.dart';

class AzureSqlHelper {
  // Singleton instance
  static final AzureSqlHelper _instance = AzureSqlHelper._privateConstructor();
  factory AzureSqlHelper() => _instance;
  AzureSqlHelper._privateConstructor();

  // Database connection settings
  final String _host = 'gai24310teampro4.database.windows.net';
  final int _port = 1433;
  final String _user = 'sqladmin';
  final String _password = 'Mic83kd@';
  final String _dbName = 'CustomerInfo';

  MySqlConnection? _connection;

  // Initialize the database connection
  Future<void> init() async {
    _connection = await MySqlConnection.connect(ConnectionSettings(
      host: _host,
      port: _port,
      user: _user,
      password: _password,
      db: _dbName,
    ));
  }

  // Create the customer table
  Future<void> createTable() async {
    var result = await _connection!.execute('''
      CREATE TABLE IF NOT EXISTS customer (
        id INT PRIMARY KEY AUTO_INCREMENT,
        name VARCHAR(255) NOT NULL,
        tele VARCHAR(255) NOT NULL
      )
    ''');
    print('Table created: $result');
  }

  // Insert a customer record
  Future<void> insertCustomer(String name, String tele) async {
    var result = await _connection!.prepared(
      'INSERT INTO customer (name, tele) VALUES (?, ?)',
      [name, tele],
    );
    print('Inserted row id: ${result.insertId}');
  }

  // Fetch all customer records
  Future<List<Map<String, dynamic>>> fetchAllCustomers() async {
    var results = await _connection!.execute('SELECT * FROM customer');
    return results.map((row) {
      return {
        'id': row[0],
        'name': row[1],
        'tele': row[2],
      };
    }).toList();
  }

  // Close the database connection
  Future<void> close() async {
    await _connection!.close();
  }
}