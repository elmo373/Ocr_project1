import 'package:flutter/material.dart';
import 'package:postgre_flutter/Encriptacion.dart';
import 'package:postgre_flutter/para_windows/base_de_datos_control.dart';
import 'package:postgre_flutter/para_windows/pestannas/pestannas.dart';

class WindowsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false, // Evita redimensionamiento al aparecer el teclado
        body: WindowsHomePage(),
      ),
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
    if (id_ci != null) {
      String id_ciE = AESCrypt.encrypt(id_ci);
      final response = await base_de_datos_control.obtenerDatosID("usuarios", id_ciE);

      if (response.isNotEmpty) {
        final usuario = response[0];
        if (usuario['Contraseña'] == contrasenna) {
          rol = usuario['Rol'];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WindowsPestannas(),
            ),
          );
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
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        color: Color.fromRGBO(3, 72, 128, 1), // Fondo azul marino
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Ingrese sus credenciales',
                style: TextStyle(fontSize: 20, color: Colors.white), // Letras blancas
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  onChanged: (value) => id_ci = value,
                  decoration: InputDecoration(
                    labelText: 'ID de usuario (CI)',
                    labelStyle: TextStyle(color: Colors.white), // Letras blancas
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Línea blanca
                    ),
                  ),
                  style: TextStyle(color: Colors.white), // Letras blancas
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
                    labelStyle: TextStyle(color: Colors.white), // Letras blancas
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Línea blanca
                    ),
                  ),
                  style: TextStyle(color: Colors.white), // Letras blancas
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  login();
                },
                child: Text('Iniciar sesión'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white, // Fondo blanco
                  onPrimary: Color.fromRGBO(3, 72, 128, 1), // Texto azul marino
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

}
