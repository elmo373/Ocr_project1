import 'package:flutter/material.dart';
import 'package:postgre_flutter/para_web/roles/administrador_pestanna_GD/documentos_de_registro.dart';
import 'package:postgre_flutter/para_web/roles/administrador_pestanna_GD/estado_documentos_de_registro.dart';
import 'package:postgre_flutter/para_web/roles/administrador_pestanna_GD/hojas_de_inspeccion.dart';
import 'package:postgre_flutter/para_web/roles/administrador_pestanna_GD/estado_hojas_de_inspeccion.dart';

class gestion_de_documentos_eleccion extends StatelessWidget {
  final int index;

  gestion_de_documentos_eleccion(this.index);

  @override
  Widget build(BuildContext context) {
    switch (index) {
      case 0:
        return documentos_de_registro();
      case 1:
        return estado_documentos_de_registro();
      case 2:
        return hojas_de_inspeccion();
      case 3:
        return estado_hojas_de_inspeccion();

      default:
        return Container(
          color: Color.fromRGBO(3, 72, 128, 1),
          child: Center(
            child: Text(
              'Contenido de error',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
    }
  }
}
