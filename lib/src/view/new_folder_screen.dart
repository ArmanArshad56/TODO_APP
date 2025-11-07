// ignore_for_file: deprecated_member_use

import 'package:todo_app/src/controller/appstate_controller.dart';
import 'package:todo_app/src/theme/app_theme.dart';
import 'package:todo_app/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewFolderScreen extends StatefulWidget {
  static const route = '/new-folder';
  const NewFolderScreen({super.key});

  @override
  State<NewFolderScreen> createState() => _NewFolderScreenState();
}

class _NewFolderScreenState extends State<NewFolderScreen> {
  final controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  void _createFolder() {
    final folderName = controller.text.trim();
    if (folderName.isNotEmpty) {
      AppState.instance.addFolder(folderName);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Folder',
          style: TextStyle(
            fontSize: Responsive.fontSize(
              context,
              mobile: 16,
              tablet: 17,
              desktop: 8,
            ).sp,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _createFolder,
            child: Text(
              'Create',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryPurple,
                fontSize: Responsive.fontSize(
                  context,
                  mobile: 16,
                  tablet: 16,
                  desktop: 7,
                ).sp,
              ),
            ),
          ),
        ],
      ),
      body: ResponsiveContainer(
        padding: Responsive.padding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Responsive.spacing(
                context,
                mobile: 8.0,
                tablet: 12.0,
                desktop: 16.0,
              ).h,
            ),
            Text(
              'Folder Name',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: Responsive.fontSize(
                  context,
                  mobile: 17,
                  tablet: 18,
                  desktop: 10,
                ).sp,
              ),
            ),
            SizedBox(
              height: Responsive.spacing(
                context,
                mobile: 16.0,
                tablet: 16.0,
                desktop: 20.0,
              ).h,
            ),
            TextField(
              controller: controller,
              focusNode: _focusNode,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _createFolder(),
              decoration: InputDecoration(
                hintText: 'Enter folder name',
                hintStyle: TextStyle(
                  fontSize: Responsive.fontSize(
                    context,
                    mobile: 16.0,
                    tablet: 17.0,
                    desktop: 18.0,
                  ).sp,
                  color: AppTheme.textTertiary,
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(
                    Responsive.spacing(
                      context,
                      mobile: 6.0,
                      tablet: 10.0,
                      desktop: 12.0,
                    ).r,
                  ),
                  child: Icon(
                    Icons.folder_rounded,
                    color: AppTheme.primaryPurple,
                    size: Responsive.fontSize(
                      context,
                      mobile: 20.0,
                      tablet: 19.0,
                      desktop: 28.0,
                    ).sp,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: Responsive.spacing(
                context,
                mobile: 25.0,
                tablet: 36.0,
                desktop: 40.0,
              ).h,
            ),
            Container(
              padding: Responsive.cardPadding(context),
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(
                  Responsive.borderRadius(
                    context,
                    mobile: 16.0,
                    tablet: 20.0,
                    desktop: 24.0,
                  ).r,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: AppTheme.primaryPurple,
                    size: Responsive.fontSize(
                      context,
                      mobile: 22.0,
                      tablet: 26.0,
                      desktop: 28.0,
                    ).sp,
                  ),
                  SizedBox(
                    width: Responsive.spacing(
                      context,
                      mobile: 12.0,
                      tablet: 14.0,
                      desktop: 16.0,
                    ).w,
                  ),
                  Expanded(
                    child: Text(
                      'Folders help you organize your notes into categories',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: Responsive.padding(context, mobile: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10.r,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: FilledButton.icon(
            onPressed: _createFolder,
            icon: Icon(Icons.add_rounded, size: 20.sp),
            label: const Text('Create Folder'),
            style: FilledButton.styleFrom(
              padding: EdgeInsets.symmetric(
                vertical: Responsive.spacing(
                  context,
                  mobile: 16.0,
                  tablet: 25.0,
                  desktop: 24.0,
                ).h,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
