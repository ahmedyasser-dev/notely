import 'package:flutter/material.dart';
import 'package:notely2/models/note_database.dart';
import 'package:notely2/pages/notes_page.dart';
import 'package:notely2/theme/theme_provider.dart';
import 'package:provider/provider.dart';

import 'pages/settings_page.dart';

void main() async {
  //initialize note isar db
  WidgetsFlutterBinding.ensureInitialized();
  await NoteDatabase.initialize();
  runApp(
    MultiProvider(
      providers: [
        //note provider
        ChangeNotifierProvider(
          create: (context) => NoteDatabase(),
        ),
        //theme provider
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const NotesPage(),
      routes: {
        '/notespage': (context) => const NotesPage(),
        '/settingspage': (context) => const SettingsPage(),
      },
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
