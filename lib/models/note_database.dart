import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'package:notely2/models/note.dart';
import 'package:path_provider/path_provider.dart';

class NoteDatabase extends ChangeNotifier {
  static late Isar isar;
  //initiate db
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [NoteSchema],
      directory: dir.path,
    );
  }

  //list of notes
  final List<Note> currentNotes = [];

  //create a note in db
  Future<void> addNote(String textFromUser) async {
    //create a new note object
    final newNote = Note()..text = textFromUser;
    //save note to db
    await isar.writeTxn(
      () => isar.notes.put(newNote),
    );
    //re-read from db
    fetchNotes();
  }

  //read a note from db
  Future<void> fetchNotes() async {
    List<Note> fetchedNotes = await isar.notes.where().findAll();
    currentNotes.clear();
    currentNotes.addAll(fetchedNotes);
    notifyListeners();
  }

  //update a note in db
  Future<void> updateNote(int id, String newText) async {
    final existingNote = await isar.notes.get(id);
    if (existingNote != null) {
      existingNote.text = newText;
      await isar.writeTxn(
        () => isar.notes.put(existingNote),
      );
      await fetchNotes();
    }
  }

  //delete a note from db
  Future<void> deleteNote(int id) async {
    await isar.writeTxn(
      () => isar.notes.delete(id),
    );
    await fetchNotes();
  }
}
