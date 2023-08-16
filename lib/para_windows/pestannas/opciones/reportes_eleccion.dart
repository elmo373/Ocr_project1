import 'package:flutter/material.dart';
import 'package:postgre_flutter/para_windows/roles/administrador_pestanna_R/reporte_de_estados_empresas.dart';
import 'package:postgre_flutter/para_windows/roles/administrador_pestanna_R/reporte_en_tortas.dart';
import 'package:postgre_flutter/para_windows/roles/administrador_pestanna_R/estado_usuarios.dart';
import 'package:postgre_flutter/para_windows/roles/administrador_pestanna_R/estado_de_las_empresas.dart';

class gestion_de_reportes_eleccion extends StatelessWidget {
  final int index;

  gestion_de_reportes_eleccion(this.index);

  @override
  Widget build(BuildContext context) {
    switch (index) {
      case 0:
        return estados_de_usuarios();
      case 1:
        return reporte_estado_empresa();
      case 2:
        return estado_empresa();
      case 3:
        return depositos_por_departamento();

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
