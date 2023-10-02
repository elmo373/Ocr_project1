import 'package:postgre_flutter/Encriptacion.dart';

String query(Map<String, dynamic> dato) {
  return "INSERT INTO estado_empresa (id_empresa, estado_de_la_empresa, nombre, razon) VALUES ('${dato['id_empresa']}', '${dato['estado_de_la_empresa']}', '${dato['nombre']}', '${dato['razon']}')"; }

List<Map<String, dynamic>> datos = [
  {
    'id_empresa': AESCrypt.encriptar('12398765'),
    'estado_de_la_empresa': AESCrypt.encriptar('Registro activo'),
    'nombre': AESCrypt.encriptar('MineraBlastMaster S.A.'),
    'razon': AESCrypt.encriptar('Cumplió con la última inspección'),
  },
  {
    'id_empresa': AESCrypt.encriptar('76485923'),
    'estado_de_la_empresa': AESCrypt.encriptar('Registro activo'),
    'nombre': AESCrypt.encriptar('Dinamita & Rocas S.A.'),
    'razon': AESCrypt.encriptar('Cumplió con la última inspección'),
  },
  {
    'id_empresa': AESCrypt.encriptar('90128374'),
    'estado_de_la_empresa': AESCrypt.encriptar('Registro activo'),
    'nombre': AESCrypt.encriptar('Explotec Minero Limitada'),
    'razon': AESCrypt.encriptar('Cumplió con la última inspección'),
  },
  {
    'id_empresa': AESCrypt.encriptar('98712345'),
    'estado_de_la_empresa': AESCrypt.encriptar('Registro activo'),
    'nombre': AESCrypt.encriptar('Ingeniería en Explosivos S.A.'),
    'razon': AESCrypt.encriptar('Cumplió con la última inspección'),
  },
  {
    'id_empresa': AESCrypt.encriptar('7234658'),
    'estado_de_la_empresa': AESCrypt.encriptar('Registro activo'),
    'nombre': AESCrypt.encriptar('Geo-Explo Innovación S.L.'),
    'razon': AESCrypt.encriptar('Cumplió con la última inspección'),
  },
  {
    'id_empresa': AESCrypt.encriptar('12903847'),
    'estado_de_la_empresa': AESCrypt.encriptar('Registro activo'),
    'nombre': AESCrypt.encriptar('Blaster Minería Segura'),
    'razon': AESCrypt.encriptar('Cumplió con la última inspección'),
  },
  {
    'id_empresa': AESCrypt.encriptar('10928374'),
    'estado_de_la_empresa': AESCrypt.encriptar('Registro activo'),
    'nombre': AESCrypt.encriptar('RocaExplosiva Inc.'),
    'razon': AESCrypt.encriptar('Cumplió con la última inspección'),
  },
  {
    'id_empresa': AESCrypt.encriptar('29384756'),
    'estado_de_la_empresa': AESCrypt.encriptar('Registro activo'),
    'nombre': AESCrypt.encriptar('DynaMiner Tecnología Ltda.'),
    'razon': AESCrypt.encriptar('Cumplió con la última inspección'),
  },
  {
    'id_empresa': AESCrypt.encriptar('2847563'),
    'estado_de_la_empresa': AESCrypt.encriptar('Registro activo'),
    'nombre': AESCrypt.encriptar('ExploSegura Equipos S.A.'),
    'razon': AESCrypt.encriptar('Cumplió con la última inspección'),
  },
  {
    'id_empresa': AESCrypt.encriptar('67812349'),
    'estado_de_la_empresa': AESCrypt.encriptar('Registro activo'),
    'nombre': AESCrypt.encriptar('Extracción con Impacto S.L.'),
    'razon': AESCrypt.encriptar('Cumplió con la última inspección'),
  },
  {
    'id_empresa': AESCrypt.encriptar('49583762'),
    'estado_de_la_empresa': AESCrypt.encriptar('Registro activo'),
    'nombre': AESCrypt.encriptar('Detonaciones Controladas S.A.'),
    'razon': AESCrypt.encriptar('Cumplió con la última inspección'),
  },
  {
    'id_empresa': AESCrypt.encriptar('19283746'),
    'estado_de_la_empresa': AESCrypt.encriptar('Registro activo'),
    'nombre': AESCrypt.encriptar('Piedra y Pólvora Ltda.'),
    'razon': AESCrypt.encriptar('Cumplió con la última inspección'),
  },
  {
    'id_empresa': AESCrypt.encriptar('56473819'),
    'estado_de_la_empresa': AESCrypt.encriptar('Registro activo'),
    'nombre': AESCrypt.encriptar('Minería y Explosivos Integrados S.A.'),
    'razon': AESCrypt.encriptar('Cumplió con la última inspección'),
  },
  {
    'id_empresa': AESCrypt.encriptar('34928576'),
    'estado_de_la_empresa': AESCrypt.encriptar('Registro activo'),
    'nombre': AESCrypt.encriptar('Carga y Disparo Minero S.L.'),
    'razon': AESCrypt.encriptar('Cumplió con la última inspección'),
  },
  {
    'id_empresa': AESCrypt.encriptar('4839205'),
    'estado_de_la_empresa': AESCrypt.encriptar('Registro activo'),
    'nombre': AESCrypt.encriptar('Dinamita Innovadora Inc.'),
    'razon': AESCrypt.encriptar('Cumplió con la última inspección'),
  },
  {
    'id_empresa': AESCrypt.encriptar('82346519'),
    'estado_de_la_empresa': AESCrypt.encriptar('Registro activo'),
    'nombre': AESCrypt.encriptar('GeoDynamite S.A.'),
    'razon': AESCrypt.encriptar('Cumplió con la última inspección'),
  },
  {
    'id_empresa': AESCrypt.encriptar('87651239'),
    'estado_de_la_empresa': AESCrypt.encriptar('Registro activo'),
    'nombre': AESCrypt.encriptar('Innovaciones en Detonación Ltda.'),
    'razon': AESCrypt.encriptar('Cumplió con la última inspección'),
  },
  {
    'id_empresa': AESCrypt.encriptar('19238475'),
    'estado_de_la_empresa': AESCrypt.encriptar('Registro activo'),
    'nombre': AESCrypt.encriptar('Tecnología de Explosión Segura S.L.'),
    'razon': AESCrypt.encriptar('Cumplió con la última inspección'),
  },
  {
    'id_empresa': AESCrypt.encriptar('12934786'),
    'estado_de_la_empresa': AESCrypt.encriptar('Registro activo'),
    'nombre': AESCrypt.encriptar('Minas y Explosivos Avanzados Inc.'),
    'razon': AESCrypt.encriptar('Cumplió con la última inspección'),
  },

  {
    'id_empresa': AESCrypt.encriptar('49586712'),
    'estado_de_la_empresa': AESCrypt.encriptar('Registro activo'),
    'nombre': AESCrypt.encriptar('Explosivos para Minas Seguras S.A.'),
    'razon': AESCrypt.encriptar('Cumplió con la última inspección'),
  },


];


