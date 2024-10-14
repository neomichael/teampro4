import 'package:mongo_dart/mongo_dart.dart';

class MongoDBHelper {
//   static const String MONGO_CONN_URL = "mongodb://localhost:27017";
  static const String MONGO_CONN_URL = "mongodb://10.0.2.2:27017";
  static const String DATABASE_NAME = "CustomerInfo";
  static const String COLLECTION_NAME = "customer";

  static Db? _db;

  static Future<void> connect() async {
    if (_db == null || !_db!.isConnected) {
      _db = await Db.create(MONGO_CONN_URL);
      await _db!.open();
    }
  }

  static Future<ObjectId> insert(String name, String tele) async {
    await connect();
    final collection = _db!.collection(COLLECTION_NAME);
    final result = await collection.insertOne({
      'name': name,
      'tele': tele,
    });
    return result.id as ObjectId;
  }
}