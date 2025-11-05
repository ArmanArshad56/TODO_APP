// ignore_for_file: deprecated_member_use

import 'package:todo_app/src/controller/appstate_controller.dart';
import 'package:todo_app/src/model/note_model.dart';
import 'package:todo_app/src/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteEditorScreen extends StatefulWidget {
  static const route = '/editor';
  const NoteEditorScreen({super.key});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final title = TextEditingController();
  final description = TextEditingController();
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
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

  @override
  void dispose() {
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    title.dispose();
    description.dispose();
    super.dispose();
  }

  void onSaved() async {
    if (editingNote != null) {
      final updatedNote = Note(
        id: editingNote!.id,
        title: title.text.trim(),
        body: description.text.trim(),
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
          title: title.text.trim(),
          body: description.text.trim(),
          createdAt: DateTime.now(),
        ),
      );
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, y • h:mm a');
    final createdDate = editingNote != null
        ? dateFormat.format(editingNote!.createdAt)
        : dateFormat.format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(currentFolder, style: Theme.of(context).textTheme.titleLarge),
            if (editingNote != null)
              Text(
                'Created $createdDate',
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: onSaved,
            child: Text(
              'Save',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryPurple,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: title,
                focusNode: _titleFocus,
                textInputAction: TextInputAction.next,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: 'Title',
                  hintStyle: TextStyle(
                    color: AppTheme.textTertiary,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                onSubmitted: (_) => _descriptionFocus.requestFocus(),
              ),
              const SizedBox(height: 8),
              Text(createdDate, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 24),
              Expanded(
                child: TextField(
                  controller: description,
                  focusNode: _descriptionFocus,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(height: 1.6, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'Start writing...',
                    hintStyle: TextStyle(
                      color: AppTheme.textTertiary,
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: FilledButton.icon(
            onPressed: onSaved,
            icon: const Icon(Icons.check_rounded, size: 20),
            label: Text(editingNote != null ? 'Update Note' : 'Save Note'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
