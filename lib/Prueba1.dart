import 'package:flutter/material.dart';

// Asegúrate de importar correctamente tus funciones de encriptación
import 'package:postgre_flutter/Encriptacion.dart';

void main() {
  runApp(WindowsGestion());
}

class WindowsGestion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WindowsHomePage(),
    );
  }
}

class WindowsHomePage extends StatefulWidget {
  @override
  _WindowsHomePageState createState() => _WindowsHomePageState();
}

class _WindowsHomePageState extends State<WindowsHomePage> {
  @override
  void initState() {
    super.initState();
    encriptarYDesencriptar();
  }

  void encriptarYDesencriptar() {
    // Definir cinco variables de tipo String
    String palabra1 = 'Bueno';
    String palabra2 = 'Malo';
    String palabra3 = 'Empresa en observacion';
    String palabra4 = 'No';
    String palabra5 = '';

    // Encriptar las palabras
    String encriptada1 = AESCrypt.encriptar(palabra1);
    String encriptada2 = AESCrypt.encriptar(palabra2);
    String encriptada3 = AESCrypt.encriptar(palabra3);
    String encriptada4 = AESCrypt.encriptar(palabra4);
    String encriptada5 = AESCrypt.encriptar(palabra5);

    // Desencriptar las palabras encriptadas
    String desencriptada1 = AESCrypt.desencriptar(encriptada1);
    String desencriptada2 = AESCrypt.desencriptar(encriptada2);
    String desencriptada3 = AESCrypt.desencriptar(encriptada3);
    String desencriptada4 = AESCrypt.desencriptar(encriptada4);
    String desencriptada5 = AESCrypt.desencriptar(encriptada5);

    // Imprimir las palabras encriptadas y desencriptadas
    print('Palabra 1 encriptada: $encriptada1, desencriptada: $desencriptada1');
    print('Palabra 2 encriptada: $encriptada2, desencriptada: $desencriptada2');
    print('Palabra 3 encriptada: $encriptada3, desencriptada: $desencriptada3');
    print('Palabra 4 encriptada: $encriptada4, desencriptada: $desencriptada4');
    print('Palabra 5 encriptada: $encriptada5, desencriptada: $desencriptada5');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreenAccent[700],
        title: Text(
          'Flutter y PostgreSQL, Windows',
          style: TextStyle(color: Colors.indigo[900]),
        ),
      ),
      body: Container(
        color: Colors.indigo[900],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Datos insertados correctamente', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
