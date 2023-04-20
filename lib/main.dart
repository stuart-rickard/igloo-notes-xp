import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'igloo notes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'igloo notes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// move a text container
// color a text container

class _MyHomePageState extends State<MyHomePage> {
  final myController = TextEditingController();

  List<String> _notes = [];
  String _currentNote = '';
  int _currentNoteIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notes = (prefs.getStringList('notes') ?? ['john', 'paul', 'george', 'ringo']);
    });
    debugPrint('load $_currentNote');
  }

  Future<void> _saveCurrentNote() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentNote = myController.text;
      _notes.add(_currentNote);
      prefs.setStringList('notes', _notes);
      debugPrint('save $_notes');
      myController.text = '';
      _currentNoteIndex = -1;
    });
  }

  Future<void> _reviseNote() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_currentNoteIndex == -1) return;
      _currentNote = myController.text;
      _notes[_currentNoteIndex] = _currentNote;
      prefs.setStringList('notes', _notes);
      debugPrint('revise $_notes');
      myController.text = '';
      _currentNoteIndex = -1;
    });
  }

  Future<void> _deleteNote() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_currentNoteIndex == -1) return;
      _notes.removeAt(_currentNoteIndex);
      prefs.setStringList('notes', _notes);
      debugPrint('delete $_notes');
      myController.text = '';
      _currentNoteIndex = -1;
    });
  }

  Future<void> _selectNote(i) async {
    setState(() {
      myController.text = _notes[i];
      _currentNoteIndex = i;
      debugPrint('$i');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Align(
        child: Container(
          constraints: BoxConstraints(maxWidth: 450),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                color: const Color.fromARGB(255, 152, 172, 195),
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                child: EditableText(
                  controller: myController,
                  focusNode: FocusNode(),
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                  cursorColor: Colors.black,
                  backgroundCursorColor: Colors.grey,
                  maxLines: null,
                  // selectionControls: TextSelectionControls(),
                ),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _saveCurrentNote();
                    },
                    child: const Text('Save New Note'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _reviseNote();
                    },
                    child: const Text('Revise Note'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _deleteNote();
                    },
                    child: const Text('Delete Note'),
                  ),
                ],
              ),
              for (var i = 0; i < _notes.length; i++)
                Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 195, 222, 252),
                    border: Border.all(
                      color:
                          i == _currentNoteIndex ? Colors.black : Colors.white,
                      width: 1,
                    ),
                  ),
                  // padding: const EdgeInsets.all(10),
                  child: TextButton(
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(_notes[i],
                            style: const TextStyle(
                                fontSize: 15, color: Colors.deepOrange))),
                    onPressed: () {
                      _selectNote(i);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
