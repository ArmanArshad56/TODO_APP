import 'package:todo_app/src/controller/appstate_controller.dart';
import 'package:todo_app/src/widgets/search_field.dart';
import 'package:todo_app/src/widgets/section_title.dart';
import 'package:flutter/material.dart';

class FolderSelectScreen extends StatefulWidget {
  static const route = '/select-folder';
  const FolderSelectScreen({super.key});

  @override
  State<FolderSelectScreen> createState() => _FolderSelectScreenState();
}

class _FolderSelectScreenState extends State<FolderSelectScreen> {
  String q = '';
  String? selectedFolder;

  @override
  Widget build(BuildContext context) {
    final app = AppState.instance;
    final folders = app.folders
        .where((f) => f.toLowerCase().contains(q.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const SectionTitle(
          'Folder',
          actions: [Icon(Icons.edit_outlined)],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SearchField(onChanged: (v) => setState(() => q = v)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: folders.length,
                itemBuilder: (_, i) {
                  final name = folders[i];
                  final checked = name == selectedFolder;
                  return CheckboxListTile(
                    value: checked,
                    onChanged: (_) => setState(() => selectedFolder = name),
                    title: Text(name),
                    secondary: const Icon(Icons.folder_outlined),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context, selectedFolder),
        child: const Icon(Icons.star_border),
      ),
    );
  }
}
