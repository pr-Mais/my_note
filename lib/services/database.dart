import 'package:streamqflite/streamqflite.dart';
import '../models/notesModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotesDatabaseService {
  String path;
  Database _database;
  StreamDatabase _streamDatabase;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await init();
    return _database;
  }

  init() async {
    String path = await getDatabasesPath();
    path = join(path, 'notes.db');
    print("Entered path $path");

    _database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Notes (id INTEGER PRIMARY KEY, title TEXT, content TEXT, date TEXT, isImportant INTEGER);');
      print('New table created at $path');
    });

    _streamDatabase = StreamDatabase(_database);
  }

  Stream<List<Note>> getAll() async* {
    await init();

    yield* _streamDatabase
        .createQuery('Notes',
            columns: ['id', 'title', 'content', 'date', 'isImportant'],
            orderBy: 'date DESC')
        .mapToList((map) => Note.fromMap(map));
  }

  updateNoteInDB(Note updatedNote) async {
    await init();
    await _streamDatabase.update('Notes', updatedNote.toMap(),
        where: 'id = ?', whereArgs: [updatedNote.id]);
    print('Note updated: ${updatedNote.title} ${updatedNote.content}');
  }

  deleteNoteInDB(Note noteToDelete) async {
    await init();
    await _streamDatabase
        .delete('Notes', where: 'id = ?', whereArgs: [noteToDelete.id]);
    print('Note deleted');
  }

  Future<Note> addNoteInDB(Note newNote) async {
    await init();
    if (newNote.title.trim().isEmpty) newNote.title = 'Untitled Note';
    newNote.id = await _streamDatabase.insert('Notes', newNote.toMap());
    print('Note added: ${newNote.title} ${newNote.content}');
    return newNote;
  }
}
