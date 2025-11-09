// ignore_for_file: deprecated_member_use

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/src/controller/appstate_controller.dart';
import 'package:todo_app/src/view/folder_details_screen.dart';
import 'package:todo_app/src/view/new_folder_screen.dart';
import 'package:todo_app/src/widgets/search_field.dart';
import 'package:todo_app/src/widgets/section_title.dart';
import 'package:todo_app/src/theme/app_theme.dart';
import 'package:todo_app/src/utils/responsive.dart';
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
          : ResponsiveContainer(
              padding: Responsive.padding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchField(onChanged: (v) => setState(() => q = v)),
                  SizedBox(
                    height: Responsive.spacing(
                      context,
                      mobile: 24.0,
                      tablet: 28.0,
                      desktop: 32.0,
                    ).h,
                  ),
                  if (folders.isNotEmpty)
                    Text(
                      '${folders.length} ${folders.length == 1 ? 'folder' : 'folders'}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  SizedBox(
                    height: Responsive.spacing(
                      context,
                      mobile: 12.0,
                      tablet: 16.0,
                      desktop: 20.0,
                    ).h,
                  ),
                  Expanded(
                    child: folders.isEmpty
                        ? _buildEmptySearchState()
                        : ResponsiveGridView(
                            padding: EdgeInsets.zero,
                            crossAxisSpacing: Responsive.spacing(
                              context,
                              mobile: 10.0,
                              tablet: 5.0,
                              desktop: 6.0,
                            ).w,
                            mainAxisSpacing: Responsive.spacing(
                              context,
                              mobile: 16.0,
                              tablet: 20.0,
                              desktop: 34.0,
                            ).h,
                            childAspectRatio: Responsive.value<double>(
                              context,
                              mobile: 1.25,
                              tablet: 0.9,
                              desktop: 1.3,
                            ),
                            children: folders.map((name) {
                              final noteCount = app.notes[name]?.length ?? 0;
                              final isSelected = selectedFolders.contains(name);
                              return _buildFolderCard(
                                name,
                                noteCount,
                                isSelected,
                              );
                            }).toList(),
                          ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, NewFolderScreen.route),
        icon: Icon(
          Icons.add_rounded,
          size: Responsive.fontSize(
            context,
            mobile: 18,
            tablet: 20,
            desktop: 6,
          ).sp,
        ),
        label: Text(
          'New Folder',
          style: TextStyle(
            fontSize: Responsive.fontSize(
              context,
              mobile: 16,
              tablet: 10,
              desktop: 4,
            ).sp,
          ),
        ),
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
          borderRadius: BorderRadius.circular(
            Responsive.borderRadius(
              context,
              mobile: 20.0,
              tablet: 24.0,
              desktop: 28.0,
            ).r,
          ),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withOpacity(0.3),
              blurRadius: (isSelected ? 20 : 12).r,
              offset: Offset(0, (isSelected ? 8 : 4).h),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: Responsive.cardPadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(
                      Responsive.spacing(
                        context,
                        mobile: 8.0,
                        tablet: 14.0,
                        desktop: 4.0,
                      ).r,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(
                        Responsive.borderRadius(
                          context,
                          mobile: 12.0,
                          tablet: 14.0,
                          desktop: 14.0,
                        ).r,
                      ),
                    ),
                    child: Icon(
                      Icons.folder_rounded,
                      color: Colors.white,
                      size: Responsive.fontSize(
                        context,
                        mobile: 24.0,
                        tablet: 36.0,
                        desktop: 12.0,
                      ).sp,
                    ),
                  ),
                  // const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Responsive.fontSize(
                            context,
                            mobile: 24.0,
                            tablet: 20.0,
                            desktop: 12.0,
                          ).sp,
                          fontWeight: FontWeight.bold,
                          // letterSpacing: -0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: Responsive.spacing(
                          context,
                          mobile: 4.0,
                          tablet: 6.0,
                          desktop: 0.5,
                        ).h,
                      ),
                      Text(
                        '$noteCount ${noteCount == 1 ? 'note' : 'notes'}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: Responsive.fontSize(
                            context,
                            mobile: 13.0,
                            tablet: 14.0,
                            desktop: 6.0,
                          ).sp,
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
                top: Responsive.spacing(
                  context,
                  mobile: 12.0,
                  tablet: 14.0,
                  desktop: 24.0,
                ).h,
                right: Responsive.spacing(
                  context,
                  mobile: 12.0,
                  tablet: 14.0,
                  desktop: 5.0,
                ).w,
                child: Container(
                  padding: EdgeInsets.all(
                    Responsive.spacing(
                      context,
                      mobile: 2.5,
                      tablet: 5.0,
                      desktop: 2.0,
                    ).r,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: AppTheme.primaryPurple,
                    size: Responsive.fontSize(
                      context,
                      mobile: 20.0,
                      tablet: 22.0,
                      desktop: 8.0,
                    ).sp,
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
            padding: EdgeInsets.all(32.r),
            decoration: BoxDecoration(
              color: AppTheme.primaryPurple.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.folder_outlined,
              size: Responsive.fontSize(
                context,
                mobile: 40,
                tablet: 30,
                desktop: 30,
              ).sp,
              color: AppTheme.primaryPurple.withOpacity(0.5),
            ),
          ),
          SizedBox(
            height: Responsive.spacing(
              context,
              mobile: 15,
              tablet: 30,
              desktop: 30,
            ).h,
          ),
          Text(
            'No folders yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: Responsive.fontSize(
                context,
                mobile: 16,
                tablet: 16,
                desktop: 14,
              ).sp,
            ),
          ),
          SizedBox(
            height: Responsive.spacing(
              context,
              mobile: 8,
              tablet: 30,
              desktop: 10,
            ).h,
          ),
          Text(
            'Create your first folder to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: Responsive.fontSize(
                context,
                mobile: 16,
                tablet: 16,
                desktop: 34,
              ).sp,
            ),
            // textAlign: TextAlign.center,
          ),
          // SizedBox(height: 32.h),
          // ElevatedButton.icon(
          //   onPressed: () =>
          //       Navigator.pushNamed(context, NewFolderScreen.route),
          //   icon: const Icon(Icons.add_rounded),
          //   label: const Text('Create Folder'),
          // ),
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
            size: Responsive.fontSize(
              context,
              mobile: 16,
              tablet: 16,
              desktop: 32,
            ).sp,
            color: AppTheme.textTertiary,
          ),
          SizedBox(height: 16.h),
          Text(
            'No folders found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: Responsive.fontSize(
                context,
                mobile: 16,
                tablet: 16,
                desktop: 10,
              ).sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Try a different search term',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: Responsive.fontSize(
                context,
                mobile: 16,
                tablet: 16,
                desktop: 12,
              ).sp,
            ),
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
            borderRadius: BorderRadius.circular(
              Responsive.borderRadius(
                context,
                mobile: 20.0,
                tablet: 24.0,
                desktop: 28.0,
              ).r,
            ),
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
