// ignore_for_file: non_constant_identifier_names

import 'package:supabase_flutter/supabase_flutter.dart';
import 'note.dart';

class NoteDatabase {
  // Database => notes
  final database = Supabase.instance.client.from('notes');

  // --- create --- //
  Future createNote(Note newNote) async {
    await database.insert(newNote.toMap());
  }

  // --- Read --- //
  final Stream = Supabase.instance.client.from('notes').stream(
    primaryKey: ['id'],
  ).map((data) => data.map((noteMap) => Note.fromMap(noteMap)).toList());

  // --- update --- //
  Future updateNote(Note oldNote, String newContent) async {
    await database.update({'content': newContent}).eq('id', oldNote.id!);
  }

  // --- delete --- //
  Future deleteNotes(Note note) async {
    await database.delete().eq('id', note.id!);
  }
}
