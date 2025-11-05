import 'package:todo_app/src/controller/appstate_controller.dart';
import 'package:todo_app/src/view/folder_details_screen.dart';
import 'package:todo_app/src/view/new_folder_screen.dart';
import 'package:todo_app/src/widgets/search_field.dart';
import 'package:todo_app/src/widgets/section_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FolderListScreen extends StatefulWidget {
  static const route = '/folders';
  const FolderListScreen({super.key});

  @override
  State<FolderListScreen> createState() => _FolderListScreenState();
}

class _FolderListScreenState extends State<FolderListScreen> {
  String q = '';
  final Set<String> selectedFolders = {};

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final folders = app.folders
        .where((f) => f.toLowerCase().contains(q.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: SectionTitle(
          'Folders',
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: selectedFolders.isNotEmpty
                  ? () => _showDeleteDialog(context)
                  : null,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SearchField(onChanged: (v) => setState(() => q = v)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: folders.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final name = folders[i];
                  final isSelected = selectedFolders.contains(name);
                  return ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    tileColor: isSelected
                        ? Colors.blue.shade100
                        : Colors.grey.shade100,
                    leading: const Icon(Icons.folder_outlined),
                    title: Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        FolderDetailScreen.route,
                        arguments: name,
                      );
                    },
                    onLongPress: () {
                      setState(() {
                        if (isSelected) {
                          selectedFolders.remove(name);
                        } else {
                          selectedFolders.add(name);
                        }
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, NewFolderScreen.route),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    selectedFolders.join(', ');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Folder'),
          content: Text(
            'Kya aap "$selectedFolders" folder delete karna chahte hain? Notes bhi delete ho jaayenge.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                for (final folder in List.from(selectedFolders)) {
                  AppState.instance.removeFolder(folder);
                }
                setState(() => selectedFolders.clear());
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
