import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:date_format/date_format.dart';
import '../screens/newNote.dart';
import '../components/noteItem.dart';
import '../services/database.dart';
import '../components/customAppBar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  changeBrightness() {
    DynamicTheme.of(context).setBrightness(
        Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark);
  }

  @override
  void initState() {
    super.initState();
    NotesDatabaseService().init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showModalSheet(note) {
    Platform.isAndroid
        ? showModalBottomSheet(
            context: context,
            builder: ((BuildContext context) {
              return Container(
                child: Wrap(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "Delete",
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: () {
                        NotesDatabaseService().deleteNoteInDB(note);
                        setState(() {});
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      title: Text("Cancel"),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              );
            }))
        : showCupertinoModalPopup(
            context: context,
            builder: ((BuildContext context) {
              return CupertinoActionSheet(
                actions: <Widget>[
                  CupertinoActionSheetAction(
                    child: Text("Delete"),
                    onPressed: () {
                      NotesDatabaseService().deleteNoteInDB(note);
                      setState(() {});
                      Navigator.of(context).pop();
                    },
                    isDestructiveAction: true,
                  ),
                ],
                cancelButton: CupertinoActionSheetAction(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              );
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                left: 30,
                right: 30,
                top: MediaQuery.of(context).size.height * 0.12,
                bottom: 20
              ),
              child:  CustomAppBar(changeBrightness),
            ),
            Expanded(
                child: StreamBuilder(
              stream: NotesDatabaseService().getAll(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.length > 0) {
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        String date = snapshot.data[index].date;
                        DateTime dateTime = DateTime.parse(date);
                        String formattedDate =
                            formatDate(dateTime, [d, ' ', M, ' ', yy]);
                        String formattedTime =
                            formatDate(dateTime, [HH, ':', nn]);
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 30),
                          child: NoteItem(
                            title: snapshot.data[index].title,
                            content: snapshot.data[index].content,
                            date: formattedDate,
                            time: formattedTime,
                            onLongPress: () {
                              _showModalSheet(snapshot.data[index]);
                            },
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => NewNotePage(
                                        isNew: false,
                                        oldNote: snapshot.data[index],
                                      )));
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        "Woops, there are no notes :(",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    );
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )),
          ],
        ),
        Positioned(
          bottom: 30,
          right: 30,
          child: RaisedButton(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.tealAccent
                  : Colors.indigo,
              onPressed: () {
                Navigator.of(context).pushNamed('/newNotePage');
              },
              elevation: 0.0,
              highlightElevation: 0.0,
              child: Text("New Note"),
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
              )),
        )
      ]),
    );
  }
}
