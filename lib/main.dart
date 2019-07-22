import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_note/screens/home.dart';
import 'package:my_note/screens/newNote.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  Brightness brightness;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  brightness =
      (prefs.getBool("isDark") ?? false) ? Brightness.dark : Brightness.light;

  runApp(MyApp(brightness));
}

class MyApp extends StatefulWidget {
  final Brightness brightness;
  MyApp(this.brightness);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new DynamicTheme(
        data: (brightness) => new ThemeData(
              primarySwatch: Colors.indigo,
              brightness: brightness,
              buttonTheme: ButtonThemeData(
                height: 50,
                splashColor: Colors.white60,
                textTheme: ButtonTextTheme.primary,
              ),
            ),
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
            theme: theme,
            debugShowCheckedModeBanner: false,
            home: HomePage(),
            routes: {
              '/home': (context) => HomePage(),
              '/newNotePage': (context) => NewNotePage(),
            },
          );
        });
  }
}
