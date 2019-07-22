import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:date_format/date_format.dart';

import '../screens/newNote.dart';
import '../components/noteItem.dart';
import '../services/database.dart';
import '../components/customTitle.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
                        setState(() {
                          _scaffoldKey = _scaffoldKey;
                        });
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
                      setState(() {
                        _scaffoldKey = _scaffoldKey;
                      });
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
      key: _scaffoldKey,
      appBar: PreferredSize(
        child: AppBar(
          backgroundColor: Theme.of(context).canvasColor,
          elevation: 0.0,
          brightness: Theme.of(context).brightness == Brightness.light
              ? Brightness.light
              : Brightness.dark,
        ),
        preferredSize: Size.fromHeight(0),
      ),
      body: Stack(children: <Widget>[
        Column(
          children: <Widget>[
            SizedBox(
              height: 60,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 30,
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    child: CustomTitle(changeBrightness),
                    padding: EdgeInsets.only(bottom: 20),
                  ),
                  /*Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 18,
                              ),
                              hintText: "Search",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  width: 1,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 3,
                                ),
                              ),
                              prefixIcon: Padding(
                                child: Icon(Icons.search),
                                padding: EdgeInsets.only(left: 10, right: 10),
                              )),
                        ),
                      ),
                    ],
                  ),*/
                ],
              ),
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
            bottom: 20,
            right: 0,
            child: Container(
              child: RaisedButton(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.tealAccent
                      : Colors.indigo,
                  onPressed: () {
                    Navigator.of(context).pushNamed('/newNotePage');
                  },
                  elevation: 0.0,
                  highlightElevation: 0.0,
                  child: Text("Add Note"),
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  )),
              padding: EdgeInsets.all(30),
            ))
      ]),
    );
  }
}
