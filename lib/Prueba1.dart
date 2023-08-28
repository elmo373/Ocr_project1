import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
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
    fillTable();
  }

  void fillTable() async {
    final connection = PostgreSQLConnection(
      '35.225.248.224',
      5432,
      'ocrdb',
      username: 'emanuel',
      password: 'emi77',
    );

    try {
      await connection.open();

      List<Map<String, dynamic>> datosRegistro = [
        {
          'id_doc': AESCrypt.encriptar('68400051029374658'),
          'id_registro': AESCrypt.encriptar('6840005'),
          'id_usuario': AESCrypt.encriptar('1029374658'),
          'nombre_empresa': AESCrypt.encriptar('Explosivos para Minas Seguras S.A.'),
          'nombre_propietario': AESCrypt.encriptar('Fabio Raul Suarez Guzmán'),
          'representante_legal': AESCrypt.encriptar('Fabio Raul Suarez Guzmán'),
          'cumple': AESCrypt.encriptar('No'),
          'ubicacion_deposito': AESCrypt.encriptar('Oruro,Pantaleón Dalence,Huanuni'),
          'fecha_de_emision': AESCrypt.encriptar('2023-06-11'),
          'pdf': AESCrypt.encriptar('https://firebasestorage.googleapis.com/v0/b/appprueba-16698.appspot.com/o/2023-08-04%2010%3A16%3A24.pdf?alt=media&token=6ba70a28-14af-4200-8085-87536ac22cc4'),
        },

      ];

      for (var dato in datosRegistro) {
        await connection.query(
          "INSERT INTO documento_de_inspeccion (id_doc, id_registro, id_usuario, nombre_empresa, nombre_propietario, representante_legal, cumple, ubicacion_deposito, fecha_de_emision, pdf) VALUES ('${dato['id_doc']}', '${dato['id_registro']}', '${dato['id_usuario']}', '${dato['nombre_empresa']}', '${dato['nombre_propietario']}', '${dato['representante_legal']}', '${dato['cumple']}', '${dato['ubicacion_deposito']}', '${dato['fecha_de_emision']}', '${dato['pdf']}')",
        );
      }

      print('Datos insertados correctamente');
    } catch (e) {
      print('Error en la conexión a PostgreSQL: $e');
    } finally {
      await connection.close();
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
