// ignore_for_file: deprecated_member_use

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/src/controller/appstate_controller.dart';
import 'package:todo_app/src/view/note_editor_screen.dart';
import 'package:todo_app/src/widgets/search_field.dart';
import 'package:todo_app/src/theme/app_theme.dart';
import 'package:todo_app/src/utils/responsive.dart';
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
                        icon: Icon(
                          Icons.add_rounded,
                          size: Responsive.fontSize(
                            context,
                            mobile: 20.0,
                            tablet: 22.0,
                            desktop: 24.0,
                          ).sp,
                        ),
                        label: const Text('New Note'),
                        style: FilledButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: Responsive.spacing(
                              context,
                              mobile: 20.0,
                              tablet: 24.0,
                              desktop: 28.0,
                            ).w,
                            vertical: Responsive.spacing(
                              context,
                              mobile: 12.0,
                              tablet: 14.0,
                              desktop: 16.0,
                            ).h,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Responsive.spacing(
                      context,
                      mobile: 16.0,
                      tablet: 20.0,
                      desktop: 24.0,
                    ).h,
                  ),
                  Expanded(
                    child: filtered.isEmpty
                        ? _buildEmptySearchState()
                        : ListView.separated(
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) => SizedBox(
                              height: Responsive.spacing(
                                context,
                                mobile: 12.0,
                                tablet: 16.0,
                                desktop: 20.0,
                              ).h,
                            ),
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              Responsive.borderRadius(
                context,
                mobile: 16.0,
                tablet: 20.0,
                desktop: 24.0,
              ).r,
            ),
            border: Border.all(
              color: Colors.grey.shade200,
              width: Responsive.value<double>(
                context,
                mobile: 1.0,
                tablet: 1.5,
                desktop: 2.0,
              ).w,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: Responsive.spacing(
                  context,
                  mobile: 10.0,
                  tablet: 12.0,
                  desktop: 14.0,
                ).r,
                offset: Offset(
                  0,
                  Responsive.spacing(
                    context,
                    mobile: 2.0,
                    tablet: 3.0,
                    desktop: 4.0,
                  ).h,
                ),
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
                  SizedBox(
                    width: Responsive.spacing(
                      context,
                      mobile: 12.0,
                      tablet: 14.0,
                      desktop: 16.0,
                    ).w,
                  ),
                  Container(
                    padding: EdgeInsets.all(
                      Responsive.spacing(
                        context,
                        mobile: 8.0,
                        tablet: 10.0,
                        desktop: 12.0,
                      ).r,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryPurple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                        Responsive.borderRadius(
                          context,
                          mobile: 8.0,
                          tablet: 10.0,
                          desktop: 12.0,
                        ).r,
                      ),
                    ),
                    child: Icon(
                      Icons.note_rounded,
                      color: AppTheme.primaryPurple,
                      size: Responsive.fontSize(
                        context,
                        mobile: 20.0,
                        tablet: 22.0,
                        desktop: 24.0,
                      ).sp,
                    ),
                  ),
                ],
              ),
              if (note.body.isNotEmpty) ...[
                SizedBox(
                  height: Responsive.spacing(
                    context,
                    mobile: 12.0,
                    tablet: 14.0,
                    desktop: 16.0,
                  ).h,
                ),
                Text(
                  note.body,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: Responsive.value<double>(
                      context,
                      mobile: 1.5,
                      tablet: 1.6,
                      desktop: 1.7,
                    ),
                  ),
                  maxLines: Responsive.value<int>(
                    context,
                    mobile: 3,
                    tablet: 4,
                    desktop: 5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              SizedBox(
                height: Responsive.spacing(
                  context,
                  mobile: 16.0,
                  tablet: 18.0,
                  desktop: 20.0,
                ).h,
              ),
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: Responsive.fontSize(
                      context,
                      mobile: 14.0,
                      tablet: 15.0,
                      desktop: 16.0,
                    ).sp,
                    color: AppTheme.textTertiary,
                  ),
                  SizedBox(
                    width: Responsive.spacing(
                      context,
                      mobile: 6.0,
                      tablet: 8.0,
                      desktop: 10.0,
                    ).w,
                  ),
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
            padding: EdgeInsets.all(32.r),
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
          SizedBox(height: 24.h),
          Text('No notes yet', style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 8.h),
          Text(
            'Create your first note in this folder',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32.h),
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
            size: 64.sp,
            color: AppTheme.textTertiary,
          ),
          SizedBox(height: 16.sp),
          Text(
            'No notes found',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 8.h),
          Text(
            'Try a different search term',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
