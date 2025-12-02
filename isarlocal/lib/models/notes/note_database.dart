import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:isarlocal/models/notes/note.dart';
import 'package:path_provider/path_provider.dart';

class NoteDatabase extends ChangeNotifier {
  static late Isar isar;

  List<Note> notes = [];

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([NoteSchema], directory: dir.path);
  }

  // create note
  Future<void> addNote(String text) async {
    Note note = Note()..text = text;
    await isar.writeTxn(() => isar.notes.put(note));
    await readNotes();
  }

  // read all notes
  Future<void> readNotes() async {
    List<Note> fetchedNotes = await isar.notes.where().findAll();
    notes.clear();
    notes.addAll(fetchedNotes);
    notifyListeners();
  }

  // update note
  Future<void> updateNote(int id, String text) async {
    Note? existingNote = await isar.notes.get(notes[id].id);
    if (existingNote != null) {
      existingNote.text = text;
      await isar.writeTxn(() => isar.notes.put(existingNote));
      await readNotes();
    }
  }

  // delete note
  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() => isar.notes.delete(notes[id].id));
    await readNotes();
  }
}
