import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:postgre_flutter/encriptacion.dart';

class api_control {
  static const BASE_URL = 'https://durable-path-393614.uc.r.appspot.com';
  //static const BASE_URL = 'http://localhost:3000';


  static Future<void> eliminarDatos(String nombre_de_tabla, String ci) async {
    String Eci = AESCrypt.encriptar(ci);
    final deleteUrl = '$BASE_URL/query/$nombre_de_tabla/delete/$Eci';
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
    final ciid = AESCrypt.encriptar(ci);
    final ciEncriptado = AESCrypt.encriptar(dato[0]['C.I.']);
    final nombreEncriptado = AESCrypt.encriptar(dato[0]['Nombre']);
    final contrasennaEncriptada = AESCrypt.encriptar(dato[0]['Contraseña']);
    final correoEncriptado = AESCrypt.encriptar(dato[0]['Correo Electrónico']);
    final rolEncriptado = AESCrypt.encriptar(detras_de_rol(dato[0]['Rol']));
    final telefonoEncriptado = AESCrypt.encriptar(dato[0]['Numero de Telefono']);
    final fechaEncriptada = AESCrypt.encriptar(fecha.toString());

    final updateUrl = '$BASE_URL/query/$nombre_de_tabla/update/$ciid';
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
    final ciEncriptado = AESCrypt.encriptar(datos[0]['C.I.']);
    final nombreEncriptado = AESCrypt.encriptar(datos[0]['Nombre']);
    final contrasennaEncriptada = AESCrypt.encriptar(datos[0]['Contraseña']);
    final correoEncriptado = AESCrypt.encriptar(datos[0]['Correo Electrónico']);
    final rolEncriptado = AESCrypt.encriptar(detras_de_rol(datos[1]['Rol']));
    final telefonoEncriptado = AESCrypt.encriptar(datos[0]['Numero de Telefono']);
    final fechaEncriptada = AESCrypt.encriptar(fecha);

    final addUrl = '$BASE_URL/query/$nombre_de_tabla/insert';
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
    final url = '$BASE_URL/query/$nombre_de_tabla';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      return jsonData.map<Map<String, dynamic>>((row) {
        return {
          'C.I.': AESCrypt.desencriptar(row['id_ci']),
          'Nombre': AESCrypt.desencriptar(row['nombre']),
          'Contraseña': AESCrypt.desencriptar(row['contrasenna']),
          'Correo Electrónico': AESCrypt.desencriptar(row['correo_electronico']),
          'Rol': Vista_de_rol(AESCrypt.desencriptar(row['rol'])),
          'Fecha de Registro': AESCrypt.desencriptar(row['fecha_de_registro']),
          'Numero de Telefono': AESCrypt.desencriptar(row['numero_de_telefono']),
        };
      }).toList();
    } else {
      print('Error en la solicitud HTTP: ${response.statusCode}');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> obtenerDatosId(String nombre_de_tabla, String ci) async {
    final url = '$BASE_URL/query/$nombre_de_tabla/$ci';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      return jsonData.map<Map<String, dynamic>>((row) {
        return {
          'C.I.': AESCrypt.desencriptar(row['id_ci']),
          'Nombre': AESCrypt.desencriptar(row['nombre']),
          'Contraseña': AESCrypt.desencriptar(row['contrasenna']),
          'Correo Electrónico': AESCrypt.desencriptar(row['correo_electronico']),
          'Rol': Vista_de_rol(AESCrypt.desencriptar(row['rol'])),
          'Fecha de Registro': AESCrypt.desencriptar(row['fecha_de_registro']),
          'Numero de Telefono': AESCrypt.desencriptar(row['numero_de_telefono']),
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
    final url = '$BASE_URL/query/estado/$ci';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return response.body; // <-- Devuelve la respuesta directamente
    } else {
      print('Error en la solicitud HTTP: ${response.statusCode}');
      return 'Error en la solicitud HTTP';
    }
  }


  static Future<void> agregarRegistro(Map<String, dynamic> subir) async {
    // Encripta cada uno de los campos uno por uno
    String idDocEncriptado = AESCrypt.encriptar(subir['id_doc'] ?? '');
    String idUsuarioEncriptado = AESCrypt.encriptar(subir['id_usuario'] ?? '');
    String nombreEmpresaEncriptado = AESCrypt.encriptar(subir['nombre_empresa'] ?? '');
    String fechaDeEmisionEncriptado = AESCrypt.encriptar(subir['fecha_de_emision'] ?? '');
    String idDirectorMaterialBelicoEncriptado = AESCrypt.encriptar(subir['id_director_material_belico'] ?? '');
    String idDirectorGeneralDeLogisticaEncriptado = AESCrypt.encriptar(subir['id_director_general_de_logistica'] ?? '');
    String rucEncriptado = AESCrypt.encriptar(subir['ruc'] ?? '');
    String representanteLegalEncriptado = AESCrypt.encriptar(subir['representante_legal'] ?? '');
    String actividadPrincipalEncriptado = AESCrypt.encriptar(subir['actividad_principal'] ?? '');
    String nombrePropietarioEncriptado = AESCrypt.encriptar(subir['nombre_propietario'] ?? '');
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

  static Future<void> agregarInspeccion(Map<String, dynamic> subir) async {
    // Encripta cada uno de los campos uno por uno
    String idDocEncriptado = AESCrypt.encriptar(subir['id_doc'] ?? '');
    String idRegistroEncriptado = AESCrypt.encriptar(subir['id_registro'] ?? '');
    String idUsuarioEncriptado = AESCrypt.encriptar(subir['id_usuario'] ?? '');
    String nombreEmpresaEncriptado = AESCrypt.encriptar(subir['nombre_empresa'] ?? '');
    String fechaDeEmisionEncriptado = AESCrypt.encriptar(subir['fecha_de_emision'] ?? '');
    String representanteLegalEncriptado = AESCrypt.encriptar(subir['representante_legal'] ?? '');
    String nombrePropietarioEncriptado = AESCrypt.encriptar(subir['nombre_propietario'] ?? '');
    String cumpleEncriptado = AESCrypt.encriptar(subir['cumple'] ?? '');
    String ubicacionDepositoEncriptado = AESCrypt.encriptar(subir['ubicacion_deposito'] ?? '');
    String pdfEncriptado = AESCrypt.encriptar(subir['pdf'] ?? '');

    // Crea un mapa con los valores encriptados
    final Map<String, String> encriptado = {
      'id_doc': idDocEncriptado,
      'id_registro': idRegistroEncriptado,
      'id_usuario': idUsuarioEncriptado,
      'nombre_empresa': nombreEmpresaEncriptado,
      'nombre_propietario': nombrePropietarioEncriptado,
      'representante_legal': representanteLegalEncriptado,
      'cumple': cumpleEncriptado,
      'ubicacion_deposito': ubicacionDepositoEncriptado,
      'fecha_de_emision': fechaDeEmisionEncriptado,
      'pdf': pdfEncriptado,
    };

    final addUrl = '$BASE_URL/query/agregardocumento_de_inspeccion/insert';
    print(subir);
    print(encriptado);
    final response = await http.post(
      Uri.parse(addUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(encriptado),
    );

    if (response.statusCode == 200) {
      print('Inspección agregada exitosamente');
    } else {
      print('Error al agregar la inspección');
      print('Estado de respuesta: ${response.statusCode}');
      print('Cuerpo de respuesta: ${response.body}');
    }
  }


}
