import 'package:intl/intl.dart';
import 'package:postgres/postgres.dart';
import 'package:postgre_flutter/encriptacion.dart';

class base_de_datos_control {
  static PostgreSQLConnection _getConnection() {
    return PostgreSQLConnection(
      '35.225.248.224',
      5432,
      'ocrdb',
      username: 'emanuel',
      password: 'emi77',
    );
  }

  static Future<void> eliminarDatos(String nombre_de_tabla, String ci) async {
    final connection = _getConnection();

    try {
      await connection.open();
      ci = AESCrypt.encriptar(ci);
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
      ci = AESCrypt.encriptar(ci);
      final fecha =DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      final ciEncriptado = AESCrypt.encriptar(dato[0]['C.I.']);
      final nombreEncriptado = AESCrypt.encriptar(dato[0]['Nombre']);
      final contrasennaEncriptada = AESCrypt.encriptar(dato[0]['Contraseña']);
      final correoEncriptado = AESCrypt.encriptar(dato[0]['Correo Electrónico']);
      final rolEncriptado = AESCrypt.encriptar(detras_de_rol(dato[0]['Rol']));
      final telefonoEncriptado = AESCrypt.encriptar(dato[0]['Numero de Telefono']);
      final fechaEncriptada = AESCrypt.encriptar(fecha);

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

    try {
      await connection.open();
      final fecha = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      final ciEncriptado = AESCrypt.encriptar(datos[0]['C.I.']);
      final nombreEncriptado = AESCrypt.encriptar(datos[0]['Nombre']);
      final contrasennaEncriptada = AESCrypt.encriptar(datos[0]['Contraseña']);
      final correoEncriptado = AESCrypt.encriptar(datos[0]['Correo Electrónico']);
      final rolEncriptado = AESCrypt.encriptar(detras_de_rol(datos[1]['Rol']));
      final telefonoEncriptado = AESCrypt.encriptar(datos[0]['Numero de Telefono']);
      final fechaEncriptada = AESCrypt.encriptar(fecha);

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
          'C.I.': AESCrypt.desencriptar(row[0]),
          'Nombre': AESCrypt.desencriptar(row[1]),
          'Contraseña': AESCrypt.desencriptar(row[2]),
          'Correo Electrónico': AESCrypt.desencriptar(row[3]),
          'Rol': Vista_de_rol(AESCrypt.desencriptar(row[4])),
          'Fecha de Registro': AESCrypt.desencriptar(row[5]),
          'Numero de Telefono': AESCrypt.desencriptar(row[6]),
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
          'C.I.': AESCrypt.desencriptar(row[0]),
          'Nombre': AESCrypt.desencriptar(row[1]),
          'Contraseña': AESCrypt.desencriptar(row[2]),
          'Correo Electrónico': AESCrypt.desencriptar(row[3]),
          'Rol': Vista_de_rol(AESCrypt.desencriptar(row[4])),
          'Fecha de Registro': AESCrypt.desencriptar(row[5]),
          'Numero de Telefono': AESCrypt.desencriptar(row[6]),
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

  static Future<String> obtenerEstado(String ci) async {

    final connection = _getConnection();

    try {
      await connection.open();
      final results = await connection.query("SELECT * FROM estado WHERE id_ci = '$ci'");
      if (results.isNotEmpty) {
        print(results.first[1]);
        return results.first[1] as String;
      }else{return '';}
      // Si no se encontró ningún registro, se puede asumir que el usuario está activo por defecto.
    } catch (e) {
      print('Error al obtener el estado del usuario: $e');
      return 'No se pudo obtener el estado';
    } finally {
      await connection.close();
    }

  }

  static Future<void> cambiarEstado(String ci) async {
    final connection = _getConnection();
    ci = AESCrypt.encriptar(ci);

    try {
      await connection.open();
      final results = await connection.query("SELECT * FROM estado WHERE id_ci = '$ci'");
      if (results.isEmpty) {
        // Si no se encontró ningún registro con el ci dado, podemos asumir que el usuario está inactivo.

        await connection.query("INSERT INTO estado (id_ci, estado) VALUES ('$ci', 'activo')");
      } else {
        final estadoActual = results.first[1] as String;
        final nuevoEstado = estadoActual == 'activo' ? 'inactivo' : 'activo';
        await connection.query("UPDATE estado SET estado = '$nuevoEstado' WHERE id_ci = '$ci'");
      }
    } catch (e) {
      print('Error al cambiar el estado del usuario: $e');
    } finally {
      await connection.close();
    }
  }

}
