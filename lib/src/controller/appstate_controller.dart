import 'package:todo_app/src/model/note_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppState extends ChangeNotifier {
  static final AppState instance = AppState._();
  AppState._();

  late Box<String> _foldersBox;
  late Box<Note> _notesBox;

  List<String> _folders = [];
  final Map<String, List<Note>> _notes = {};

  List<String> get folders => List.unmodifiable(_folders);
  Map<String, List<Note>> get notes => Map.unmodifiable(_notes);

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    _foldersBox = await Hive.openBox<String>('folders');
    _notesBox = await Hive.openBox<Note>('notes');

    // Load folders
    _folders = _foldersBox.values.toList();

    // Load notes for each folder
    for (String folder in _folders) {
      final noteKeys = _notesBox.keys
          .where((key) => key.toString().startsWith('$folder:'))
          .toList();

      _notes[folder] = noteKeys.map((key) => _notesBox.get(key)!).toList();
    }

    _initialized = true;
    notifyListeners();
  }

  void addFolder(String name) {
    if (name.trim().isEmpty) return;
    if (!_folders.contains(name)) {
      _folders.add(name);
      _foldersBox.put(name, name);
      _notes[name] = [];
      notifyListeners();
    }
  }

  void addNote(String folder, Note note) {
    _notes.putIfAbsent(folder, () => []);
    _notes[folder]!.add(note);

    // Save to Hive with a unique key based on folder name and note ID
    final key = '$folder:${note.id}';
    _notesBox.put(key, note);

    notifyListeners();
  }

  void removeFolder(String folderName) {
    _folders.remove(folderName);
    _foldersBox.delete(folderName);

    // Remove all notes for this folder from Hive
    if (_notes.containsKey(folderName)) {
      final noteKeys = _notesBox.keys
          .where((key) => key.toString().startsWith('$folderName:'))
          .toList();

      for (var key in noteKeys) {
        _notesBox.delete(key);
      }

      _notes.remove(folderName);
    }

    notifyListeners();
  }

  void removeNote(String folder, Note note) {
    if (_notes.containsKey(folder)) {
      _notes[folder]!.remove(note);

      // Remove from Hive using the note's ID
      final key = '$folder:${note.id}';
      _notesBox.delete(key);

      notifyListeners();
    }
  }

  void updateNote(String folder, Note oldNote, Note newNote) {
    if (_notes.containsKey(folder)) {
      final index = _notes[folder]!.indexOf(oldNote);
      if (index != -1) {
        // Ensure the new note has the same ID as the old note
        final updatedNote = newNote.copyWith(id: oldNote.id);
        _notes[folder]![index] = updatedNote;

        // Update in Hive using the note's ID
        final key = '$folder:${oldNote.id}';
        _notesBox.put(key, updatedNote);

        notifyListeners();
      }
    }
  }
}
