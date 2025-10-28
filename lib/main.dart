// lib/main.dart
// Flutter UI skeleton matching the user's sketch (blue/white/black)
// Screens:
// 1) FolderListScreen (search + list + add)
// 2) NewFolderScreen (text + Done)
// 3) FolderSelectScreen (search + selectable folder rows)
// 4) NoteEditorScreen (editor with back + Done)
// 5) FolderDetailScreen (folder header + search + notes list)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider.value(
      value: AppState.instance, // Provide singleton AppState to the widget tree
      child: const NotesApp(),
    ),
  );
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF0A84FF); // iOS blue vibe
    const surfaceWhite = Colors.white;
    const textBlack = Colors.black87;

    final theme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        brightness: Brightness.light,
        primary: primaryBlue,
      ).copyWith(surface: surfaceWhite, onSurface: textBlack),
      scaffoldBackgroundColor: surfaceWhite,
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceWhite,
        foregroundColor: textBlack,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryBlue, width: 1.4),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: primaryBlue,
        textColor: textBlack,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
      ),
    );

    return MaterialApp(
      title: 'Notes',
      debugShowCheckedModeBanner: false,
      theme: theme,
      initialRoute: FolderListScreen.route,
      routes: {
        FolderListScreen.route: (_) => const FolderListScreen(),
        NewFolderScreen.route: (_) => const NewFolderScreen(),
        FolderSelectScreen.route: (_) => const FolderSelectScreen(),
        NoteEditorScreen.route: (_) => const NoteEditorScreen(),
        FolderDetailScreen.route: (_) =>
            const FolderDetailScreen(folderName: 'Arman'),
      },
    );
  }
}

// --- Mock data holder (replace later with Hive/SQLite + Firebase sync) ---
// class AppState extends ChangeNotifier {
//   static final AppState instance = AppState._();
//   AppState._();

//   final List<String> folders = ['Arman', 'Ideas', 'Today'];
//   final Map<String, List<Note>> notes = {
//     'Arman': [Note('Shopping list', 'Buy milk, eggs, rice', DateTime.now())],
//     'Ideas': [
//       Note('App concept', 'Face QR idea, link socials', DateTime.now()),
//     ],
//     'Today': [Note('Workout', 'Push/pull/legs', DateTime.now())],
//   };

//   void addFolder(String name) {
//     if (name.trim().isEmpty) return;
//     if (!folders.contains(name)) {
//       folders.add(name);
//       notes[name] = [];
//       notifyListeners();
//     }
//   }

//   void addNote(String folder, Note note) {
//     notes.putIfAbsent(folder, () => []);
//     notes[folder]!.add(note);
//     notifyListeners();
//   }
// }

class AppState extends ChangeNotifier {
  static final AppState instance = AppState._();
  AppState._();
  final Map<String, List<Note>> notes = {}; // Store notes by folder
  final List<String> folders = ['Arman', 'Ideas', 'Today'];
  // final Map<String, List<Note>> notes = {
  //   'Arman': [Note('Shopping list', 'Buy milk, eggs, rice', DateTime.now())],
  //   'Ideas': [
  //     Note('App concept', 'Face QR idea, link socials', DateTime.now()),
  //   ],
  //   'Today': [Note('Workout', 'Push/pull/legs', DateTime.now())],
  // };

  // Folder ko remove karne ka function
  void removeFolder(String folderName) {
    folders.remove(folderName); // Folder ko remove karna
    notes.remove(folderName); // Associated notes ko bhi remove karna
    notifyListeners(); // UI ko update karna
  }

  // Update this to notify listeners on changes
  void addFolder(String name) {
    if (name.trim().isEmpty) return;
    if (!folders.contains(name)) {
      folders.add(name);
      notes[name] = [];
      notifyListeners(); // This will notify listeners of changes
    }
  }

  void addNote(String folder, Note note) {
    notes.putIfAbsent(folder, () => []);
    notes[folder]!.add(note);
    notifyListeners();
  }
}

class Note {
  String title;
  String body;
  final DateTime createdAt;
  Note(this.title, this.body, this.createdAt);
}

// --- Reusable widgets ---
class SearchField extends StatelessWidget {
  final String hint;
  final ValueChanged<String>? onChanged;
  const SearchField({super.key, this.hint = 'Search', this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  final List<Widget> actions;
  const SectionTitle(this.text, {super.key, this.actions = const []});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const Spacer(),
        ...actions,
      ],
    );
  }
}

// --- Screen 1: Folder List ---
class FolderListScreen extends StatefulWidget {
  static const route = '/folders';
  const FolderListScreen({super.key});

  @override
  State<FolderListScreen> createState() => _FolderListScreenState();
}

class _FolderListScreenState extends State<FolderListScreen> {
  String q = '';
  String? selectedFolder;
  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context); // Listen to changes in AppState
    final folders = app.folders
        .where((f) => f.toLowerCase().contains(q.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: SectionTitle(
          'Folders',
          // actions: [Icon(Icons.edit_outlined)],
          // actions: [
          //   // Edit action
          //   IconButton(icon: Icon(Icons.edit_outlined), onPressed: () {}),
          // ],
          actions: [
            // Edit action ke liye delete button add karte hain
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: selectedFolder != null
                  ? () {
                      // Agar folder select kiya hai to delete karenge
                      _showDeleteDialog(context); // delete confirmation dialog
                    }
                  : null, // Agar koi folder select nahi kiya to button disabled hoga
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
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
                  return ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    tileColor: Colors.grey.shade100,
                    leading: const Icon(Icons.folder_outlined),
                    title: Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),

                    // onTap: () => Navigator.pushNamed(
                    //   context,
                    //   FolderDetailScreen.route,
                    //   arguments: name,
                    // ),
                    onTap: () {
                      setState(() {
                        selectedFolder = name; // Folder select karna
                      });
                      Navigator.pushNamed(
                        context,
                        FolderDetailScreen.route,
                        arguments: name,
                      );
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

  // Function to show a dialog for confirmation before deleting a folder
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Folder'),
          content: Text(
            'Are you sure you want to delete the folder "$selectedFolder"',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // agar user ne confirm kiya to folder delete karenge
                if (selectedFolder != null) {
                  AppState.instance.removeFolder(selectedFolder!);
                }
                Navigator.of(context).pop();
                setState(() {});
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

// --- Screen 2: New Folder ---
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
                // folder ko add karna
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
            // const SizedBox(height: 24),
            // Container(
            //   height: 140,
            //   decoration: BoxDecoration(
            //     color: Colors.grey.shade100,
            //     borderRadius: BorderRadius.circular(16),
            //     border: Border.all(color: Colors.grey.shade300),
            //   ),
            //   alignment: Alignment.center,
            //   // child: Text(
            //   //   'typing…',
            //   //   style: TextStyle(color: Colors.grey.shade600),
            //   // ),
            // ),
          ],
        ),
      ),
    );
  }
}

// --- Screen 3: Folder Select (for moving/saving) ---
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
      appBar: AppBar(
        title: const SectionTitle(
          'Folder',
          actions: [Icon(Icons.edit_outlined)],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SearchField(onChanged: (v) => setState(() => q = v)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: folders.length,
                itemBuilder: (_, i) {
                  final name = folders[i];
                  final checked = name == selectedFolder;
                  return CheckboxListTile(
                    value: checked,
                    onChanged: (_) => setState(() => selectedFolder = name),
                    title: Text(name),
                    secondary: const Icon(Icons.folder_outlined),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context, selectedFolder),
        child: const Icon(Icons.star_border), // matches sketch star icon
      ),
    );
  }
}

// --- Screen 4: Note Editor ---
class NoteEditorScreen extends StatefulWidget {
  static const route = '/editor';
  const NoteEditorScreen({super.key});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final title = TextEditingController();
  final description = TextEditingController();
  String currentFolder = 'Today';
  bool _inited = false; // Ensure arguments are only read once
  Note? editingNote;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_inited) return;

    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    if (args != null) {
      currentFolder = args['folder'] ?? 'Today';
      editingNote = args['note']; // Get the note object if it exists

      if (editingNote != null) {
        title.text = editingNote!.title;
        description.text = editingNote!.body;
      }
    }

    _inited = true;
  }

  void onSaved() async {
    if (editingNote != null) {
      // If editing an existing note, update it
      editingNote!.title = title.text;
      editingNote!.body = description.text;
    } else {
      // Otherwise, create a new note
      AppState.instance.addNote(
        currentFolder,
        Note(title.text, description.text, DateTime.now()),
      );
    }
    Navigator.pop(context); // Return to the previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(currentFolder),
        actions: [
          TextButton(
            child: const Text('Done'),
            onPressed: () {
              onSaved();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: title,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: description,
                maxLines: null,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(hintText: 'Description'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(12),
        child: FilledButton.icon(
          onPressed: () {
            onSaved();
          },
          icon: const Icon(Icons.folder_open),
          label: Text('Save'),
        ),
      ),
    );
  }
}

// --- Screen 5: Folder Detail (notes list) ---
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
    final String folderArg =
        (ModalRoute.of(context)?.settings.arguments as String?) ??
        widget.folderName;
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
                    // Pass the folder name to the editor screen
                    await Navigator.pushNamed(
                      context,
                      NoteEditorScreen.route,
                      arguments: {
                        'folder': folderArg,
                        'note': null,
                      }, // New note
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
                      // Pass the selected note to the editor screen for editing
                      await Navigator.pushNamed(
                        context,
                        NoteEditorScreen.route,
                        arguments: {
                          'folder': folderArg,
                          'note': n,
                        }, // Edit existing note
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
