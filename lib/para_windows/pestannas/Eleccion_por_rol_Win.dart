import 'package:flutter/material.dart';
import 'package:postgre_flutter/para_windows/pestannas/opciones/gestion_de_documentos.dart';
import 'package:postgre_flutter/para_windows/pestannas/opciones/gestion_de_usuarios.dart';
import 'package:postgre_flutter/para_windows/roles/otras/estado_de_registro_otros.dart';
import 'package:postgre_flutter/para_windows/roles/otras/lista_de_documento_otros.dart';
import 'package:postgre_flutter/para_windows/roles/otras/lista_de_usuarios_otros.dart';
import 'package:postgre_flutter/para_windows/roles/otras/seguimiento.dart';
import 'opciones/reportes.dart';

Widget buildTabContent(int index, Map<String, dynamic> datos) {
  switch (datos["Rol"]) {
    case 'Administrador':
      switch (index) {
        case 0:
          return gestion_de_usuario();
        case 1:
          return gestion_de_documentos();
        case 3:
          return gestion_de_reportes();
        case 2:
          return seguimiento();
        default:
          return Container(
            color: Color.fromRGBO(3, 72, 128, 1),
            child: Center(
              child: Text(
                'Contenido de error',
                style: TextStyle(color: Color.fromRGBO(3, 72, 128, 1)),
              ),
            ),
          );
      }
    case 'Personal':
      switch (index) {
        case 0:
          return lista_de_usuarios_otros();
        case 1:
          return lista_de_documentos_otros();

        default:
          return Container(
            color: Color.fromRGBO(3, 72, 128, 1),
            child: Center(
              child: Text(
                'Contenido de error',
                style: TextStyle(color: Color.fromRGBO(3, 72, 128, 1)),
              ),
            ),
          );
      }
    case 'Técnico':
      switch (index) {
        case 0:
          return lista_de_usuarios_otros();
        case 1:
          return lista_de_documentos_otros();
        case 2:
          return gestion_de_reportes();
        default:
          return Container(
            color: Color.fromRGBO(3, 72, 128, 1),
            child: Center(
              child: Text(
                'Contenido de error',
                style: TextStyle(color: Color.fromRGBO(3, 72, 128, 1)),
              ),
            ),
          );
      }
    case 'Empresa':
      switch (index) {
        case 0:
          return estado_de_registro_otros(datos: datos);
        default:
          return Container(
            color: Color.fromRGBO(3, 72, 128, 1),
            child: Center(
              child: Text(
                'Contenido de error',
                style: TextStyle(color: Color.fromRGBO(3, 72, 128, 1)),
              ),
            ),
          );
      }
    default:
      return Container(
        color: Color.fromRGBO(3, 72, 128, 1),
        child: Center(
          child: Text(
            'Contenido de error',
            style: TextStyle(color: Color.fromRGBO(3, 72, 128, 1)),
          ),
        ),
      );
  }
}
