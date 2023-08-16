import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:postgre_flutter/encriptacion.dart';

class api_control {
  static const BASE_URL = 'https://durable-path-393614.uc.r.appspot.com';

  //static const BASE_URL = 'http://localhost:3000';

  static Future<void> eliminarDatos(String nombre_de_tabla, String ci) async {
    String Eci = AESCrypt.encriptar(ci);
    final deleteUrl = '$BASE_URL/query/usuarios/delete/$Eci';
    final response = await http.delete(Uri.parse(deleteUrl));

    if (response.statusCode == 200) {
      print('Usuario eliminado exitosamente');
    } else {
      print('Error al eliminar el usuario');
    }

  }

  static Future<void> editarDatos(String nombre_de_tabla, String ci, List<Map<String, dynamic>> dato) async {
    final fecha = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    final ciid = AESCrypt.encriptar(ci);
    final ciEncriptado = AESCrypt.encriptar(dato[0]['C.I.']);
    final nombreEncriptado = AESCrypt.encriptar(dato[0]['Nombre']);
    final contrasennaEncriptada = AESCrypt.encriptar(dato[0]['Contraseña']);
    final correoEncriptado = AESCrypt.encriptar(dato[0]['Correo Electrónico']);
    final rolEncriptado = AESCrypt.encriptar(detras_de_rol(dato[0]['Rol']));
    final telefonoEncriptado = AESCrypt.encriptar(
        dato[0]['Numero de Telefono']);
    final fechaEncriptada = AESCrypt.encriptar(fecha.toString());

    final updateUrl = '$BASE_URL/query/usuarios/update/$ciid';
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

  }

  static Future<void> agregarDatos(String nombre_de_tabla, List<Map<String, dynamic>> datos) async {
    final fecha = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    final ciEncriptado = AESCrypt.encriptar(datos[0]['C.I.']);
    final nombreEncriptado = AESCrypt.encriptar(datos[0]['Nombre']);
    final contrasennaEncriptada = AESCrypt.encriptar(datos[0]['Contraseña']);
    final correoEncriptado = AESCrypt.encriptar(datos[0]['Correo Electrónico']);
    final rolEncriptado = AESCrypt.encriptar(detras_de_rol(datos[0]['Rol']));
    final telefonoEncriptado = AESCrypt.encriptar(
        datos[0]['Numero de Telefono']);
    final fechaEncriptada = AESCrypt.encriptar(fecha);

    final addUrl = '$BASE_URL/query/usuarios/insert';

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

  }

  static Future<List<Map<String, dynamic>>> obtenerDatos(String nombre_de_tabla) async {
    print('obtenerDato');
    final url = '$BASE_URL/query/usuarios';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      return jsonData.map<Map<String, dynamic>>((row) {
        return {
          'C.I.': AESCrypt.desencriptar(row['id_ci']),
          'Nombre': AESCrypt.desencriptar(row['nombre']),
          'Contraseña': AESCrypt.desencriptar(row['contrasenna']),
          'Correo Electrónico': AESCrypt.desencriptar(
              row['correo_electronico']),
          'Rol': Vista_de_rol(AESCrypt.desencriptar(row['rol'])),
          'Fecha de Registro': AESCrypt.desencriptar(row['fecha_de_registro']),
          'Numero de Telefono': AESCrypt.desencriptar(
              row['numero_de_telefono']),
        };
      }).toList();
    } else {
      print('Error en la solicitud  obtenerDatos HTTP: ${response.statusCode}');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> obtenerDatosId(String nombre_de_tabla, String ci) async {
    print('obtenerDatosId');
    final url = '$BASE_URL/query/usuarios/$ci';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      return jsonData.map<Map<String, dynamic>>((row) {
        return {
          'C.I.': AESCrypt.desencriptar(row['id_ci']),
          'Nombre': AESCrypt.desencriptar(row['nombre']),
          'Contraseña': AESCrypt.desencriptar(row['contrasenna']),
          'Correo Electrónico': AESCrypt.desencriptar(
              row['correo_electronico']),
          'Rol': Vista_de_rol(AESCrypt.desencriptar(row['rol'])),
          'Fecha de Registro': AESCrypt.desencriptar(row['fecha_de_registro']),
          'Numero de Telefono': AESCrypt.desencriptar(
              row['numero_de_telefono']),
        };
      }).toList();
    } else {
      print('Error en la solicitud obtenerDatosId HTTP: ${response.statusCode}');
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
    print('obtenerEstado');
    final url = '$BASE_URL/query/estado/$ci';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData.isNotEmpty) {
        return jsonData[0]['estado'];
      } else {
        return 'No se encontró el estado';
      }
    } else {
      print('Error en la solicitud ObtenerEstadoHTTP: ${response.statusCode}');
      return 'Error en la solicitud HTTP';
    }
  }

  static Future<void> agregarRegistro(Map<String, dynamic> subir) async {
    print('agregarRegistro');
    String idDocEncriptado = AESCrypt.encriptar(subir['id_doc'] ?? '');
    String idUsuarioEncriptado = AESCrypt.encriptar(subir['id_usuario'] ?? '');
    String nombreEmpresaEncriptado = AESCrypt.encriptar(
        subir['nombre_empresa'] ?? '');
    String fechaDeEmisionEncriptado = AESCrypt.encriptar(
        subir['fecha_de_emision'] ?? '');
    String idDirectorMaterialBelicoEncriptado = AESCrypt.encriptar(
        subir['id_director_material_belico'] ?? '');
    String idDirectorGeneralDeLogisticaEncriptado = AESCrypt.encriptar(
        subir['id_director_general_de_logistica'] ?? '');
    String rucEncriptado = AESCrypt.encriptar(subir['ruc'] ?? '');
    String representanteLegalEncriptado = AESCrypt.encriptar(
        subir['representante_legal'] ?? '');
    String actividadPrincipalEncriptado = AESCrypt.encriptar(
        subir['actividad_principal'] ?? '');
    String nombrePropietarioEncriptado = AESCrypt.encriptar(
        subir['nombre_propietario'] ?? '');
    String pdfEncriptado = AESCrypt.encriptar(subir['pdf'] ?? '');

    //Crea un mapa con los valores encriptados
    final Map<String, String> encriptado = {
      'id_doc': idDocEncriptado,
      'id_usuario': idUsuarioEncriptado,
      'nombre_empresa': nombreEmpresaEncriptado,
      'fecha_de_emision': fechaDeEmisionEncriptado,
      'id_director_material_belico': idDirectorMaterialBelicoEncriptado,
      'id_director_general_de_logistica': idDirectorGeneralDeLogisticaEncriptado,
      'ruc': rucEncriptado,
      'representante_legal': representanteLegalEncriptado,
      'actividad_principal': actividadPrincipalEncriptado,
      'nombre_propietario': nombrePropietarioEncriptado,
      'pdf': pdfEncriptado,
    };

    final addUrl = '$BASE_URL/query/documento_de_registro/insert';
    print(subir);
    print(encriptado);
    final response = await http.post(
      Uri.parse(addUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(encriptado),
    );

    if (response.statusCode == 200) {
      print('Registro agregado exitosamente');
    } else {
      print('Error al agregar el registro');
      print('Estado de respuesta: ${response.statusCode}');
      print('Cuerpo de respuesta: ${response.body}');
    }
  }

  static Future<List<Map<String, dynamic>>> obtenerEstadolista() async {
    final url = '$BASE_URL/query/estado';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      return jsonData.map<Map<String, dynamic>>((row) {
        return {
          'C.I.': AESCrypt.desencriptar(row['id_ci']),
          'Estado': row['estado'],
        };
      }).toList();
    } else {
      print('Error en la solicitud ObtenerEstadolista HTTP: ${response.statusCode}');
      return [];
    }
  }

  static Future<void> cambiarEstado(String ci) async {
    print('cambiar Estado');
    ci = AESCrypt.encriptar(ci);
    final url = '$BASE_URL/query/cambiar_estado/$ci';
    final response = await http.put(Uri.parse(url));

    if (response.statusCode != 200) {
      print('Error al cambiar el estado del usuario: ${response.statusCode}');
    }
  }


  static Future<List<Map<String, dynamic>>> obtenerDatosregistro() async {
    print('obtenerDatosregistro');
    final url = '$BASE_URL/query/pedirdocumento_de_registro';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      return jsonData.map<Map<String, dynamic>>((row) {

        return {
          'Documento': AESCrypt.desencriptar(row['id_doc']),
          'Usuario': AESCrypt.desencriptar(row['id_usuario']),
          'Nombre Empresa': AESCrypt.desencriptar(row['nombre_empresa']),
          'Fecha Emisión': AESCrypt.desencriptar(row['fecha_de_emision']),
          'Director Material Bélico': AESCrypt.desencriptar(row['id_director_material_belico']),
          'Director General de Logística': AESCrypt.desencriptar(row['id_director_general_de_logistica']),
          'RUC': AESCrypt.desencriptar(row['ruc']),
          'Representante Legal': AESCrypt.desencriptar(row['representante_legal']),
          'Actividad Principal': AESCrypt.desencriptar(row['actividad_principal']),
          'Nombre Propietario': AESCrypt.desencriptar(row['nombre_propietario']),
          'PDF': AESCrypt.desencriptar(row['pdf']),
        };

      }).toList();
    } else {
      print('Error en la solicitud obtenerDatosregistro HTTP: ${response.statusCode}');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> obtenerDatosinspeccion() async {
    print('obtenerDatosinspeccion');
    final url = '$BASE_URL/query/documento_de_inspeccion';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      return jsonData.map<Map<String, dynamic>>((row) {
        return {
          'Documento': AESCrypt.desencriptar(row['id_doc']),
          'Registro': AESCrypt.desencriptar(row['id_registro']),
          'Usuario': AESCrypt.desencriptar(row['id_usuario']),
          'Nombre Empresa': AESCrypt.desencriptar(row['nombre_empresa']),
          'Nombre Propietario': AESCrypt.desencriptar(row['nombre_propietario']),
          'Representante Legal': AESCrypt.desencriptar(row['representante_legal']),
          'Cumple': AESCrypt.desencriptar(row['cumple']),
          'Ubicación Depósito': AESCrypt.desencriptar(row['ubicacion_deposito']),
          'Fecha Emisión': AESCrypt.desencriptar(row['fecha_de_emision']),
          'PDF': AESCrypt.desencriptar(row['pdf']),
        };
      }).toList();
    } else {
      print('Error en la solicitud obtenerDatosinspeccion HTTP: ${response.statusCode}');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> obtenerEstadoDeDocumentoDeInspeccion() async {
    print('obtenerEstadoDeDocumentoDeInspeccion');
    final url = '$BASE_URL/query/estado_de_documento_de_inspeccion';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      return jsonData.map<Map<String, dynamic>>((row) {
        return {
          'id_doc': AESCrypt.desencriptar(row['id_doc']),
          'Estado': row['estado'],
        };
      }).toList();
    } else {
      print('Error en la solicitud obtenerEstadoDeDocumentoDeInspeccion HTTP: ${response.statusCode}');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> obtenerEstadoDeRegistro() async {
    print('obtenerEstadoDeRegistro');
    final url = '$BASE_URL/query/estado_de_registro';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      return jsonData.map<Map<String, dynamic>>((row) {
        return {
          'id_doc': AESCrypt.desencriptar(row['id_doc']),
          'Estado': row['estado'],
        };
      }).toList();
    } else {
      print('Error en la solicitud obtenerEstadoDeRegistro HTTP: ${response.statusCode}');
      return [];
    }
  }
}
