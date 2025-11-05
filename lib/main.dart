import 'package:todo_app/src/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/src/controller/appstate_controller.dart';
import 'package:todo_app/src/view/folder_details_screen.dart';
import 'package:todo_app/src/view/folder_list_screen.dart';
import 'package:todo_app/src/view/folder_selection_screen.dart';
import 'package:todo_app/src/view/new_folder_screen.dart';
import 'package:todo_app/src/view/note_editor_screen.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/src/model/note_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(NoteAdapter());

  // Initialize AppState and load data
  await AppState.instance.initialize();

  runApp(
    ChangeNotifierProvider.value(
      value: AppState.instance,
      child: const NotesApp(),
    ),
  );
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      initialRoute: FolderListScreen.route,
      onGenerateRoute: (settings) {
        if (settings.name == FolderDetailScreen.route) {
          final args = settings.arguments as String?;
          return MaterialPageRoute(
            builder: (_) => FolderDetailScreen(folderName: args ?? 'Default'),
          );
        }
        return null;
      },
      routes: {
        FolderListScreen.route: (_) => const FolderListScreen(),
        NewFolderScreen.route: (_) => const NewFolderScreen(),
        FolderSelectScreen.route: (_) => const FolderSelectScreen(),
        NoteEditorScreen.route: (_) => const NoteEditorScreen(),
      },
    );
  }
}
