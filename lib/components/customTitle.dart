import 'package:flutter/material.dart';

class CustomTitle extends StatelessWidget {
  final Function onPressed;
  CustomTitle(this.onPressed);
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "My Notes",
              style: TextStyle(
                color: (Theme.of(context).brightness == Brightness.light)
                    ? Colors.black54
                    : Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
                fontFamily: "Playfair"
              ),
            ),
            IconButton(
              icon: Icon(Icons.lightbulb_outline),
              tooltip: "Dark/Light mode",
              onPressed: onPressed,
            )
          ],
        ));
  }
}
