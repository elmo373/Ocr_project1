import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:postgre_flutter/para_app/main_app.dart';
import 'package:postgre_flutter/para_web/main_web.dart';
import 'package:postgre_flutter/para_windows/main_windows.dart';

void main() {
  if (isWindows()) {
    // Configurar las propiedades de la ventana

    runApp(WindowsApp());
  } else if (isMobile()) {
    runApp(MobileApp());
  } else if (isWeb()) {
    runApp(WebApp());
  }
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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (isWindows()) {
      return WindowsApp();
    } else if (isMobile()) {
      return MobileApp();
    } else if (isWeb()) {
      return WebApp();
    } else {
      return Container();
    }
  }
}
