import 'package:database_sqlflite/model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{

  DatabaseHelper(){
    openDb();
  }
  late Database _database;

  Future<void> openDb() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), "user.db"),
      version: 1,
      onCreate: (Database db, int version){
        db.execute("CREATE TABLE usertable(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, phonenumber TEXT )");
      }
    );
  }

  Future<int>insertuser(User user) async {
    await _database;
    return await _database.insert("usertable", user.toMap());
  }

  Future<int>updateuser(User user) async {
    await _database;
    return await _database.update("usertable", user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  Future<int>deleteuser(User user) async {
    return await _database.delete("usertable",  where: 'id = ?', whereArgs: [user.id]);
  }

  Future<List<User>?> getall() async{
    await _database;
    List<Map<String,dynamic>> map = await _database.query("usertable");
    return List.generate(map.length, (index){
      return User(id: map[index]["id"],name: map[index]["name"], phonenumber: map[index]["phonenumber"]);
    });
  }

}

