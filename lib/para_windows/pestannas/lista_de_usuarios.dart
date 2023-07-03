import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'dart:convert';

class WindowsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.green,
        scaffoldBackgroundColor: Colors.blue[900],
      ),
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Map<String, dynamic>> usuarios = [];

  @override
  void initState() {
    super.initState();
    connectToPostgreSQL();
  }

  void connectToPostgreSQL() async {
    final connection = PostgreSQLConnection(
      'localhost',
      5432,
      'ocrdb',
      username: 'emanuel',
      password: 'Emi77',
    );

    try {
      await connection.open();

      final results = await connection.query('SELECT nombre, ci, rol FROM usuarios');

      setState(() {
        usuarios = results.map((row) => {
          'nombre': row[0],
          'ci': row[1],
          'rol': row[2],
        }).toList();
      });


      // Imprimir los usuarios en la consola
      print('Usuarios:');
      for (var usuario in usuarios) {
        print('Nombre: ${usuario['nombre']}, CI: ${usuario['ci']}, Rol: ${usuario['rol']}');
      }
    } catch (e) {
      print('Error en la conexión a PostgreSQL: $e');
    } finally {
      await connection.close();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter y PostgreSQL'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: usuarios.length,
        itemBuilder: (BuildContext context, int index) {
          final usuario = usuarios[index];
          return ListTile(
            title: Text(usuario['nombre'] ?? ''),
            subtitle: Text(usuario['ci'] ?? ''),
            trailing: Text(usuario['rol'] ?? ''),
          );
        },
      ),
    );
  }
}
