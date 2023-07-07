import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:postgre_flutter/para_app/main_app.dart';
import 'package:postgre_flutter/para_web/main_web.dart';
import 'package:postgre_flutter/para_windows/main_windows.dart';
import 'package:desktop_window/desktop_window.dart';

void main() {
  if (isWindows()) {
    WidgetsFlutterBinding.ensureInitialized();
    configureWindow(); // Configurar las propiedades de la ventana

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

void configureWindow() {
  // Obtener el tamaño de la pantalla
  final screenSize = WidgetsBinding.instance!.window.physicalSize;

  // Configurar la ventana para cubrir toda la pantalla
  DesktopWindow.setMinWindowSize(screenSize);
  DesktopWindow.setMaxWindowSize(screenSize);
  DesktopWindow.setWindowSize(screenSize);
  DesktopWindow.setFullScreen(true);
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
