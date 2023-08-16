import 'package:flutter/material.dart';
import 'package:postgre_flutter/para_web/roles/administrador_pestanna_GU/creacion_de_usuarios.dart';
import 'package:postgre_flutter/para_web/roles/administrador_pestanna_GU/edicion_de_usuarios.dart';
import 'package:postgre_flutter/para_web/roles/administrador_pestanna_GU/estado_de_usuarios.dart';
import 'package:postgre_flutter/para_web/roles/administrador_pestanna_GU/lista_usuarios.dart';

Widget gestion_de_usaurio_eleccion(int index) {
  print('Gestion de usuarios eleccion');
  switch (index) {
    case 0:
      return lista_usuarios();
    case 1:
      return edicion_de_usuario();
    case 2:
      return creacion_de_usaurios();
    case 3:
      return estado_de_usuarios();
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
