import 'package:todo_app/src/controller/appstate_controller.dart';
import 'package:todo_app/src/model/note_model.dart';
import 'package:flutter/material.dart';

class NoteEditorScreen extends StatefulWidget {
  static const route = '/editor';
  const NoteEditorScreen({super.key});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final title = TextEditingController();
  final description = TextEditingController();
  String currentFolder = 'Today';
  bool _inited = false;
  Note? editingNote;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_inited) return;

    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    if (args != null) {
      currentFolder = args['folder'] ?? 'Today';
      editingNote = args['note'];

      if (editingNote != null) {
        title.text = editingNote!.title;
        description.text = editingNote!.body;
      }
    }

    _inited = true;
  }

  void onSaved() async {
    if (editingNote != null) {
      final updatedNote = Note(
        id: editingNote!.id,
        title: title.text,
        body: description.text,
        createdAt: editingNote!.createdAt,
      );
      AppState.instance.updateNote(currentFolder, editingNote!, updatedNote);
    } else {
      // Generate a unique ID for new notes
      final noteId =
          DateTime.now().millisecondsSinceEpoch.toString() +
          (title.text.hashCode + description.text.hashCode).toString();
      AppState.instance.addNote(
        currentFolder,
        Note(
          id: noteId,
          title: title.text,
          body: description.text,
          createdAt: DateTime.now(),
        ),
      );
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(currentFolder),
        actions: [TextButton(onPressed: onSaved, child: const Text('Done'))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: title,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: description,
                maxLines: null,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(hintText: 'Description'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(12),
        child: FilledButton.icon(
          onPressed: onSaved,
          icon: const Icon(Icons.folder_open),
          label: const Text('Save'),
        ),
      ),
    );
  }
}
