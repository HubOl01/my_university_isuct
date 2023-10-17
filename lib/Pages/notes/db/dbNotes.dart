import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/note.dart';

class DBNotes {
  static final DBNotes instance = DBNotes._init();
  static Database? _database;

  DBNotes._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    print("SUCCESSED initDB");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT';
    final integerType = 'INTEGER';
    await db.execute('''
    CREATE TABLE $tableNotes (
    ${NoteFields.id} $idType,
    ${NoteFields.title} $textType,
    ${NoteFields.content} $textType,
    ${NoteFields.number} $integerType,
    ${NoteFields.date_created} $textType,
    ${NoteFields.note_color} $integerType
    )
    ''');
  }

  Future<Note> create(Note note) async {
    final db = await instance.database;
    // final json = note.toJson();
// final columns = '${NoteFields.title}, ${NoteFields.content}, ${NoteFields.date_created}, ${NoteFields.note_color}';
// final values = '${json[NoteFields.title]}, ${json[NoteFields.content]}, ${json[NoteFields.date_created]}, ${json[NoteFields.note_color]}';
// final id = await db.rawInsert('insert into $tableNotes ($columns) values ($values)');
    final id = await db.insert(tableNotes, note.toJson());
    print("!!! Successed create id !!!");
    return note.copy(id: id);
  }

  Future<Note> readNote(int id) async {
    final db = await instance.database;
    final maps = await db.query(tableNotes,
        columns: NoteFields.values,
        where: '${NoteFields.id} = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;
    final orderBy = '${NoteFields.date_created} DESC';
    // final result = await db.rawQuery('select * from $tableNotes order by $orderBy');
    final result = await db.query(tableNotes, orderBy: orderBy);
    print("Reading all notes");
    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<int> update(Note note) async {
    final db = await instance.database;
    return db.update(tableNotes, note.toJson(),
        where: '${NoteFields.id} = ?', whereArgs: [note.id]);
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return db
        .delete(tableNotes, where: '${NoteFields.id} = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
