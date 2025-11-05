import 'package:todo_app/src/controller/appstate_controller.dart';
import 'package:todo_app/src/view/note_editor_screen.dart';
import 'package:todo_app/src/widgets/search_field.dart';
import 'package:flutter/material.dart';

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
    final folderArg = widget.folderName; // Used widget.folderName directly
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
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(folderArg),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: SearchField(onChanged: (v) => setState(() => q = v)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'Today',
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(color: Colors.grey.shade600),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () async {
                    await Navigator.pushNamed(
                      context,
                      NoteEditorScreen.route,
                      arguments: {'folder': folderArg, 'note': null},
                    );
                    setState(() {});
                  },
                  icon: const Icon(Icons.create_outlined),
                  label: const Text('New note'),
                ),
              ],
            ),
            Expanded(
              child: ListView.separated(
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final n = filtered[i];
                  return ListTile(
                    title: Text(
                      n.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      n.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(Icons.bookmark_border),
                    onTap: () async {
                      await Navigator.pushNamed(
                        context,
                        NoteEditorScreen.route,
                        arguments: {'folder': folderArg, 'note': n},
                      );
                      setState(() {});
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
