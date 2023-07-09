import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:postgre_flutter/encriptacion.dart';

class api_control {
  static Future<void> eliminarDatos(String nombre_de_tabla, String ci) async {
    String Eci = AESCrypt.encrypt(ci);
    final deleteUrl = 'http://192.168.1.144:3000/query/$nombre_de_tabla/delete/$Eci';
    print(Eci);
    final response = await http.delete(Uri.parse(deleteUrl));

    if (response.statusCode == 200) {
      print('Usuario eliminado exitosamente');
    } else {
      print('Error al eliminar el usuario');
    }

    obtenerDatos(nombre_de_tabla);
  }

  static Future<void> editarDatos(String nombre_de_tabla, String ci, List<Map<String, dynamic>> dato) async {

    final fecha = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    final ciid = AESCrypt.encrypt(ci);
    final ciEncriptado = AESCrypt.encrypt(dato[0]['C.I.']);
    final nombreEncriptado = AESCrypt.encrypt(dato[0]['Nombre']);
    final contrasennaEncriptada = AESCrypt.encrypt(dato[0]['Contraseña']);
    final correoEncriptado = AESCrypt.encrypt(dato[0]['Correo Electrónico']);
    final rolEncriptado = AESCrypt.encrypt(detras_de_rol(dato[0]['Rol']));
    final telefonoEncriptado = AESCrypt.encrypt(dato[0]['Numero de Telefono']);
    final fechaEncriptada = AESCrypt.encrypt(fecha.toString());

    final updateUrl = 'http://192.168.1.144:3000/query/$nombre_de_tabla/update/$ciid';
    final Map<String, String> requestBody = {
      'id_ci': ciEncriptado,
      'nombre': nombreEncriptado,
      'contrasenna': contrasennaEncriptada,
      'correo_electronico': correoEncriptado,
      'rol': rolEncriptado,
      'numero_de_telefono': telefonoEncriptado,
      'fecha_de_registro': fechaEncriptada,
      'id': ciid,
    };
    print(requestBody);

    final response = await http.put(
      Uri.parse(updateUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      print('Usuario editado exitosamente');
    } else {
      print('Error al editar el usuario');
    }

    obtenerDatos(nombre_de_tabla);
  }

  static Future<void> agregarDatos(String nombre_de_tabla, List<Map<String, dynamic>> datos) async {

    final fecha = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    final ciEncriptado = AESCrypt.encrypt(datos[0]['C.I.']);
    final nombreEncriptado = AESCrypt.encrypt(datos[0]['Nombre']);
    final contrasennaEncriptada = AESCrypt.encrypt(datos[0]['Contraseña']);
    final correoEncriptado = AESCrypt.encrypt(datos[0]['Correo Electrónico']);
    final rolEncriptado = AESCrypt.encrypt(detras_de_rol(datos[1]['Rol']));
    final telefonoEncriptado = AESCrypt.encrypt(datos[0]['Numero de Telefono']);
    final fechaEncriptada = AESCrypt.encrypt(fecha);

    final addUrl = 'http://192.168.1.144:3000/query/$nombre_de_tabla/insert';
    final Map<String, String> requestBody = {
      'id_ci': ciEncriptado,
      'nombre': nombreEncriptado,
      'contrasenna': contrasennaEncriptada,
      'correo_electronico': correoEncriptado,
      'rol': rolEncriptado,
      'numero_de_telefono': telefonoEncriptado,
      'fecha_de_registro': fechaEncriptada,
    };



    final response = await http.post(
      Uri.parse(addUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );



    if (response.statusCode == 200) {
      print('Registro agregado exitosamente');
    } else {
      print('Error al agregar el registro');
    }

    obtenerDatos(nombre_de_tabla);
  }

  static Future<List<Map<String, dynamic>>> obtenerDatos(String nombre_de_tabla) async {
    final url = 'http://192.168.1.144:3000/query/$nombre_de_tabla';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      return jsonData.map<Map<String, dynamic>>((row) {
        return {
          'C.I.': AESCrypt.decrypt(row['id_ci']),
          'Nombre': AESCrypt.decrypt(row['nombre']),
          'Contraseña': AESCrypt.decrypt(row['contrasenna']),
          'Correo Electrónico': AESCrypt.decrypt(row['correo_electronico']),
          'Rol': Vista_de_rol(AESCrypt.decrypt(row['rol'])),
          'Fecha de Registro': AESCrypt.decrypt(row['fecha_de_registro']),
          'Numero de Telefono': AESCrypt.decrypt(row['numero_de_telefono']),
        };
      }).toList();
    } else {
      print('Error en la solicitud HTTP: ${response.statusCode}');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> obtenerDatosId(String nombre_de_tabla, String ci) async {
    final url = 'http://192.168.1.144:3000/query/$nombre_de_tabla/$ci';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      return jsonData.map<Map<String, dynamic>>((row) {
        return {
          'C.I.': AESCrypt.decrypt(row['id_ci']),
          'Nombre': AESCrypt.decrypt(row['nombre']),
          'Contraseña': AESCrypt.decrypt(row['contrasenna']),
          'Correo Electrónico': AESCrypt.decrypt(row['correo_electronico']),
          'Rol': Vista_de_rol(AESCrypt.decrypt(row['rol'])),
          'Fecha de Registro': AESCrypt.decrypt(row['fecha_de_registro']),
          'Numero de Telefono': AESCrypt.decrypt(row['numero_de_telefono']),
        };
      }).toList();
    } else {
      print('Error en la solicitud HTTP: ${response.statusCode}');
      return [];
    }
  }

  static String Vista_de_rol(String rol) {
    switch (rol) {
      case 'administrador':
        return 'Administrador';
      case 'personal_regular':
        return 'Personal';
      case 'tecnico':
        return 'Técnico';
      case 'interesado_en_el_registro':
        return 'En Trámite para el Registro';
      default:
        return '';
    }
  }
  static String detras_de_rol(String rol) {
    switch (rol) {
      case 'Administrador':
        return 'administrador';
      case 'Personal':
        return 'personal_regular';
      case 'Técnico':
        return 'tecnico';
      case 'En Trámite para el Registro':
        return 'interesado_en_el_registro';
      default:
        return '';
    }
  }
}
