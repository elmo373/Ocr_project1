import 'package:intl/intl.dart';
import 'package:postgres/postgres.dart';
import 'package:postgre_flutter/encriptacion.dart';

class base_de_datos_control {

  //static String Coneccion = 'localhost';

  static String Coneccion = '35.225.248.224';

  static PostgreSQLConnection _getConnection() {
    return PostgreSQLConnection(
      Coneccion,
      5432,
      'ocrdb',
      username: 'emanuel',
      password: 'emi77',
    );
  }
  static Future<void> editarDatos(String nombre_de_tabla, String ci, List<Map<String, dynamic>> dato) async {
    final connection = _getConnection();

    try {
      await connection.open();
      ci = AESCrypt.encriptar(ci);
      final fecha = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
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

      // Aquí actualizamos el id_ci en la tabla estado
      await connection.query("UPDATE estado SET id_ci = '$ciEncriptado' WHERE id_ci = '$ci'");

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
      final ciEncriptado = AESCrypt.encriptar(datos[0]['C.I.']);
      final nombreEncriptado = AESCrypt.encriptar(datos[0]['Nombre']);
      final contrasennaEncriptada = AESCrypt.encriptar(datos[0]['Contraseña']);
      final correoEncriptado = AESCrypt.encriptar(datos[0]['Correo Electrónico']);
      final rolEncriptado = AESCrypt.encriptar(detras_de_rol(datos[0]['Rol']));
      final telefonoEncriptado = AESCrypt.encriptar(datos[0]['Numero de Telefono']);
      final fechaEncriptada = AESCrypt.encriptar(fecha);

      print(ciEncriptado);

      // Insertar en la tabla de usuarios
      await connection.query(
          "INSERT INTO $nombre_de_tabla (id_ci, nombre, contrasenna, correo_electronico, rol, numero_de_telefono, fecha_de_registro) "
              "VALUES ('$ciEncriptado', '$nombreEncriptado', '$contrasennaEncriptada', '$correoEncriptado', '$rolEncriptado', '$telefonoEncriptado', '$fechaEncriptada')"
      );

      print('Registro agregado exitosamente');

      // Verificar si el rol es "Empresa" y llamar a la función correspondiente
      if (datos[0]['Rol'] == 'Empresa') {
        print("Se esta creando una empresa");
        await estadodeempresa(ciEncriptado, nombreEncriptado);
      }
    } catch (e) {
      print('Error al agregar el registro: $e');
    } finally {
      await connection.close();
    }
  }

  static Future<void> estadodeempresa(String id_empresa, String nombre) async {
    final connection = _getConnection();

    try {
      await connection.open();
      final estadoEmpresa = AESCrypt.encriptar('Registro en proceso');
      final razonEmpresa = AESCrypt.encriptar('Aún se está procesando su solicitud'); // Reemplaza con el valor correcto
      await connection.query(
          "INSERT INTO estado_empresa (id_empresa, estado_de_la_empresa, nombre, razon) "
              "VALUES ('$id_empresa', '$estadoEmpresa', '$nombre', '$razonEmpresa')"
      );

      print('Datos de empresa agregados exitosamente en estado_empresa');
    } catch (e) {
      print('Error al agregar los datos de la empresa en estado_empresa: $e');
    } finally {
      await connection.close();
    }
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
        return 'Empresa';
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
      case 'Empresa':
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

  static Future<List<Map<String, dynamic>>> obtenerEstadolista() async {

    final connection = _getConnection();

    try {
      await connection.open();
      final results = await connection.query("SELECT * FROM estado ");
      if (results.isNotEmpty) {
        return results.map<Map<String, dynamic>>((row) {
          return {
            'C.I.': AESCrypt.desencriptar(row[0]),
            'Estado': row[1],
          };
        }).toList();
      }else{return [];}
      // Si no se encontró ningún registro, se puede asumir que el usuario está activo por defecto.
    } catch (e) {
      print('Error al obtener el estado del usuario: $e');
      return [];
    } finally {
      await connection.close();
    }

  }

  static Future<List<Map<String, dynamic>>> obtenerDatosregistro() async {
    final connection = _getConnection();

    try {
      await connection.open();
      final results = await connection.query("SELECT * FROM documento_de_registro");
      return results.map<Map<String, dynamic>>((row) {
        return {
          'Documento': AESCrypt.desencriptar(row[0]),
          'Usuario': AESCrypt.desencriptar(row[1]),
          'Nombre Empresa': AESCrypt.desencriptar(row[2]),
          'Fecha Emisión': AESCrypt.desencriptar(row[3]),
          'Director Material Bélico': AESCrypt.desencriptar(row[4]),
          'Director General de Logística': AESCrypt.desencriptar(row[5]),
          'RUC': AESCrypt.desencriptar(row[6]),
          'Representante Legal': AESCrypt.desencriptar(row[7]),
          'Actividad Principal': AESCrypt.desencriptar(row[8]),
          'Nombre Propietario': AESCrypt.desencriptar(row[9]),
          'PDF': AESCrypt.desencriptar(row[10]),
        };
      }).toList();
    } catch (e) {
      print('Error en la conexión a PostgreSQL: $e');
      return [];
    } finally {
      await connection.close();
    }
  }

  static Future<List<Map<String, dynamic>>> obtenerDatosinspeccion() async {
    final connection = _getConnection();

    try {
      await connection.open();
      final results = await connection.query("SELECT * FROM documento_de_inspeccion");
      return results.map<Map<String, dynamic>>((row) {
        return {
          'Documento': AESCrypt.desencriptar(row[0]),
          'Registro': AESCrypt.desencriptar(row[1]),
          'Usuario': AESCrypt.desencriptar(row[2]),
          'Nombre Empresa': AESCrypt.desencriptar(row[3]),
          'Nombre Propietario': AESCrypt.desencriptar(row[4]),
          'Representante Legal': AESCrypt.desencriptar(row[5]),
          'Cumple': AESCrypt.desencriptar(row[6]),
          'Ubicación Depósito': AESCrypt.desencriptar(row[7]),
          'Fecha Emisión': AESCrypt.desencriptar(row[8]),
          'PDF': AESCrypt.desencriptar(row[9]),
        };
      }).toList();
    } catch (e) {
      print('Error en la conexión a PostgreSQL: $e');
      return [];
    } finally {
      await connection.close();
    }
  }

  static Future<List<Map<String, dynamic>>> obtenerEstadoDeDocumentoDeInspeccion() async {
    final connection = _getConnection();

    try {
      await connection.open();
      final results = await connection.query("SELECT * FROM estado_de_documento_de_inspeccion");
      if (results.isNotEmpty) {
        return results.map<Map<String, dynamic>>((row) {
          return {
            'Documento': AESCrypt.desencriptar(row[0]),  // Asumiendo que id_doc también está encriptado
            'Estado': row[1],
          };
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error al obtener el estado del documento de inspección: $e');
      return [];
    } finally {
      await connection.close();
    }
  }

  static Future<List<Map<String, dynamic>>> obtenerEstadoDeRegistro() async {
    final connection = _getConnection();

    try {
      await connection.open();
      final results = await connection.query("SELECT * FROM estado_de_registro");
      if (results.isNotEmpty) {
        return results.map<Map<String, dynamic>>((row) {
          return {
            'Documento': AESCrypt.desencriptar(row[0]),  // Asumiendo que id_doc también está encriptado
            'Estado': row[1],
          };
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error al obtener el estado del registro: $e');
      return [];
    } finally {
      await connection.close();
    }
  }

  static Future<void> cambiarEstado(String ci) async {
    final connection = _getConnection();
    ci = AESCrypt.encriptar(ci);

    try {
      await connection.open();
      final results = await connection.query("SELECT estado, fecha_de_cambio FROM estado WHERE id_ci = '$ci'");
      if (results.isEmpty) {
        // Si no se encontró ningún registro con el ci dado, podemos asumir que el usuario está inactivo.

        await connection.query("INSERT INTO estado (id_ci, estado, fecha_de_cambio) VALUES ('$ci', 'activo', null)");
      } else {
        final estadoActual = results.first[0] as String;
        final nuevoEstado = estadoActual == 'activo' ? 'inactivo' : 'activo';
        final fechaCambio = estadoActual == 'activo' ? DateTime.now().toString().split(' ')[0] : null;
        await connection.query("UPDATE estado SET estado = '$nuevoEstado', fecha_de_cambio = '$fechaCambio' WHERE id_ci = '$ci'");
      }
    } catch (e) {
      print('Error al cambiar el estado del usuario: $e');
    } finally {
      await connection.close();
    }
  }

  static Future<void> cambiarEstadoDocumentoInspeccion(String idDoc) async {
    final connection = _getConnection();
    idDoc = AESCrypt.encriptar(idDoc);

    try {
      await connection.open();

      // Cambio de estado para documento de inspección
      final resultsInsp = await connection.query("SELECT estado, fecha_de_cambio FROM estado_de_documento_de_inspeccion WHERE id_doc = '$idDoc'");
      if (resultsInsp.isNotEmpty) {
        final estadoActualInsp = resultsInsp.first[0] as String;
        final nuevoEstadoInsp = estadoActualInsp == 'activo' ? 'inactivo' : 'activo';
        final fechaCambioInsp = estadoActualInsp == 'activo' ? null : DateTime.now().toString().split(' ')[0];
        await connection.query("UPDATE estado_de_documento_de_inspeccion SET estado = '$nuevoEstadoInsp', fecha_de_cambio = '$fechaCambioInsp' WHERE id_doc = '$idDoc'");
      }
    } catch (e) {
      print('Error al cambiar el estado del documento de inspección: $e');
    } finally {
      await connection.close();
    }
  }

  static Future<void> cambiarEstadoRegistro(String idDoc) async {
    final connection = _getConnection();
    idDoc = AESCrypt.encriptar(idDoc);

    try {
      await connection.open();

      // Cambio de estado para registro
      final resultsReg = await connection.query("SELECT estado, fecha_de_cambio FROM estado_de_registro WHERE id_doc = '$idDoc'");
      if (resultsReg.isNotEmpty) {
        final estadoActualReg = resultsReg.first[0] as String;
        final nuevoEstadoReg = estadoActualReg == 'activo' ? 'inactivo' : 'activo';
        final fechaCambioReg = estadoActualReg == 'activo' ? null : DateTime.now().toString().split(' ')[0];
        await connection.query("UPDATE estado_de_registro SET estado = '$nuevoEstadoReg', fecha_de_cambio = '$fechaCambioReg' WHERE id_doc = '$idDoc'");
      }
    } catch (e) {
      print('Error al cambiar el estado del registro: $e');
    } finally {
      await connection.close();
    }
  }


}
