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
      'localhost',
      5432,
      'ocrdb',
      username: 'emanuel',
      password: 'Emi77',
    );

    try {
      await connection.open();

      List<Map<String, dynamic>> datos = [
        {
          'id_ci': AESCrypt.encrypt('1234567890'),
          'nombre': AESCrypt.encrypt('Juan Pérez'),
          'contrasenna': AESCrypt.encrypt('abc123'),
          'correo_electronico': AESCrypt.encrypt('juanperez@example.com'),
          'rol': AESCrypt.encrypt('administrador'),
          'numero_de_telefono': AESCrypt.encrypt('555-1234'),
        },
        {
          'id_ci': AESCrypt.encrypt('9876543210'),
          'nombre': AESCrypt.encrypt('María López'),
          'contrasenna': AESCrypt.encrypt('pass123'),
          'correo_electronico': AESCrypt.encrypt('marialopez@example.com'),
          'rol': AESCrypt.encrypt('personal_regular'),
          'numero_de_telefono': AESCrypt.encrypt('555-5678'),
        },
        {
          'id_ci': AESCrypt.encrypt('5678901234'),
          'nombre': AESCrypt.encrypt('Pedro Gómez'),
          'contrasenna': AESCrypt.encrypt('password'),
          'correo_electronico': AESCrypt.encrypt('pedrogomez@example.com'),
          'rol': AESCrypt.encrypt('tecnico'),
          'numero_de_telefono': AESCrypt.encrypt('555-9012'),
        },
        {
          'id_ci': AESCrypt.encrypt('0123456789'),
          'nombre': AESCrypt.encrypt('Luisa Torres'),
          'contrasenna': AESCrypt.encrypt('qwerty'),
          'correo_electronico': AESCrypt.encrypt('luisatorres@example.com'),
          'rol': AESCrypt.encrypt('interesado_en_el_registro'),
          'numero_de_telefono': AESCrypt.encrypt('555-3456'),
        },
        {
          'id_ci': AESCrypt.encrypt('2468135790'),
          'nombre': AESCrypt.encrypt('Laura Sánchez'),
          'contrasenna': AESCrypt.encrypt('laura123'),
          'correo_electronico': AESCrypt.encrypt('laurasanchez@example.com'),
          'rol': AESCrypt.encrypt('administrador'),
          'numero_de_telefono': AESCrypt.encrypt('555-6789'),
        },
        {
          'id_ci': AESCrypt.encrypt('1357924680'),
          'nombre': AESCrypt.encrypt('Carlos Ríos'),
          'contrasenna': AESCrypt.encrypt('carlos456'),
          'correo_electronico': AESCrypt.encrypt('carlosrios@example.com'),
          'rol': AESCrypt.encrypt('personal_regular'),
          'numero_de_telefono': AESCrypt.encrypt('555-0123'),
        },
        {
          'id_ci': AESCrypt.encrypt('3692581470'),
          'nombre': AESCrypt.encrypt('Ana González'),
          'contrasenna': AESCrypt.encrypt('ana789'),
          'correo_electronico': AESCrypt.encrypt('anagonzalez@example.com'),
          'rol': AESCrypt.encrypt('tecnico'),
          'numero_de_telefono': AESCrypt.encrypt('555-4567'),
        },
        {
          'id_ci': AESCrypt.encrypt('9876543211'),
          'nombre': AESCrypt.encrypt('David López'),
          'contrasenna': AESCrypt.encrypt('david12'),
          'correo_electronico': AESCrypt.encrypt('davidlopez@example.com'),
          'rol': AESCrypt.encrypt('interesado_en_el_registro'),
          'numero_de_telefono': AESCrypt.encrypt('555-8901'),
        },
        {
          'id_ci': AESCrypt.encrypt('0123456781'),
          'nombre': AESCrypt.encrypt('Julia Torres'),
          'contrasenna': AESCrypt.encrypt('julia345'),
          'correo_electronico': AESCrypt.encrypt('juliatorres@example.com'),
          'rol': AESCrypt.encrypt('administrador'),
          'numero_de_telefono': AESCrypt.encrypt('555-2345'),
        },
        {
          'id_ci': AESCrypt.encrypt('3692581471'),
          'nombre': AESCrypt.encrypt('Sara García'),
          'contrasenna': AESCrypt.encrypt('sara678'),
          'correo_electronico': AESCrypt.encrypt('saragarcia@example.com'),
          'rol': AESCrypt.encrypt('personal_regular'),
          'numero_de_telefono': AESCrypt.encrypt('555-6789'),
        },
        {
          'id_ci': AESCrypt.encrypt('9876543212'),
          'nombre': AESCrypt.encrypt('Mario Rojas'),
          'contrasenna': AESCrypt.encrypt('mario90'),
          'correo_electronico': AESCrypt.encrypt('mariorojas@example.com'),
          'rol': AESCrypt.encrypt('tecnico'),
          'numero_de_telefono': AESCrypt.encrypt('555-0123'),
        },
        {
          'id_ci': AESCrypt.encrypt('0123456782'),
          'nombre': AESCrypt.encrypt('Fernanda Morales'),
          'contrasenna': AESCrypt.encrypt('fernanda123'),
          'correo_electronico': AESCrypt.encrypt('fernandamorales@example.com'),
          'rol': AESCrypt.encrypt('interesado_en_el_registro'),
          'numero_de_telefono': AESCrypt.encrypt('555-4567'),
        },

      ];

      final currentDateTime = DateTime.now();
      // Convertir la fecha y hora en el formato deseado
      final formattedDateTime = currentDateTime.toIso8601String();

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
