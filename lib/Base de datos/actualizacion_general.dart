import 'package:http/http.dart' as http;
import 'package:postgre_flutter/Encriptacion.dart';
import 'package:postgre_flutter/para_web/api_control.dart';
import 'dart:convert';

class actualizacion_general {
  static Future<void> cambios() async {
    final String BASE_URL = api_control.BASE_URL;
    final List<Map<String, dynamic>> tablaEmpresas = await api_control.obtenerDatos('usuarios');
    final List<Map<String, dynamic>> tablaRegistro = await api_control.obtenerDatosregistro();
    final List<Map<String, dynamic>> tablaInspeccion = await api_control.obtenerDatosinspeccion();
    final List<Map<String, dynamic>> tablaEstadoRegistro = await obtenerEstadoDeRegistro(BASE_URL);
    final List<Map<String, dynamic>> tablaEstadoInspeccion = await obtenerEstadoDeDocumentoDeInspeccion(BASE_URL);

    print('1');
    await cambioEmpresa(BASE_URL, tablaEmpresas);
    print('2');
    await cambioRegistro(BASE_URL, tablaRegistro);
    print('3');
    await cambioInspeccion(BASE_URL, tablaInspeccion);
    print('4');
    await cambiodeEstado(BASE_URL, tablaEstadoRegistro, 'documento_de_registro');
    print('5');
    await cambiodeEstado(BASE_URL, tablaEstadoInspeccion, 'documento_de_inspeccion');
    print('6');
    await registroCaduco(BASE_URL, tablaRegistro);
  }

  static Future<List<Map<String, dynamic>>> obtenerCambios(BASE_URL) async {
    final url = '$BASE_URL/query/cambio';
    final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        return jsonData.map<Map<String, dynamic>>((row) {
          return {
            'Nombre': AESCrypt.desencriptar(row['nombre_empresa']),
            'id': AESCrypt.desencriptar(row['id_doc']),
            'Cambio': AESCrypt.desencriptar(row['cambio']),
            'Fecha': AESCrypt.desencriptar(row['fecha']),
            'tipo': AESCrypt.desencriptar(row['tipo']),
          };
        }).toList();
      } else {
        print('Error en la solicitud obtenerDatosregistro HTTP: ${response
            .statusCode}');
        return [];
      }
  }

  static Future<void> cambioEmpresa(BASE_URL, tablaEmpresa) async {
    final tablaCambio = await obtenerCambios(BASE_URL);

    final ciExistente = tablaCambio.map((cambio) => cambio['id']).toList();

    // Filtrar usuarios con rol 'Empresa' y cuyo 'C.I.' no está en 'ciExistente'
    final usuariosSinCambios = tablaEmpresa.where((usuario) =>
    usuario['Rol'] == 'Empresa' && !ciExistente.contains(usuario['C.I.']))
        .toList();

    print(usuariosSinCambios);

    // Enviar los cambios al servidor uno por uno
    for (final usuario in usuariosSinCambios) {
      final fechaActual = DateTime.now();
      final fecha = '${fechaActual.year}-${fechaActual.month}-${fechaActual.day}';
      final Map<String, String> cambio = {
        'nombre_empresa': AESCrypt.encriptar(usuario['Nombre']),
        'id_doc': AESCrypt.encriptar(usuario['C.I.']),
        'cambio': AESCrypt.encriptar('Creación de usuario'),
        'fecha': AESCrypt.encriptar(usuario['Fecha de Registro']),
        'tipo': AESCrypt.encriptar('bueno'), // Cambiar según sea necesario
      };

      final guardarCambioUrl = '$BASE_URL/query/guardar_cambio';
      final guardarCambioResponse = await http.post(
        Uri.parse(guardarCambioUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(cambio),
      );

      if (guardarCambioResponse.statusCode == 200) {
        print('Cambio agregado exitosamente para ${usuario['Nombre']}');
      } else {
        print('Error al agregar cambio HTTP: ${guardarCambioResponse.statusCode}');
      }
    }
  }

  static Future<void> cambioRegistro(BASE_URL, tablaRegistro) async {
    final tablaCambio = await obtenerCambios(BASE_URL);

    final ciExistente = tablaCambio.map((cambio) => cambio['id']).toList();

    // Obtener registros cuyo id_doc no está en 'ciExistente'
    final registrosSinCambios = tablaRegistro
        .where((registro) => !ciExistente.contains(registro['Documento']))
        .toList();

    // Enviar los cambios al servidor uno por uno
    for (final registro in registrosSinCambios) {
      final Map<String, String> cambio = {
        'nombre_empresa': AESCrypt.encriptar(registro['Nombre Empresa']),
        'id_doc': AESCrypt.encriptar(registro['Documento']),
        'cambio': AESCrypt.encriptar('Creación de registro'),
        'fecha': AESCrypt.encriptar(registro['Fecha Emisión']),
        'tipo': AESCrypt.encriptar('bueno'), // Cambiar según sea necesario
      };

      final guardarCambioUrl = '$BASE_URL/query/guardar_cambio';
      final guardarCambioResponse = await http.post(
        Uri.parse(guardarCambioUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(cambio), // Envía un solo cambio en lugar de la lista completa
      );

      if (guardarCambioResponse.statusCode == 200) {
        print('Cambio de registro agregado exitosamente para ${registro['Nombre Empresa']}');
      } else {
        print('Error al agregar cambio de registro HTTP: ${guardarCambioResponse.statusCode}');
      }
    }
  }

  static Future<void> cambioInspeccion(BASE_URL, tablaInspeccion) async {
    final tablaCambio = await obtenerCambios(BASE_URL);

    final ciExistente = tablaCambio.map((cambio) => cambio['id']).toList();

    // Obtener registros cuyo id_doc no está en 'ciExistente'
    final registrosSinCambios = tablaInspeccion
        .where((registro) => !ciExistente.contains(registro['Documento']))
        .toList();

    // Enviar los cambios al servidor uno por uno
    for (final registro in registrosSinCambios) {
      final Map<String, String> cambio = {
        'nombre_empresa': AESCrypt.encriptar(registro['Nombre Empresa']),
        'id_doc': AESCrypt.encriptar(registro['Documento']),
        'cambio': AESCrypt.encriptar('Creación de registro'),
        'fecha': AESCrypt.encriptar(registro['Fecha Emisión']),
        'tipo': AESCrypt.encriptar('bueno'), // Cambiar según sea necesario
      };

      final guardarCambioUrl = '$BASE_URL/query/guardar_cambio';
      final guardarCambioResponse = await http.post(
        Uri.parse(guardarCambioUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(cambio), // Envía un solo cambio en lugar de la lista completa
      );

      if (guardarCambioResponse.statusCode == 200) {
        print('Cambio de registro agregado exitosamente para ${registro['Nombre Empresa']}');
      } else {
        print('Error al agregar cambio de registro HTTP: ${guardarCambioResponse.statusCode}');
      }
    }
  }

  static Future<List<Map<String, dynamic>>> obtenerEstadoDeDocumentoDeInspeccion(BASE_URL) async {
    print('obtenerEstadoDeDocumentoDeInspeccion');
    final url = '$BASE_URL/query/estado_de_documento_de_inspeccion';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      return jsonData.map<Map<String, dynamic>>((row) {
        return {
          'id_doc': AESCrypt.desencriptar(row['id_doc']),
          'Estado': row['estado'],
          'Fecha de Cambio': row['fecha_de_cambio'],
        };
      }).toList();
    } else {
      print('Error en la solicitud obtenerEstadoDeDocumentoDeInspeccion HTTP: ${response.statusCode}');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> obtenerEstadoDeRegistro(BASE_URL) async {
    print('obtenerEstadoDeRegistro');
    final url = '$BASE_URL/query/estado_de_registro';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      return jsonData.map<Map<String, dynamic>>((row) {
        return {
          'id_doc': AESCrypt.desencriptar(row['id_doc']),
          'Estado': row['estado'],
          'Fecha de Cambio': row['fecha_de_cambio'],
        };
      }).toList();
    } else {
      print('Error en la solicitud obtenerEstadoDeRegistro HTTP: ${response.statusCode}');
      return [];
    }
  }

  static Future<void> actualizarEstadoEmpresa(BASE_URL, id_empresa, estado_de_la_empresa, razon, documento) async {
    final fechaActual = DateTime.now();
    final fechaLimite = fechaActual.subtract(Duration(days: 10));
    var url = '$BASE_URL/query/';
    if (documento =='documento_de_registro'){
      url = '$BASE_URL/query/cambioestadoDeEmpresa';
    }
    if (documento =='documento_de_inspeccion'){
      url = '$BASE_URL/query/cambioestadoDeEmpresaInspeccion';
    }

    final Map<String, dynamic> requestBody = {
      'id_empresa': AESCrypt.encriptar(id_empresa),
      'estado_de_la_empresa': AESCrypt.encriptar(estado_de_la_empresa),
      'razon': AESCrypt.encriptar(razon),
    };

    //print(requestBody);

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode != 200) {
      print('Error al actualizar datos en estado_empresa');
    }
  }

  static Future<void> cambiodeEstado(BASE_URL, Estado, documento) async {
    final fechaActual = DateTime.now();
    final fechaLimite = fechaActual.subtract(Duration(days: 10));

    for (final estado in Estado) {
      if (estado['Fecha de Cambio'] != null && estado['Fecha de Cambio'] != "" && estado['Estado'] == 'inactivo' ) {
        print(estado['Estado']);
        print(estado['id_doc']);
        final fechaCambio = DateTime.parse(estado['Fecha de Cambio']);

        if (fechaCambio.isBefore(fechaLimite)) {
          // Cambiar el estado a "Registro Anulado" con la razón "Problemas con la documentación"
          await actualizarEstadoEmpresa(BASE_URL, estado['id_doc'], 'Registro anulado', 'Problemas con la documentación', documento);
        } else {
          // Cambiar el estado a "Registro en Observación" con la misma razón
          await actualizarEstadoEmpresa(BASE_URL, estado['id_doc'], 'Registro en observación', 'Problemas con la documentación', documento);
        }
      }else{
        if (estado['Fecha de Cambio'] == "" && estado['Fecha de Cambio'] != null && estado['Estado'] == 'activo') {
          print('sin fecha');
          print(estado['Estado']);
          await actualizarEstadoEmpresa(
              BASE_URL, estado['id_doc'], 'Registro activo',
              'Cumplió con la ultima inspección', documento);
        }
      }
    }
  }

  static Future<void> registroCaduco(BASE_URL, datosDeRegistro) async {
    final fechaActual = DateTime.now();
    final fechaLimite = fechaActual.subtract(Duration(days: 10));

    for (final registro in datosDeRegistro) {
      final documentoId = registro['Documento'];
      final fechaEmision = DateTime.parse(registro['Fecha Emisión']);
      final diferenciaDeAnios = fechaActual.difference(fechaEmision).inDays ~/ 365;
      if (diferenciaDeAnios >= 2) {
        // Cambiar el estado a "Registro caducado" con la razón "El documento ya caducó"
        await actualizarEstadoEmpresa(BASE_URL, documentoId, 'Registro caducado', 'El documento ya caducó', 'documento_de_registro');
      }
    }
  }

}
