import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mynotesapp/data/note_database.dart';
import 'package:mynotesapp/utils/custom_button.dart';
import 'package:mynotesapp/utils/note_tile.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final _myBox = Hive.box('mybox');
  NoteDatabase db = NoteDatabase();

  final _controller = TextEditingController();

  @override
  void initState() {
    if (_myBox.get('NOTELIST') == null) {
      db.createIntialData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  void saveNote() {
    setState(() {
      Navigator.pop(context);
      db.notes.add(_controller.text);
      _controller.clear();
    });
    db.updateData();
  }

  void deleteNote(int index) {
    setState(() {
      Navigator.pop(context);
      db.notes.removeAt(index);
    });
    db.updateData();
  }

  void onLongPress(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('Do you need to Delete this note!'),
        actions: [
          CustomButton(onPressed: () => Navigator.pop(context), text: 'Cancel'),
          CustomButton(onPressed: () => deleteNote(index), text: 'Delete'),
        ],
      ),
    );
  }

  void addNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: _controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hint: Text('Add new note...'),
          ),
        ),

        actions: [
          CustomButton(onPressed: () => Navigator.pop(context), text: 'Cancel'),
          CustomButton(onPressed: () => saveNote(), text: 'Add'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          'Notes',
          style: TextStyle(
            fontSize: 40,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/settingsPage'),
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addNote(),
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      body: Center(
        child: Container(
          color: Theme.of(context).colorScheme.surface,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              mainAxisExtent: 200,
            ),
            itemCount: db.notes.length,
            itemBuilder: (context, index) {
              String temp = db.notes[index];
              return NoteTile(
                text: temp,
                onLongPress: () => onLongPress(index),
              );
            },
          ),
        ),
      ),
    );
  }
}
