import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:postgre_flutter/para_app/main_app.dart';
import 'package:postgre_flutter/para_web/main_web.dart';
import 'package:postgre_flutter/para_windows/main_windows.dart';

void main() {
  runApp(MyApp());
}

bool isWindows() {
  return !kIsWeb && Platform.isWindows;
}

bool isMobile() {
  return !kIsWeb && (Platform.isAndroid || Platform.isIOS);
}

bool isWeb() {
  return kIsWeb;
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      if (isWindows()) {
        runApp(WindowsApp());
      } else if (isMobile()) {
        runApp(MobileApp());
      } else if (isWeb()) {
        runApp(WebApp());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 90,
          title: SizedBox(
            width: 300,
            height: 90,
            child: Image.asset(
              'lib/imagenes/minlogo.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        body: Container(
          color: Color.fromRGBO(3, 72, 128, 1),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Bienvenido',
                  style: TextStyle(fontSize: 45, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Sistema de Digitalización del Registro para el manejo de explosivos',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 35, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'SIDIO',
                  style: TextStyle(fontSize: 60, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
