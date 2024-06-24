import 'package:flutter/material.dart';
import 'package:pocket_note/constants.dart';
import 'package:pocket_note/model/note.dart';
import 'package:pocket_note/model/notes_database.dart';
import 'package:pocket_note/theme/note_colors.dart';
import 'package:pocket_note/widgets/color_pallette.dart';
import 'package:pocket_note/widgets/note_entry.dart';
import 'package:pocket_note/widgets/note_title_entry.dart';


// const c1 = 0xFFFDFFFC, c2 = 0xFFFF595E, c3 = 0xFF374B4A, c4 = 0xFF00B1CC, c5 = 0xFFFFD65C, c6 = 0xFFB9CACA,
//             c7 = 0x80374B4A;

class NotesEdit extends StatefulWidget {
  final args;

  const NotesEdit(this.args, {super.key});

  @override
  State<NotesEdit> createState() => _NotesEditState();
}

class _NotesEditState extends State<NotesEdit> {
  String noteTitle = '';
  String noteContent = '';
  String noteColor = 'red';

  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _contentTextController = TextEditingController();

  void handleTitleTextChange() {
    setState(() {
      noteTitle = _titleTextController.text.trim();
    });
  }

  void handleNoteTextChange() {
    setState(() {
      noteContent = _contentTextController.text.trim();
    });
  }

  void handleColor(currentContext) {
    showDialog(
      context: currentContext,
      builder: (context) => ColorPalette(
        parentContext: currentContext,
      ),
    ).then((colorName) {
      if (colorName != null) {
        setState(() {
          noteColor = colorName;
        });
      }
    });
  }

  void handleBackButton() async {
    if (noteTitle.isEmpty) {
      // Go Back without saving
      if (noteContent.isEmpty) {
        Navigator.pop(context);
        return;
      } else {
        String title = noteContent.split('\n')[0];
        if (title.length > 31) {
          title = title.substring(0, 31);
        }
        setState(() {
          noteTitle = title;
        });
      }
    }

    // Save New note
    if (widget.args[0] == 'new') {
      Note noteObj =
          Note(title: noteTitle, content: noteContent, noteColor: noteColor);
      try {
        await _insertNote(noteObj);
      } catch (e) {
        print(e);
      } finally {
        Navigator.pop(context);
        return;
      }
    }

    // Update Note
    else if (widget.args[0] == 'update') {
      Note noteObj = Note(
          id: widget.args[1]['id'],
          title: noteTitle,
          content: noteContent,
          noteColor: noteColor);
      try {
        await _updateNote(noteObj);
      } finally {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        // ignore: control_flow_in_finally
        return;
      }
    }
  }

  Future<int> _insertNote(Note note) async {
    NotesDatabase notesDb = NotesDatabase();
    await notesDb.initDatabase();
    int result = await notesDb.insertNote(note);
    print("Insertion result...............,$result");
    await notesDb.closeDatabase();
    return result;
  }

  Future<int> _updateNote(Note note) async {
    NotesDatabase notesDb = NotesDatabase();
    await notesDb.initDatabase();
    int result = await notesDb.updateNote(note);
    await notesDb.closeDatabase();
    return result;
  }

  @override
  void initState() {
    super.initState();

    noteTitle = (widget.args[0] == 'new' ? '' : widget.args[1]['title']);
    noteContent = (widget.args[0] == 'new' ? '' : widget.args[1]['content']);
    noteColor = (widget.args[0] == 'new' ? 'red' : widget.args[1]['noteColor']);

    _titleTextController.text =
        (widget.args[0] == 'new' ? '' : widget.args[1]['title']);
    _contentTextController.text =
        (widget.args[0] == 'new' ? '' : widget.args[1]['content']);

    _titleTextController.addListener(handleTitleTextChange);
    _contentTextController.addListener(handleNoteTextChange);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _titleTextController.dispose();
    _contentTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(NoteColors[noteColor]!['l']!),
      appBar: AppBar(
        backgroundColor: Color(NoteColors[noteColor]!['b']!),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 8, 8, 8),
          ),
          tooltip: 'Back',
          onPressed: () => {
            handleBackButton(),
          },
        ),
        title: NoteTitleEntry(_titleTextController),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.color_lens,
              color: Color(c1),
            ),
            tooltip: 'Color Palette',
            onPressed: () => handleColor(context),
          ),
        ],
      ),
      body: NoteEntry(_contentTextController),
    );
  }
}
