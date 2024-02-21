import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {
  static Database? database; /*_ means private*/
  static List ? notesList=[] ;
  static Future<void> createDatabase() async {
    await openDatabase('notes.db', version: 3, onCreate: (db, version) async {
      try {
        await db.execute(
            'CREATE TABLE notesTB (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT , title TEXT NOT NULL, note  TEXT NOT NULL,createdAt TEXT )');
        print("Create Database and Table Sucessfully");
      } catch (e) {
        print("error while creating table ${e.toString()}");
      }
    }, //async end
        onOpen: (db) {
      //another attribute in openDatabase
      database = db;
      print("database opened");
      getData();
    },
    onUpgrade: OnUpgrade
    );
  }
static OnUpgrade(Database db, int oldVersion ,int newVersion) async{
await db.execute("ALTER TABLE notesTB ADD COLUMN createdAt TEXT") ;
}

  static insertData({
    required String title,
    required String note,
    required String createdAt,
  }) async {
    await database?.transaction((txn) async {
      //transaction sends data to table and must be done before rawInsert
      try {
        int row = await txn.rawInsert(
            'INSERT INTO notesTB (title , note, createdAt) VALUES("$title" ,"$note","$createdAt")');
        print('$row inserted sucessfully');
        getData();
      } catch (e) {
        print("error while inserting data ${e.toString()}");
      }
    });
  }
  static getData() async {
    notesList=await database?.rawQuery('SELECT * FROM notesTB');
    return notesList ;
  }
static deleteDataById(int id) async {
  try {
    int? value = await database?.rawDelete(
        'DELETE FROM notesTB WHERE id = ?', [id]);
    print('$value deleted sucessfully') ;
    await getData();
  } catch (e) {
    print('error while deleting row ${e.toString()}');
  }
}
static updateDataById(int id ,String title, String note) async {
  try {
    int? count = await database?.rawUpdate(
        'UPDATE notesTB SET title = ?, note = ? WHERE id = ?',
        [title, note, id]);
    print('updated: $count');
  } catch (e) {
    print('error while updating row ${e.toString()}');
  }
}
 static mydeleteDatabase() async {
    try {
      if (database != null) {
        // Close the existing database
        await database!.close();
      }

      String databasePath = await getDatabasesPath();
      String path = join(databasePath, 'notes.db');
      await deleteDatabase(path);

      // Recreate the database
      await openDatabase('notes.db', version: 3, onCreate: (db, version) async {
        try {
          await db.execute(
              'CREATE TABLE notesTB (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT , title TEXT NOT NULL, note  TEXT NOT NULL,createdAt TEXT)');
          print("Create Database and Table Successfully");
        } catch (e) {
          print("Error while creating table ${e.toString()}");
        }
      }, onOpen: (db) {
        database = db;
        print("Database opened");
        getData();
      }, onUpgrade: OnUpgrade);

      print("Database deleted and recreated successfully");
    } catch (e) {
      print("Error while deleting and recreating database: ${e.toString()}");
    }
  }

}

