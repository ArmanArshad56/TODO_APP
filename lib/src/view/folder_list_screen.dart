// ignore_for_file: deprecated_member_use

import 'package:todo_app/src/controller/appstate_controller.dart';
import 'package:todo_app/src/view/folder_details_screen.dart';
import 'package:todo_app/src/view/new_folder_screen.dart';
import 'package:todo_app/src/widgets/search_field.dart';
import 'package:todo_app/src/widgets/section_title.dart';
import 'package:todo_app/src/theme/app_theme.dart';
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
        title: const SectionTitle('Folders'),
        actions: [
          if (selectedFolders.isNotEmpty)
            IconButton(
              icon: Icon(
                Icons.delete_outline_rounded,
                color: AppTheme.accentPink,
              ),
              onPressed: () => _showDeleteDialog(context),
              tooltip: 'Delete',
            ),
        ],
      ),
      body: folders.isEmpty && q.isEmpty
          ? _buildEmptyState()
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchField(onChanged: (v) => setState(() => q = v)),
                  const SizedBox(height: 24),
                  if (folders.isNotEmpty)
                    Text(
                      '${folders.length} ${folders.length == 1 ? 'folder' : 'folders'}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: folders.isEmpty
                        ? _buildEmptySearchState()
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 1.1,
                                ),
                            itemCount: folders.length,
                            itemBuilder: (_, i) {
                              final name = folders[i];
                              final noteCount = app.notes[name]?.length ?? 0;
                              final isSelected = selectedFolders.contains(name);
                              return _buildFolderCard(
                                name,
                                noteCount,
                                isSelected,
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, NewFolderScreen.route),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Folder'),
      ),
    );
  }

  Widget _buildFolderCard(String name, int noteCount, bool isSelected) {
    final colors = [
      [AppTheme.primaryPurple, AppTheme.primaryBlue],
      [AppTheme.accentPink, const Color(0xFFF472B6)],
      [AppTheme.accentCyan, const Color(0xFF22D3EE)],
      [const Color(0xFF10B981), const Color(0xFF34D399)],
    ];
    final colorIndex = name.hashCode.abs() % colors.length;
    final gradientColors = colors[colorIndex];

    return GestureDetector(
      onTap: () {
        if (selectedFolders.isNotEmpty) {
          setState(() {
            if (isSelected) {
              selectedFolders.remove(name);
            } else {
              selectedFolders.add(name);
            }
          });
        } else {
          Navigator.pushNamed(
            context,
            FolderDetailScreen.route,
            arguments: name,
          );
        }
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isSelected
                ? [
                    gradientColors[0].withOpacity(0.9),
                    gradientColors[1].withOpacity(0.9),
                  ]
                : [gradientColors[0], gradientColors[1]],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withOpacity(0.3),
              blurRadius: isSelected ? 20 : 12,
              offset: Offset(0, isSelected ? 8 : 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.folder_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$noteCount ${noteCount == 1 ? 'note' : 'notes'}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isSelected)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: AppTheme.primaryPurple,
                    size: 20,
                  ),
                ),
              ),
          ],
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
              Icons.folder_outlined,
              size: 80,
              color: AppTheme.primaryPurple.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text('No folders yet', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Create your first folder to get started',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () =>
                Navigator.pushNamed(context, NewFolderScreen.route),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Create Folder'),
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

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Delete Folders'),
          content: Text(
            'Are you sure you want to delete ${selectedFolders.length} ${selectedFolders.length == 1 ? 'folder' : 'folders'}? All notes in these folders will also be deleted.',
            style: Theme.of(context).textTheme.bodyMedium,
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
              style: TextButton.styleFrom(foregroundColor: AppTheme.accentPink),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
