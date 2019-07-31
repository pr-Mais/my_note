import 'package:flutter/material.dart';

class NoteItem extends StatelessWidget {
  final String title;
  final String content;
  final String date;
  final String time;
  final Function onTap;
  final Function onLongPress;
  const NoteItem(
      {this.content,
      this.title,
      this.date,
      this.onTap,
      this.onLongPress,
      this.time});

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = new TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 20,
        fontWeight: FontWeight.bold);
    TextStyle contentStyle = new TextStyle(
      color: Colors.black54,
      fontSize: 16,
    );
    TextStyle dateTimeStyle = new TextStyle(
      color: Colors.black54,
      fontSize: 12,
    );
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              new BoxShadow(
                color: Colors.grey[350],
                blurRadius: 5.0,
              ),
            ]),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  child:  Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: titleStyle,
                    ),
                  
                ),
                Flexible(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.black,
                      ),
                      Text(
                        " " + date + " at " + time,
                        overflow: TextOverflow.ellipsis,
                        style: dateTimeStyle,
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.end,
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            Row(
              children: <Widget>[
                Flexible(
                  child: Text(
                      content,
                      overflow: TextOverflow.ellipsis,
                      style: contentStyle,
                    ),
                  
                )
              ],
            )
          ],
        ),
      ),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}
