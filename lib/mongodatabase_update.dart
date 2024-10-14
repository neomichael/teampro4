import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabaseUpdate {
  static const String MONGO_URL = "mongodb://localhost:27017/CustomerInfo";
  static const String COLLECTION_NAME = "customer";

  static Future<void> connect() async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    print("Connected to database");
    return db;
  }

  static Future<void> insert(String name, String tele) async {
    var db = await connect();
    var collection = db.collection(COLLECTION_NAME);
    
    await collection.insert({
      'name': name,
      'tele': tele,
    });
    
    print("Data inserted successfully");
    await db.close();
  }

  static Future<List<Map<String, dynamic>>> fetch() async {
    var db = await connect();
    var collection = db.collection(COLLECTION_NAME);
    
    var results = await collection.find().toList();
    
    await db.close();
    return results;
  }
}