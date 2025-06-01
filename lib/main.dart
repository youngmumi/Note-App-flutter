import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'note/note_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyNoteApp());
}

class MyNoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NoteProvider(),
      child: MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen()),
    );
  }
}
