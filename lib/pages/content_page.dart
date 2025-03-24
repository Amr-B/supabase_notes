import 'package:flutter/material.dart';
import 'package:supabase_notes_app/pages/models/note_database.dart';

import 'models/note.dart';

class ContentPage extends StatefulWidget {
  const ContentPage({super.key});

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  // notes db
  final notesDatabase = NoteDatabase();

  // text controller
  final noteController = TextEditingController();

  // add new note method
  void addNewNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text('New Note'),
        content: TextField(
          controller: noteController,
        ),
        actions: [
          // --- cancel button --- //
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              noteController.clear();
            },
            child: Text('Cancel'),
          ),

          // --- save button --- //
          TextButton(
            onPressed: () {
              final newNote = Note(content: noteController.text);
              // --- save in database --- //
              notesDatabase.createNote(newNote);
              Navigator.pop(context);
              noteController.clear();
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  // update note method
  void updateNote(Note note) {
    // pre fill with existing note
    noteController.text = note.content;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text('Update Note'),
        content: TextField(
          controller: noteController,
        ),
        actions: [
          // --- cancel button --- //
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              noteController.clear();
            },
            child: Text('Cancel'),
          ),

          // --- save button --- //
          TextButton(
            onPressed: () {
              // --- save in database --- //
              notesDatabase.updateNote(note, noteController.text);
              Navigator.pop(context);
              noteController.clear();
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  // delete note method
  void deleteNote(Note note) {
    // pre fill with existing note
    noteController.text = note.content;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text('Delete Note ?'),
        actions: [
          // --- cancel --- //
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              noteController.clear();
            },
            child: Text('Canel'),
          ),
          // --- save button --- //
          TextButton(
            onPressed: () {
              // --- save in database --- //
              notesDatabase.deleteNotes(note);
              Navigator.pop(context);
              noteController.clear();
            },
            child: Text('Ok'),
          ),
        ],
      ),
    );
  }

  // Buid UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 19, 19, 18),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Notes'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        onPressed: addNewNote,
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: notesDatabase.Stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }

          final notes = snapshot.data!;
          if (notes.isEmpty) {
            return Center(
              child: Text(
                'Press the + button to create a new note',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ListTile(
                  title: Text(note.content),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => updateNote(note),
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () => deleteNote(note),
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
