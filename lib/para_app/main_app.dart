import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:postgre_flutter/Encriptacion.dart';
import 'package:postgre_flutter/para_app/api_controlMobile.dart';
import 'package:postgre_flutter/para_app/pantallas/tipo_de_documento.dart';


class MobileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]); // Cambiado a orientación vertical
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
    if (id_ci != '') {
      String id_ciE = AESCrypt.encriptar(id_ci);

      final response = await api_control.obtenerDatosId("usuarios", id_ciE);

      final String estado = await api_control.obtenerEstado(id_ciE);

      if (response.isNotEmpty) {
        final usuario = response[0];

        if (usuario['Rol'] != 'Empresa' && estado == 'activo' && usuario['Contraseña'] == contrasenna) {

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => tipo_de_documento(datos: usuario),

            ),
          );
        } else {
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

    }
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    double tamano_logo = 90;
    double tamano_ciculo = tamano_logo * sqrt(2);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 90,
        title: SizedBox(
          height: 90,
          child: Image.asset(
            'lib/imagenes/minlogo.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
      body: Container(
        color: Color.fromRGBO(3, 72, 128, 1),
        child: SingleChildScrollView( // Añadido para permitir desplazamiento
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Visibility(
                  visible: !(MediaQuery.of(context).viewInsets.bottom > 0),
                  child:
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
                ),
                SizedBox(height: 5),
                Visibility(
                  visible: !(MediaQuery.of(context).viewInsets.bottom > 0),
                  child: Text(
                    'Sistema de Digitalización del Registro para el manejo de explosivos',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 5),
                Visibility(
                  visible: !(MediaQuery.of(context).viewInsets.bottom > 0),
                  child: Text(
                    'SIDIO',
                    style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Ingrese sus credenciales',
                  style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: Column(
                    children: [
                      TextField(
                        onChanged: (value) => id_ci = value,  // Especificando que es solo para números, asumiendo que CI es un número.
                        decoration: InputDecoration(
                          labelText: 'ID de usuario (CI)',
                          labelStyle: TextStyle(color: Color.fromRGBO(3, 72, 128, 1), fontWeight: FontWeight.bold),
                        ),
                        style: TextStyle(color: Color.fromRGBO(3, 72, 128, 1)),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        onChanged: (value) => contrasenna = value,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          labelStyle: TextStyle(color: Color.fromRGBO(3, 72, 128, 1), fontWeight: FontWeight.bold),
                        ),
                        style: TextStyle(color: Color.fromRGBO(3, 72, 128, 1)),
                      ),
                    ],
                  ),

                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    login();
                  },
                  child: Text('Iniciar sesión'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Color.fromRGBO(3, 72, 128, 1),
                  ),
                ),
                SizedBox(height: 300),
              ],
            ),
        ),
      ),
    );
  }
}
