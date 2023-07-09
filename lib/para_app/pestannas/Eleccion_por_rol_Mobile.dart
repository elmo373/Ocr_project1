import 'package:flutter/material.dart';
import 'package:postgre_flutter/para_app/roles/main_administrador_Mobile.dart';
import 'package:postgre_flutter/para_app/roles/main_personal_Mobile.dart';

Widget buildTabContent(int index, String rol) {
  switch (rol) {
    case 'Administrador':
      switch (index) {
        case 0:
          return WindowsAdministradorMain();
        case 4:
          return WindowsAdministradorMain();
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
        // Aquí debes retornar el widget correspondiente al rol 'Personal'
        // Por ejemplo: return WindowsPersonalMain();
          return WebPersonalListaDeUsuarios();
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
        // Aquí debes retornar el widget correspondiente al rol 'Técnico'
        // Por ejemplo: return WindowsTecnicoMain();
          return Container();
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
    case 'En Trámite para el Registro':
      switch (index) {
        case 0:
        // Aquí debes retornar el widget correspondiente al rol 'En Trámite para el Registro'
        // Por ejemplo: return WindowsTramiteMain();
          return Container();
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
