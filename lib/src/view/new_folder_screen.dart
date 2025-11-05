import 'package:todo_app/src/controller/appstate_controller.dart';
import 'package:todo_app/src/widgets/section_title.dart';
import 'package:flutter/material.dart';

class NewFolderScreen extends StatefulWidget {
  static const route = '/new-folder';
  const NewFolderScreen({super.key});

  @override
  State<NewFolderScreen> createState() => _NewFolderScreenState();
}

class _NewFolderScreenState extends State<NewFolderScreen> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SectionTitle('New Folder', actions: [SizedBox()]),
        actions: [
          TextButton(
            onPressed: () {
              final folderName = controller.text.trim();
              if (folderName.isNotEmpty) {
                AppState.instance.addFolder(folderName);
                Navigator.pop(context);
              }
            },
            child: const Text('Done'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: 'Folder name'),
            ),
          ],
        ),
      ),
    );
  }
}
