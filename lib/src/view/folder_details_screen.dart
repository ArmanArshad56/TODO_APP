// ignore_for_file: deprecated_member_use

import 'package:todo_app/src/controller/appstate_controller.dart';
import 'package:todo_app/src/view/note_editor_screen.dart';
import 'package:todo_app/src/widgets/search_field.dart';
import 'package:todo_app/src/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FolderDetailScreen extends StatefulWidget {
  static const route = '/folder';
  final String folderName;
  const FolderDetailScreen({super.key, required this.folderName});

  @override
  State<FolderDetailScreen> createState() => _FolderDetailScreenState();
}

class _FolderDetailScreenState extends State<FolderDetailScreen> {
  String q = '';

  @override
  Widget build(BuildContext context) {
    final folderArg = widget.folderName;
    final app = AppState.instance;
    final all = app.notes[folderArg] ?? [];
    final filtered = all
        .where(
          (n) =>
              n.title.toLowerCase().contains(q.toLowerCase()) ||
              n.body.toLowerCase().contains(q.toLowerCase()),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(folderArg),
      ),
      body: all.isEmpty && q.isEmpty
          ? _buildEmptyState()
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchField(onChanged: (v) => setState(() => q = v)),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        filtered.isEmpty
                            ? 'No notes'
                            : '${filtered.length} ${filtered.length == 1 ? 'note' : 'notes'}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      FilledButton.icon(
                        onPressed: () async {
                          await Navigator.pushNamed(
                            context,
                            NoteEditorScreen.route,
                            arguments: {'folder': folderArg, 'note': null},
                          );
                          setState(() {});
                        },
                        icon: const Icon(Icons.add_rounded, size: 20),
                        label: const Text('New Note'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: filtered.isEmpty
                        ? _buildEmptySearchState()
                        : ListView.separated(
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (_, i) {
                              final n = filtered[i];
                              return _buildNoteCard(n, folderArg);
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildNoteCard(note, String folder) {
    final dateFormat = DateFormat('MMM d, y');
    final timeFormat = DateFormat('h:mm a');
    final isToday =
        note.createdAt.year == DateTime.now().year &&
        note.createdAt.month == DateTime.now().month &&
        note.createdAt.day == DateTime.now().day;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          await Navigator.pushNamed(
            context,
            NoteEditorScreen.route,
            arguments: {'folder': folder, 'note': note},
          );
          setState(() {});
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      note.title.isEmpty ? '(Untitled)' : note.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryPurple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.note_rounded,
                      color: AppTheme.primaryPurple,
                      size: 20,
                    ),
                  ),
                ],
              ),
              if (note.body.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  note.body,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(height: 1.5),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 14,
                    color: AppTheme.textTertiary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isToday
                        ? 'Today at ${timeFormat.format(note.createdAt)}'
                        : dateFormat.format(note.createdAt),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppTheme.primaryPurple.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.note_add_outlined,
              size: 80,
              color: AppTheme.primaryPurple.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text('No notes yet', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Create your first note in this folder',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () async {
              await Navigator.pushNamed(
                context,
                NoteEditorScreen.route,
                arguments: {'folder': widget.folderName, 'note': null},
              );
              setState(() {});
            },
            icon: const Icon(Icons.add_rounded),
            label: const Text('Create Note'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySearchState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: AppTheme.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            'No notes found',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different search term',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
