import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String notpadTable ="notpadTable";
final String idColumn = "idColumn";
final String titleColumn = "titleColumn";
final String contentColumn = "contentColumn";
final String dateColumn ="dateColumn";
final String imgColumn ="imgColumn";
final String img1Column="img1Column";
final String img2Column="img2Column";
final String colorColumn="colorColumn";

class NotpadHelper{

  static final NotpadHelper _instance = NotpadHelper.internal();

  factory NotpadHelper() => _instance;

  NotpadHelper.internal();

  Database _db;

  Future<Database> get db async{
    if(_db !=null){
      return _db;
    }else{
      _db =await initDb();
      return _db;
    }
  }

  Future<Database>initDb()async{
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "notpad.db");

    return await openDatabase(path, version: 1, onCreate: (Database db, int  newerVersion)async{
      await db.execute(
          "CREATE TABLE $notpadTable ($idColumn INTEGER PRIMARY KEY,"
              "$titleColumn TEXT,"
              "$contentColumn TEXT,"
              "$dateColumn TEXT,"
              "$imgColumn TEXT,"
              "$img1Column TEXT,"
              "$img2Column TEXT,"
              "$colorColumn)"

      );
    });

  }

  Future<Notpad> saveContact(Notpad notpad) async{
    Database dbNotpad = await db;
    notpad.id =await dbNotpad.insert(notpadTable, notpad.toMap());
    return notpad;

  }

  Future<Notpad> getContact(int id) async{
    Database dbNotpad = await db;
    List<Map> maps  = await dbNotpad.query(notpadTable,
        columns: [idColumn, titleColumn, contentColumn, dateColumn, imgColumn, img1Column, img2Column,colorColumn],
        where: "$idColumn =?",
        whereArgs: [id]);
    if(maps.length>0){
      return Notpad.fromMap(maps.first);
    }else{
      return null;
    }

  }

  Future<int> deleteContact(int id)async{
    Database dbNotpad = await db;
    return await dbNotpad.delete(notpadTable, where: "$idColumn= ?", whereArgs: [id]);
  }

  Future<int> updateContact(Notpad notpad) async{
    Database dbNotpad = await db;
    return await dbNotpad.update(notpadTable, notpad.toMap(),
        where: "$idColumn= ?",
        whereArgs: [notpad.id]);

  }
  Future<List> getAllContacts()async{
    Database dbNotpad = await db;
    List listMap = await dbNotpad.rawQuery("SELECT * FROM $notpadTable");
    List<Notpad> listContact = List();
    for(Map m in listMap){
      listContact.add(Notpad.fromMap(m));
    }
    return listContact;
  }

  Future<int> getNumber()async{
    Database dbNotpad = await db;
    return Sqflite.firstIntValue(await dbNotpad.rawQuery("SELECT COUNT(*) FROM $notpadTable"));
  }

  Future close()async{
    Database dbNotpad = await db;
    dbNotpad.close();
  }

}

class Notpad {
  int id;
  String title;
  String content;
  String data;
  String img;
  String img1;
  String img2;
  int color;

  Notpad();
  //RECEBE MAP E PASSA PARA CONTACT
  Notpad.fromMap(Map map){
    id = map[idColumn];
    title = map[titleColumn];
    content = map[contentColumn];
    data = map[dateColumn];
    img = map[imgColumn];
    img1 = map[img1Column];
    img2 = map[img2Column];
    color = map[colorColumn];
  }

  //TRANSFOMA CONTACT EM MAP
  Map toMap(){
    Map<String, dynamic> map={
      titleColumn:title,
      contentColumn:content,
      dateColumn:data,
      imgColumn:img,
      img1Column:img1,
      img2Column:img2,
      colorColumn:color,
    };
    if(id !=null){
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Grades(id: $id, title: $title, content: $content, data: $data, img: $img, img1: $img1, img2: $img2, color: $color )";
  }

}