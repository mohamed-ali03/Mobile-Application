import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isarlocal/models/notes/note.dart';
import 'package:isarlocal/models/notes/note_database.dart';
import 'package:isarlocal/utils/custom_button.dart';
import 'package:isarlocal/utils/custom_drawer.dart';
import 'package:isarlocal/utils/note_tile.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    readNodes();
  }

  void createNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: noteController,
          decoration: InputDecoration(
            hint: Text('Add new Note...'),
            hintStyle: TextStyle(color: Colors.grey[300]),
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          CustomButton(onPressed: () => Navigator.pop(context), text: 'Cancel'),
          CustomButton(
            onPressed: () {
              String text = noteController.text;
              noteController.clear();
              Navigator.pop(context);
              context.read<NoteDatabase>().addNote(text);
            },
            text: 'Add',
          ),
        ],
      ),
    );
  }

  void readNodes() {
    context.read<NoteDatabase>().readNotes();
  }

  void updateNote(int index, String text) {
    noteController.text = text;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: noteController,
          decoration: InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          CustomButton(onPressed: () => Navigator.pop(context), text: 'Cancel'),
          CustomButton(
            onPressed: () {
              String text = noteController.text;
              noteController.clear();
              Navigator.pop(context);
              context.read<NoteDatabase>().updateNote(index, text);
            },
            text: 'Update',
          ),
        ],
      ),
    );
  }

  void deleteNote(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('Do you want to delete this note?'),
        actions: [
          CustomButton(onPressed: () => Navigator.pop(context), text: 'Cancel'),
          CustomButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<NoteDatabase>().deleteNote(index);
            },
            text: 'Yes',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notesDatabase = context.watch<NoteDatabase>();

    List<Note> notes = notesDatabase.notes;
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),

      floatingActionButton: FloatingActionButton(
        onPressed: () => createNote(),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: CustomDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              'Notes',
              style: GoogleFonts.dmSerifText(
                fontSize: 40,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return NoteTile(
                  text: notes[index].text!,
                  deleteNodePrassed: () => deleteNote(index),
                  updateNodePrassed: () =>
                      updateNote(index, notes[index].text!),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
