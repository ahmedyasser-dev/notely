import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notely2/components/drawer.dart';
import 'package:notely2/components/note_tile.dart';
import 'package:notely2/models/note.dart';
import 'package:notely2/models/note_database.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  //text controller
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    readNotes();
  }

  //create a note
  void createNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Create a note'),
        content: TextField(
          controller: textController,
        ),
        actions: [
          //create button
          MaterialButton(
            onPressed: () {
              //add the note to the db
              context.read<NoteDatabase>().addNote(textController.text);
              //clear text controller
              textController.clear();
              //pop the dialog box
              Navigator.pop(context);
            },
            child: const Text('Create'),
          )
        ],
      ),
    );
  }

  //read a note
  void readNotes() {
    context.read<NoteDatabase>().fetchNotes();
  }

  //update a note
  void updateNote(Note note) {
    textController.text = note.text;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Edit note'),
        content: TextField(
          controller: textController,
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              context
                  .read<NoteDatabase>()
                  .updateNote(note.id, textController.text);
              textController.clear();
              Navigator.pop(context);
            },
            child: const Text('Update'),
          )
        ],
      ),
    );
  }

  //delete a note
  void deleteNote(int id) {
    //delete the note from the db
    context.read<NoteDatabase>().deleteNote(id);
  }

  @override
  Widget build(BuildContext context) {
    //note db access
    final noteDatabase = context.watch<NoteDatabase>();
    //current notes
    List<Note> currentNotes = noteDatabase.currentNotes;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      //app bar
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),

      //drawer
      drawer: MyDrawer(),

      //FAB
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        onPressed: createNote,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //header
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              'Notes',
              style: GoogleFonts.dmSerifText(
                fontSize: 48,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),

          //list of notes
          currentNotes.isEmpty
              ? Expanded(
                  child: Center(
                    child: Text(
                      " You don't have any notes yet!\nTab the + button to create one..",
                      style: TextStyle(
                          fontSize: 17,
                          color: Theme.of(context).colorScheme.inversePrimary),
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: currentNotes.length,
                    itemBuilder: (context, index) {
                      //get the individual note
                      final note = currentNotes[index];

                      //return the tile UI
                      return NoteTile(
                        text: note.text,
                        onEditPressed: () => updateNote(note),
                        onDeletePressed: () => deleteNote(note.id),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
