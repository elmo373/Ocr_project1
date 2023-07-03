import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(WebApp());
}

class WebApp extends StatelessWidget {
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
  String id_ci = '';
  String contrasenna = '';
  String rol = '';
  String nombre = '';

  Future<void> login() async {
    final url = 'http://localhost:3000/query/usuarios';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData.isNotEmpty) {
        final usuario = jsonData[0];
        if (usuario['contrasenna'] == contrasenna) {
          rol = usuario['rol'];
          nombre = usuario['nombre'];
        } else {
          // Contraseña incorrecta, se muestra un mensaje de error
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error de inicio de sesión'),
              content: Text('Los datos proporcionados son incorrectos.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Aceptar'),
                ),
              ],
            ),
          );
        }
      } else {
        // Usuario no encontrado, se muestra un mensaje de error
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error de inicio de sesión'),
            content: Text('El ID de usuario proporcionado no existe.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Aceptar'),
              ),
            ],
          ),
        );
      }
    } else {
      print('Error en la solicitud HTTP: ${response.statusCode}');
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreenAccent[700], // Fondo verde
        title: Text(
          'Flutter y PostgreSQL, Windows',
          style: TextStyle(color: Colors.indigo[900]), // Letras blancas
        ),
      ),
      body: Container(
        color: Colors.indigo[900], // Fondo azul marino
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Ingrese sus credenciales',
                style: TextStyle(fontSize: 20, color: Colors.lightGreenAccent[700]), // Letras blancas
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  onChanged: (value) => id_ci = value,
                  decoration: InputDecoration(
                    labelText: 'ID de usuario (CI)',
                    labelStyle: TextStyle(color: Colors.lightGreenAccent[700]), // Letras blancas
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightGreenAccent.shade400), // Línea blanca
                    ),
                  ),
                  style: TextStyle(color: Colors.lightGreenAccent[700]), // Letras blancas
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  onChanged: (value) => contrasenna = value,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    labelStyle: TextStyle(color: Colors.lightGreenAccent[700]), // Letras blancas
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightGreenAccent.shade400), // Línea blanca
                    ),
                  ),
                  style: TextStyle(color: Colors.lightGreenAccent[700]), // Letras blancas
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: login,
                child: Text('Iniciar sesión'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.lightGreenAccent[700], // Fondo blanco
                  onPrimary: Colors.indigo[900], // Texto azul marino
                ),
              ),
              SizedBox(height: 20),
              if (rol.isNotEmpty) ...[
                Text(
                  'Bienvenido, $nombre',
                  style: TextStyle(fontSize: 18, color: Colors.lightGreenAccent[700]), // Letras blancas
                ),
                SizedBox(height: 10),
                Text(
                  'Rol: $rol',
                  style: TextStyle(fontSize: 18, color: Colors.lightGreenAccent[700]), // Letras blancas
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
