import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:postgre_flutter/Encriptacion.dart';
import 'package:postgre_flutter/para_app/api_controlMobile.dart';
import 'package:postgre_flutter/para_app/pantallas/tipo_de_documento.dart';


class MobileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

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
      String id_ciE = AESCrypt.encrypt(id_ci);
      final response = await api_control.obtenerDatosId("usuarios", id_ciE);
      final String estado = await api_control.obtenerEstado(id_ciE);

      // Suponemos que tienes estado y rol disponibles en tu código.

      if (response.isNotEmpty) {
        final usuario = response[0];

        if (usuario['Rol'] != 'Empresa' && estado == 'activo' && usuario['Contraseña'] == contrasenna) {
          rol = usuario['Rol'];
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

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
                      onChanged: (value) => id_ci = value,
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
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

}
