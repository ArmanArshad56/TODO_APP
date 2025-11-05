import 'package:todo_app/src/model/note_model.dart';
import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  static final AppState instance = AppState._();
  AppState._();

  final List<String> folders = []; // Uncommented for mock data
  final Map<String, List<Note>> notes = {
    // 'Arman': [Note('Shopping list', 'Buy milk, eggs, rice', DateTime.now())],
    // 'Ideas': [Note('App concept', 'Face QR idea, link socials', DateTime.now())],
    // 'Today': [Note('Workout', 'Push/pull/legs', DateTime.now())],
  };

  // Removed duplicates, used this one
  void addFolder(String name) {
    if (name.trim().isEmpty) return;
    if (!folders.contains(name)) {
      folders.add(name);
      notes[name] = [];
      notifyListeners();
    }
  }

  void addNote(String folder, Note note) {
    notes.putIfAbsent(folder, () => []);
    notes[folder]!.add(note);
    notifyListeners();
  }

  void removeFolder(String folderName) {
    folders.remove(folderName);
    notes.remove(folderName);
    notifyListeners();
  }
}
