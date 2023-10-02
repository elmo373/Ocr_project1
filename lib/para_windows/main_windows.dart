import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:postgre_flutter/Encriptacion.dart';
import 'package:postgre_flutter/para_windows/base_de_datos_control.dart';
import 'package:postgre_flutter/para_windows/pestannas/pestannas_Win.dart';


class WindowsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: PaginaPrincipalWindows(),
      ),
    );
  }
}

class PaginaPrincipalWindows extends StatefulWidget {
  @override
  _PaginaPrincipalWindowsState createState() => _PaginaPrincipalWindowsState();
}

class _PaginaPrincipalWindowsState extends State<PaginaPrincipalWindows> {
  String idCi = '';
  String contrasena = '';
  String rol = '';
  String nombre = '';
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

  Future<void> iniciarSesion() async {
    if (idCi != '') {
      String idCiE = AESCrypt.encriptar(idCi);
      final respuesta = await base_de_datos_control.obtenerDatosID("usuarios", idCiE);
      final String estado = await base_de_datos_control.obtenerEstado(idCiE);

      if (respuesta.isNotEmpty) {
        final usuario = respuesta[0];

        if (estado == 'activo' && usuario['Contraseña'] == contrasena) {
          rol = usuario['Rol'];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WindowsPestannas(datos: usuario),
            ),
          );
        } else {
          mostrarErrorInicioSesion();
        }
      } else {
        mostrarErrorInicioSesion();
      }
    }
    setState(() {});
  }

  void mostrarErrorInicioSesion() {
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
                      onChanged: (value) => idCi = value,
                      decoration: InputDecoration(
                        labelText: 'ID de usuario (CI)',
                        labelStyle: TextStyle(fontSize: 22, color: Color.fromRGBO(3, 72, 128, 1), fontWeight: FontWeight.bold),
                      ),
                      style: TextStyle(color: Color.fromRGBO(3, 72, 128, 1)),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      focusNode: miNodoFoco,
                      onChanged: (value) => contrasena = value,
                      obscureText: true,
                      onSubmitted: (value) {
                        iniciarSesion();
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
                  iniciarSesion();
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
