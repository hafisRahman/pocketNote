import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocket_note/model/notes_database.dart';
import 'package:pocket_note/screens/Notes_edit.dart';
import 'package:pocket_note/widgets/all_notelist.dart';

const c1 = 0xFFFDFFFC,
    c2 = 0xFFFF595E,
    c3 = 0xFF374B4A,
    c4 = 0xFF00B1CC,
    c5 = 0xFFFFD65C,
    c6 = 0xFFB9CACA,
    c7 = 0x80374B4A,
    c8 = 0x3300B1CC,
    c9 = 0xCCFF595E;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<Map<String, dynamic>>> readDatabase() async {
    try {
      NotesDatabase notesDb = NotesDatabase();
      await notesDb.initDatabase();
      List<Map> notesList = await notesDb.getAllNotes();
      await notesDb.closeDatabase();

      List<Map<String, dynamic>> notesData =
          List<Map<String, dynamic>>.from(notesList);
          
      notesData.sort((a, b) => (a['title']).compareTo(b['title']));
      return notesData;
    } catch (e) {
      print('Error retrieving notes');
      return [{}];
    }
  }

  late List<Map<String, dynamic>> notesData;
  List<int> selectedNoteIds = [];

// Render the screen and update changes
  void afterNavigatorPop() {
    setState(() {});
  }

// Long Press handler to display bottom bar
  void handleNoteListLongPress(int id) {
    setState(() {
      if (selectedNoteIds.contains(id) == false) {
        selectedNoteIds.add(id);
      }
    });
  }

// Remove selection after long press
  void handleNoteListTapAfterSelect(int id) {
    setState(() {
      if (selectedNoteIds.contains(id) == true) {
        selectedNoteIds.remove(id);
      }
    });
  }

// Delete Note/Notes
  void handleDelete() async {
    try {
      NotesDatabase notesDb = NotesDatabase();
      await notesDb.initDatabase();
      for (int id in selectedNoteIds) {
        int result = await notesDb.deleteNote(id);
      }
      await notesDb.closeDatabase();
    } finally {
      setState(() {
        selectedNoteIds = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Super Note",
      home: Scaffold(
        backgroundColor: const Color(c1),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(c2),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          title: const Text(
            'Super Note',
            style: TextStyle(
              color: Color(c5),
            ),
          ),
          actions: [
            (selectedNoteIds.isNotEmpty
                ? IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Color(c1),
                    ),
                    tooltip: 'Delete',
                    onPressed: () => handleDelete(),
                  )
                : Container()),
          ],
        ),

        //Floating Button
        floatingActionButton: FloatingActionButton(
          tooltip: 'New Notes',
          backgroundColor: const Color(c4),
          onPressed: () => {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotesEdit(['new', {}]))),
          },
          child: const Icon(
            Icons.add,
            color: Color(c5),
          ),
        ),
        body: homeBody(),
      ),
    );
  }

  FutureBuilder<List<Map<String, dynamic>>> homeBody() {

    return FutureBuilder(
        future: readDatabase(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // notesData = snapshot.data!;
            return Stack(
              children: <Widget>[
                // Display Notes
                AllNoteLists(
                  snapshot.data,
                  selectedNoteIds,
                  afterNavigatorPop,
                  handleNoteListLongPress,
                  handleNoteListTapAfterSelect,
                ),
              ],
            );
          } else if (snapshot.hasError) {
            print('Error reading database');
          } else {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Color(c3),
              ),
            );
          }
          return const CircularProgressIndicator();
        });
  }
}

