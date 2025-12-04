import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note_onlinedatabase/services/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirestoreService firestoreService = FirestoreService();
  final noteController = TextEditingController();

  void openNoteBox(String? docID) {
    noteController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(controller: noteController),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);

              if (docID == null) {
                final note = noteController.text;
                firestoreService.addNote(note);
              } else {
                final newNote = noteController.text;
                firestoreService.updateNode(docID, newNote);
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notes'), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openNoteBox(null),
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: firestoreService.getUserNotes(),
        builder: (context, snapshot) {
          // there are data
          if (snapshot.hasData) {
            List notesList = snapshot.data!.docs;
            return ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (context, index) {
                // get each individual doc
                DocumentSnapshot document = notesList[index];
                String docID = document.id;

                // get note from each doc
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String noteText = data['note'];

                // display as a list tile
                return ListTile(
                  title: Text(noteText),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => firestoreService.deleteNote(docID),
                        icon: Icon(Icons.delete),
                      ),
                      IconButton(
                        onPressed: () => openNoteBox(docID),
                        icon: Icon(Icons.settings),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          //  no data
          else {
            return Center(child: const Text('No data'));
          }
        },
      ),
    );
  }
}
