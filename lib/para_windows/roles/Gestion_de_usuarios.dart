import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:postgre_flutter/Encriptacion.dart';
import 'package:intl/intl.dart';

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
  String id_ci = '';
  String contrasenna = '';
  String rol = '';
  String nombre = '';
  String nombreEncriptado = '';
  String nombreDesencriptado = '';

  @override
  void initState() {
    super.initState();
    fillTable();
  }

  void fillTable() async {
    final connection = PostgreSQLConnection(
      'localhost',  // Reemplaza con la IP de tu instancia GCP
      5432,
      'ocrdb',
      username: 'emanuel',
      password: 'Emi77',
    );


    try {
      await connection.open();

      List<Map<String, dynamic>> datos = [
        {
          'id_ci': AESCrypt.encriptar('1234567890'),
          'nombre': AESCrypt.encriptar('Juan Pérez'),
          'contrasenna': AESCrypt.encriptar('abc123'),
          'correo_electronico': AESCrypt.encriptar('juanperez@example.com'),
          'rol': AESCrypt.encriptar('administrador'),
          'numero_de_telefono': AESCrypt.encriptar('555-1234'),
        },
        {
          'id_ci': AESCrypt.encriptar('9876543210'),
          'nombre': AESCrypt.encriptar('María López'),
          'contrasenna': AESCrypt.encriptar('pass123'),
          'correo_electronico': AESCrypt.encriptar('marialopez@example.com'),
          'rol': AESCrypt.encriptar('personal_regular'),
          'numero_de_telefono': AESCrypt.encriptar('555-5678'),
        },
        {
          'id_ci': AESCrypt.encriptar('5678901234'),
          'nombre': AESCrypt.encriptar('Pedro Gómez'),
          'contrasenna': AESCrypt.encriptar('password'),
          'correo_electronico': AESCrypt.encriptar('pedrogomez@example.com'),
          'rol': AESCrypt.encriptar('tecnico'),
          'numero_de_telefono': AESCrypt.encriptar('555-9012'),
        },
        {
          'id_ci': AESCrypt.encriptar('0123456789'),
          'nombre': AESCrypt.encriptar('Luisa Torres'),
          'contrasenna': AESCrypt.encriptar('qwerty'),
          'correo_electronico': AESCrypt.encriptar('luisatorres@example.com'),
          'rol': AESCrypt.encriptar('interesado_en_el_registro'),
          'numero_de_telefono': AESCrypt.encriptar('555-3456'),
        },
        {
          'id_ci': AESCrypt.encriptar('2468135790'),
          'nombre': AESCrypt.encriptar('Laura Sánchez'),
          'contrasenna': AESCrypt.encriptar('laura123'),
          'correo_electronico': AESCrypt.encriptar('laurasanchez@example.com'),
          'rol': AESCrypt.encriptar('administrador'),
          'numero_de_telefono': AESCrypt.encriptar('555-6789'),
        },
        {
          'id_ci': AESCrypt.encriptar('1357924680'),
          'nombre': AESCrypt.encriptar('Carlos Ríos'),
          'contrasenna': AESCrypt.encriptar('carlos456'),
          'correo_electronico': AESCrypt.encriptar('carlosrios@example.com'),
          'rol': AESCrypt.encriptar('personal_regular'),
          'numero_de_telefono': AESCrypt.encriptar('555-0123'),
        },
        {
          'id_ci': AESCrypt.encriptar('3692581470'),
          'nombre': AESCrypt.encriptar('Ana González'),
          'contrasenna': AESCrypt.encriptar('ana789'),
          'correo_electronico': AESCrypt.encriptar('anagonzalez@example.com'),
          'rol': AESCrypt.encriptar('tecnico'),
          'numero_de_telefono': AESCrypt.encriptar('555-4567'),
        },
        {
          'id_ci': AESCrypt.encriptar('9876543211'),
          'nombre': AESCrypt.encriptar('David López'),
          'contrasenna': AESCrypt.encriptar('david12'),
          'correo_electronico': AESCrypt.encriptar('davidlopez@example.com'),
          'rol': AESCrypt.encriptar('interesado_en_el_registro'),
          'numero_de_telefono': AESCrypt.encriptar('555-8901'),
        },
        {
          'id_ci': AESCrypt.encriptar('0123456781'),
          'nombre': AESCrypt.encriptar('Julia Torres'),
          'contrasenna': AESCrypt.encriptar('julia345'),
          'correo_electronico': AESCrypt.encriptar('juliatorres@example.com'),
          'rol': AESCrypt.encriptar('administrador'),
          'numero_de_telefono': AESCrypt.encriptar('555-2345'),
        },
        {
          'id_ci': AESCrypt.encriptar('3692581471'),
          'nombre': AESCrypt.encriptar('Sara García'),
          'contrasenna': AESCrypt.encriptar('sara678'),
          'correo_electronico': AESCrypt.encriptar('saragarcia@example.com'),
          'rol': AESCrypt.encriptar('personal_regular'),
          'numero_de_telefono': AESCrypt.encriptar('555-6789'),
        },
        {
          'id_ci': AESCrypt.encriptar('9876543212'),
          'nombre': AESCrypt.encriptar('Mario Rojas'),
          'contrasenna': AESCrypt.encriptar('mario90'),
          'correo_electronico': AESCrypt.encriptar('mariorojas@example.com'),
          'rol': AESCrypt.encriptar('tecnico'),
          'numero_de_telefono': AESCrypt.encriptar('555-0123'),
        },
        {
          'id_ci': AESCrypt.encriptar('0123456782'),
          'nombre': AESCrypt.encriptar('Fernanda Morales'),
          'contrasenna': AESCrypt.encriptar('fernanda123'),
          'correo_electronico': AESCrypt.encriptar('fernandamorales@example.com'),
          'rol': AESCrypt.encriptar('interesado_en_el_registro'),
          'numero_de_telefono': AESCrypt.encriptar('555-4567'),
        },

      ];

      final currentDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      // Convertir la fecha y hora en el formato deseado
      final formattedDateTime = AESCrypt.encriptar(currentDateTime.toString());


      for (var dato in datos) {
        await connection.query(
          "INSERT INTO usuarios (id_ci, nombre, contrasenna, correo_electronico, rol, numero_de_telefono, fecha_de_registro ) VALUES ('${dato['id_ci']}', '${dato['nombre']}', '${dato['contrasenna']}', '${dato['correo_electronico']}', '${dato['rol']}', '${dato['numero_de_telefono']}', '$formattedDateTime')",
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
