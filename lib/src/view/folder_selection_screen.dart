// ignore_for_file: deprecated_member_use

import 'package:todo_app/src/controller/appstate_controller.dart';
import 'package:todo_app/src/widgets/search_field.dart';
import 'package:todo_app/src/theme/app_theme.dart';
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
      appBar: AppBar(title: const Text('Select Folder')),
      body: folders.isEmpty && q.isEmpty
          ? _buildEmptyState()
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  SearchField(onChanged: (v) => setState(() => q = v)),
                  const SizedBox(height: 24),
                  Expanded(
                    child: folders.isEmpty
                        ? _buildEmptySearchState()
                        : ListView.separated(
                            itemCount: folders.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (_, i) {
                              final name = folders[i];
                              final checked = name == selectedFolder;
                              return _buildFolderItem(name, checked);
                            },
                          ),
                  ),
                ],
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
            onPressed: selectedFolder != null
                ? () => Navigator.pop(context, selectedFolder)
                : null,
            icon: const Icon(Icons.check_rounded, size: 20),
            label: const Text('Select'),
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

  Widget _buildFolderItem(String name, bool checked) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => selectedFolder = name),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: checked
                ? AppTheme.primaryPurple.withOpacity(0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: checked ? AppTheme.primaryPurple : Colors.grey.shade200,
              width: checked ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: checked
                      ? AppTheme.primaryPurple
                      : AppTheme.primaryPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.folder_rounded,
                  color: checked ? Colors.white : AppTheme.primaryPurple,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: checked ? FontWeight.bold : FontWeight.w500,
                    color: checked ? AppTheme.primaryPurple : null,
                  ),
                ),
              ),
              if (checked)
                Icon(
                  Icons.check_circle_rounded,
                  color: AppTheme.primaryPurple,
                  size: 24,
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
          Icon(Icons.folder_outlined, size: 80, color: AppTheme.textTertiary),
          const SizedBox(height: 16),
          Text(
            'No folders yet',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Create a folder first',
            style: Theme.of(context).textTheme.bodyMedium,
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
            'No folders found',
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
