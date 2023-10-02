import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:postgre_flutter/Encriptacion.dart';
import 'package:postgre_flutter/para_web/api_control.dart';
import 'package:postgre_flutter/para_web/pestannas/pestannas_Web.dart';

void main() {
  runApp(WebApp());
}

class WebApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: WebHomePage(),
      ),
    );
  }
}

class WebHomePage extends StatefulWidget {
  @override
  _WebHomePageState createState() => _WebHomePageState();
}

class _WebHomePageState extends State<WebHomePage> {
  String usuarioId = '';
  String contrasenna = '';
  String role = '';

  late final FocusNode miNodoFoco;

  @override
  void initState() {
    super.initState();
    miNodoFoco = FocusNode();
  }

  @override
  void dispose() {
    miNodoFoco.dispose();
    super.dispose();
  }

  Future<void> loginusuario() async {
    if (usuarioId != '') {
      String encryptedusuarioId = AESCrypt.encriptar(usuarioId);
      final response = await api_control.obtenerDatosId("usuarios", encryptedusuarioId);

      if (response.isNotEmpty) {
        final usuario = response[0];
        if (usuario['Contraseña'] == contrasenna) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WindowsPestannas(datos:usuario),
            ),
          );
        } else {
          _showErrorDialog('Los datos proporcionados son incorrectos.');
        }
      } else {
        _showErrorDialog('El ID de usuario proporcionado no existe.');
      }
    }
    setState(() {});
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error de inicio de sesión'),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double ancho = MediaQuery.of(context).size.width;
    double tamano_logo = 90;
    double tamano_ciculo = tamano_logo * sqrt(2);

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
        color: Color.fromRGBO(3, 72, 128, 1),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            // Cambios realizados aquí:
            children: [
              Stack(
                alignment: Alignment.center, // Asegura que la imagen esté centrada en el Stack
                children: [
                  Container(
                    height: tamano_ciculo, // 2 * 85
                    width: tamano_ciculo, // 2 * 85
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: tamano_logo,
                    child: Image.asset(
                      'lib/imagenes/Logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
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
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 60, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Text(
                'Ingrese sus credenciales',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),

              Container(
                width: ancho * 0.6,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    TextField(
                      onChanged: (value) => usuarioId = value,
                      decoration: InputDecoration(
                        labelText: 'ID de usuario (CI)',
                        labelStyle: TextStyle(fontSize: 22, color: Color.fromRGBO(3, 72, 128, 1), fontWeight: FontWeight.bold),
                      ),
                      style: TextStyle(color: Color.fromRGBO(3, 72, 128, 1)),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      focusNode: miNodoFoco,
                      onChanged: (value) => contrasenna = value,
                      obscureText: true,
                      onSubmitted: (value) {
                        loginusuario();
                      },
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        labelStyle: TextStyle(fontSize: 22, color: Color.fromRGBO(3, 72, 128, 1), fontWeight: FontWeight.bold),
                      ),
                      style: TextStyle(color: Color.fromRGBO(3, 72, 128, 1)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  loginusuario();
                },
                child: Text(
                  'Iniciar sesión',
                  style: TextStyle(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Color.fromRGBO(3, 72, 128, 1),
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
