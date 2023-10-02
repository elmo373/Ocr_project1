import 'package:postgre_flutter/Encriptacion.dart';

String query(Map<String, dynamic> dato) {
  return "INSERT INTO directores (id_ci, nombre, contrasenna, correo_electronico, rol, numero_de_telefono, fecha_de_registro, cargo, fecha_de_inicio_de_gestion ) VALUES ('${dato['id_ci']}', '${dato['nombre']}', '${dato['contrasenna']}', '${dato['correo_electronico']}', '${dato['rol']}', '${dato['numero_de_telefono']}', '${dato['fecha_de_registro']}', '${dato['cargo']}', '${dato['fecha_de_inicio_de_gestion']}')";
}

List<Map<String, dynamic>> datos = [
  {
    'id_ci': AESCrypt.encriptar('84756239'),
    'nombre': AESCrypt.encriptar('Sr. Abg. Ubaldo Rojas Cuchallo'),
    'contrasenna': AESCrypt.encriptar('UvWx2345'),
    'correo_electronico': AESCrypt.encriptar('Ubaldo.RojasCuchallo@example.com'),
    'rol': AESCrypt.encriptar('administrador'),
    'numero_de_telefono': AESCrypt.encriptar('69481237'),
    'fecha_de_registro': AESCrypt.encriptar('2019-02-05'),
    'cargo': AESCrypt.encriptar('Director de Material Bélico'),
    'fecha_de_inicio_de_gestion': AESCrypt.encriptar('2019-02-05'),
  },
  {
    'id_ci': AESCrypt.encriptar('12347890'),
    'nombre': AESCrypt.encriptar('Sr. Gral. Brig. Willy Gonzalo Espejo Bobarin'),
    'contrasenna': AESCrypt.encriptar('6789OpQr'),
    'correo_electronico': AESCrypt.encriptar('WillyGonzalo.Espejo@example.com'),
    'rol': AESCrypt.encriptar('administrador'),
    'numero_de_telefono': AESCrypt.encriptar('73294618'),
    'fecha_de_registro': AESCrypt.encriptar('2019-02-03'),
    'cargo': AESCrypt.encriptar('Director General de Logística'),
    'fecha_de_inicio_de_gestion': AESCrypt.encriptar('2019-02-03'),
  },

];


