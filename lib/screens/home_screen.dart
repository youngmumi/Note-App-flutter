import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../note/note_provider.dart';
import '../note/note_model.dart';
import '../note/edit_note_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<Color> colorPalette = [
    Color(0xFFFFD54F),
    Color(0xFFFF8A65),
    Color(0xFFDCEDC8),
    Color(0xFF9575CD),
    Color(0xFF81D4FA),
  ];

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFFF4F6FA),
      body: Row(
        children: [
          Container(
            width: 80,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.add, size: 32),
                  onPressed: () => _showAddNoteDialog(context, noteProvider),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notes',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 24),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 3 / 2,
                      ),
                      itemCount: noteProvider.notes.length,
                      itemBuilder: (context, index) {
                        final note = noteProvider.notes[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: note.color,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: EdgeInsets.all(16),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: Icon(
                                    note.favorite
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.black,
                                  ),
                                  onPressed: () =>
                                      noteProvider.toggleFavorite(note.id),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    note.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4),
                                  Expanded(
                                    child: Text(
                                      note.content,
                                      overflow: TextOverflow.fade,
                                      maxLines: 4,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    note.date,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                      onPressed: () =>
                                          _confirmDelete(context, note.id),
                                    ),
                                    SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                EditNoteScreen(note: note),
                                          ),
                                        );
                                      },
                                      child: Icon(
                                        Icons.edit,
                                        size: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context, NoteProvider noteProvider) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController contentController = TextEditingController();
    final now = DateTime.now();
    final dateString = "${now.month}/${now.day}/${now.year}";
    final uuid = Uuid();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('New Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(hintText: 'Note Title'),
            ),
            TextField(
              controller: contentController,
              decoration: InputDecoration(hintText: 'Note Content'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.trim().isNotEmpty) {
                final colorIndex =
                    noteProvider.notes.length % colorPalette.length;
                noteProvider.addNote(
                  Note(
                    id: uuid.v4(),
                    title: titleController.text.trim(),
                    content: contentController.text.trim(),
                    date: dateString,
                    color: colorPalette[colorIndex],
                  ),
                );
              }
              Navigator.pop(context);
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, String noteId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Note"),
        content: Text("Are you sure you want to delete this note?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              context.read<NoteProvider>().deleteNote(noteId);
              Navigator.pop(context);
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
