import 'package:intl/intl.dart';
import 'package:postgres/postgres.dart';
import 'package:postgre_flutter/encriptacion.dart';

class base_de_datos_control {
  static PostgreSQLConnection _getConnection() {
    return PostgreSQLConnection(
      'localhost',
      5432,
      'ocrdb',
      username: 'emanuel',
      password: 'Emi77',
    );
  }

  static Future<void> eliminarDatos(String nombre_de_tabla, String ci) async {
    final connection = _getConnection();

    try {
      await connection.open();
      ci = AESCrypt.encrypt(ci);
      await connection.execute("DELETE FROM $nombre_de_tabla WHERE id_ci = '$ci'");
      print('Usuario eliminado exitosamente');
    } catch (e) {
      print('Error al eliminar el usuario: $e');
    } finally {
      await connection.close();
    }
    obtenerDatos(nombre_de_tabla);
  }

  static Future<void> editarDatos(String nombre_de_tabla, String ci, List<Map<String, dynamic>> dato) async {
    final connection = _getConnection();
    print(dato);

    try {
      await connection.open();
      ci = AESCrypt.encrypt(ci);
      final fecha =DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      final ciEncriptado = AESCrypt.encrypt(dato[0]['C.I.']);
      final nombreEncriptado = AESCrypt.encrypt(dato[0]['Nombre']);
      final contrasennaEncriptada = AESCrypt.encrypt(dato[0]['Contraseña']);
      final correoEncriptado = AESCrypt.encrypt(dato[0]['Correo Electrónico']);
      final rolEncriptado = AESCrypt.encrypt(detras_de_rol(dato[0]['Rol']));
      final telefonoEncriptado = AESCrypt.encrypt(dato[0]['Numero de Telefono']);
      final fechaEncriptada = AESCrypt.encrypt(fecha);

      await connection.query("UPDATE usuarios SET id_ci = '$ciEncriptado',"
          "nombre = '$nombreEncriptado',"
          "contrasenna = '$contrasennaEncriptada',"
          "correo_electronico = '$correoEncriptado',"
          "rol = '$rolEncriptado',"
          "numero_de_telefono = '$telefonoEncriptado',"
          "fecha_de_registro = '$fechaEncriptada' WHERE id_ci = '$ci'");

      print('Usuario editado exitosamente');
    } catch (e) {
      print('Error al editar el usuario: $e');
    } finally {
      await connection.close();
    }
    obtenerDatos(nombre_de_tabla);
  }

  static Future<void> agregarDatos(String nombre_de_tabla, List<Map<String, dynamic>> datos) async {
    final connection = _getConnection();
    print(datos);

    try {
      await connection.open();
      final fecha = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      final ciEncriptado = AESCrypt.encrypt(datos[0]['C.I.']);
      final nombreEncriptado = AESCrypt.encrypt(datos[0]['Nombre']);
      final contrasennaEncriptada = AESCrypt.encrypt(datos[0]['Contraseña']);
      final correoEncriptado = AESCrypt.encrypt(datos[0]['Correo Electrónico']);
      final rolEncriptado = AESCrypt.encrypt(detras_de_rol(datos[1]['Rol']));
      final telefonoEncriptado = AESCrypt.encrypt(datos[0]['Numero de Telefono']);
      final fechaEncriptada = AESCrypt.encrypt(fecha);

      await connection.query(
          "INSERT INTO $nombre_de_tabla (id_ci, nombre, contrasenna, correo_electronico, rol, numero_de_telefono, fecha_de_registro) "
              "VALUES ('$ciEncriptado', '$nombreEncriptado', '$contrasennaEncriptada', '$correoEncriptado', '$rolEncriptado', '$telefonoEncriptado', '$fechaEncriptada')"
      );

      print('Registro agregado exitosamente');
    } catch (e) {
      print('Error al agregar el registro: $e');
    } finally {
      await connection.close();
    }

    obtenerDatos(nombre_de_tabla);
  }

  static Future<List<Map<String, dynamic>>> obtenerDatos(String nombre_de_tabla) async {
    final connection = _getConnection();

    try {
      await connection.open();
      final results = await connection.query("SELECT * FROM $nombre_de_tabla");
      return results.map<Map<String, dynamic>>((row) {
        return {
          'C.I.': AESCrypt.decrypt(row[0]),
          'Nombre': AESCrypt.decrypt(row[1]),
          'Contraseña': AESCrypt.decrypt(row[2]),
          'Correo Electrónico': AESCrypt.decrypt(row[3]),
          'Rol': Vista_de_rol(AESCrypt.decrypt(row[4])),
          'Fecha de Registro': AESCrypt.decrypt(row[5]),
          'Numero de Telefono': AESCrypt.decrypt(row[6]),
        };
      }).toList();
    } catch (e) {
      print('Error en la conexión a PostgreSQL: $e');
      return [];
    } finally {
      await connection.close();
    }
  }

  static Future<List<Map<String, dynamic>>> obtenerDatosID(String nombre_de_tabla,String ci) async {
    final connection = _getConnection();

    try {
      await connection.open();
      final results = await connection.query("SELECT * FROM $nombre_de_tabla WHERE id_ci = '$ci'");
      return results.map<Map<String, dynamic>>((row) {
        return {
          'C.I.': AESCrypt.decrypt(row[0]),
          'Nombre': AESCrypt.decrypt(row[1]),
          'Contraseña': AESCrypt.decrypt(row[2]),
          'Correo Electrónico': AESCrypt.decrypt(row[3]),
          'Rol': Vista_de_rol(AESCrypt.decrypt(row[4])),
          'Fecha de Registro': AESCrypt.decrypt(row[5]),
          'Numero de Telefono': AESCrypt.decrypt(row[6]),
        };
      }).toList();
    } catch (e) {
      print('Error en la conexión a PostgreSQL: $e');
      return [];
    } finally {
      await connection.close();
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
