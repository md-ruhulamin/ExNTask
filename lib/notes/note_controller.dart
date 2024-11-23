import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app/database_helper.dart';
import 'package:note_app/notes/notes.dart';

class NoteController extends GetxController {
  var noteList = <Note>[].obs;
  var backgroundColor = Colors.white.obs;
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  @override
  void onInit() {
    super.onInit();
    loadnotes();
  }

  Future<void> loadnotes() async {
    noteList.value = await dbHelper.fetchNotes();
    noteList.value = noteList.reversed.toList();
  }

  Future<void> addNotes(Note note) async {
    await dbHelper.insertNote(note);
    loadnotes();
  }

  Future<void> updateNotes(Note note) async {
    await dbHelper.updateNote(note);
    loadnotes();
  }

  Future<void> deleteNote(int noteId) async {
    await dbHelper.deleteNote(noteId);
    loadnotes();
  }
}
