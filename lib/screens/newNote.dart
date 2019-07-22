import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notesModel.dart';
import '../services/database.dart';

class NewNotePage extends StatefulWidget {
  final bool isNew;
  final Note oldNote;
  NewNotePage({
    Key key,
    this.isNew = true,
    this.oldNote,
  });

  _NewNotePageState createState() => _NewNotePageState();
}

class _NewNotePageState extends State<NewNotePage> {
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _contentController = new TextEditingController();
  String title;
  String content;
  Note currentNote;
  Note oldNote;
  bool isNew;

  @override
  void initState() {
    super.initState();
    isNew = widget.isNew;

    if (isNew == false) {
      oldNote = widget.oldNote;
      _titleController.text = oldNote.title;
      _contentController.text = oldNote.content;
    }
  }

  handleSave() async {
    if (isNew) {
      currentNote = new Note(
        content: _contentController.text,
        title: _titleController.text,
        date: DateTime.now().toString(),
        isImportant: 0,
      );
      NotesDatabaseService().addNoteInDB(currentNote);
      Navigator.of(context).pop();
    } else {
      oldNote.content = _contentController.text;
      oldNote.title = _titleController.text;
      NotesDatabaseService().updateNoteInDB(oldNote);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          brightness: Theme.of(context).brightness == Brightness.light
              ? Brightness.light
              : Brightness.dark,
          elevation: 0.0,
          iconTheme: IconThemeData(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.indigo),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              tooltip: "Delete",
              onPressed: () {
                if (isNew) {
                  Navigator.of(context).pop();
                } else {
                  NotesDatabaseService().deleteNoteInDB(oldNote);
                  Navigator.of(context).pop();
                }
              },
            ),
            Padding(
              child: RaisedButton(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.tealAccent
                      : Colors.indigo,
                  elevation: 0.0,
                  highlightElevation: 0.0,
                  onPressed: handleSave,
                  child: isNew ? Text("Add Note") : Text("Update Note"),
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30)),
                  )),
              padding: EdgeInsets.only(
                top: 8,
                bottom: 8,
              ),
            )
          ],
        ),
        body: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                Container(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _titleController,
                    autofocus: true,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                    decoration: InputDecoration.collapsed(
                      hintText: isNew ? 'Title' : '',
                      hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 32,
                          fontWeight: FontWeight.w700),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _contentController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 10,
                    onChanged: (input) {},
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    decoration: InputDecoration.collapsed(
                      hintText: isNew ? 'Start typing...' : '',
                      hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                      border: InputBorder.none,
                    ),
                  ),
                )
              ],
            ),
          ],
        ));
  }
}
