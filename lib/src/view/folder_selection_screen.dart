// ignore_for_file: deprecated_member_use

import 'package:todo_app/src/controller/appstate_controller.dart';
import 'package:todo_app/src/widgets/search_field.dart';
import 'package:todo_app/src/theme/app_theme.dart';
import 'package:todo_app/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          : ResponsiveContainer(
              padding: Responsive.padding(context),
              child: Column(
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
                  Expanded(
                    child: folders.isEmpty
                        ? _buildEmptySearchState()
                        : ListView.separated(
                            itemCount: folders.length,
                            separatorBuilder: (_, __) => SizedBox(
                              height: Responsive.spacing(
                                context,
                                mobile: 12.0,
                                tablet: 16.0,
                                desktop: 20.0,
                              ).h,
                            ),
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
        padding: Responsive.padding(context),
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
        borderRadius: BorderRadius.circular(
          Responsive.borderRadius(
            context,
            mobile: 16.0,
            tablet: 20.0,
            desktop: 24.0,
          ).r,
        ),
        child: Container(
          padding: Responsive.cardPadding(context),
          decoration: BoxDecoration(
            color: checked
                ? AppTheme.primaryPurple.withOpacity(0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(
              Responsive.borderRadius(
                context,
                mobile: 16.0,
                tablet: 20.0,
                desktop: 24.0,
              ).r,
            ),
            border: Border.all(
              color: checked ? AppTheme.primaryPurple : Colors.grey.shade200,
              width: Responsive.value<double>(
                context,
                mobile: checked ? 2.0 : 1.0,
                tablet: checked ? 2.5 : 1.5,
                desktop: checked ? 3.0 : 2.0,
              ).w,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(
                  Responsive.spacing(
                    context,
                    mobile: 12.0,
                    tablet: 14.0,
                    desktop: 16.0,
                  ).r,
                ),
                decoration: BoxDecoration(
                  color: checked
                      ? AppTheme.primaryPurple
                      : AppTheme.primaryPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                    Responsive.borderRadius(
                      context,
                      mobile: 12.0,
                      tablet: 14.0,
                      desktop: 16.0,
                    ).r,
                  ),
                ),
                child: Icon(
                  Icons.folder_rounded,
                  color: checked ? Colors.white : AppTheme.primaryPurple,
                  size: Responsive.fontSize(
                    context,
                    mobile: 24.0,
                    tablet: 26.0,
                    desktop: 28.0,
                  ).sp,
                ),
              ),
              SizedBox(
                width: Responsive.spacing(
                  context,
                  mobile: 16.0,
                  tablet: 18.0,
                  desktop: 20.0,
                ).w,
              ),
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
                  size: Responsive.fontSize(
                    context,
                    mobile: 24.0,
                    tablet: 26.0,
                    desktop: 28.0,
                  ).sp,
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
