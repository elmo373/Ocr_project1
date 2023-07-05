import 'package:flutter/material.dart';
import 'package:postgre_flutter/Encriptacion.dart';
import 'package:postgre_flutter/para_windows/base_de_datos_control.dart';

class Editores {
  List<Map<String, dynamic>> dato = [];

  void Eliminador(BuildContext context, String nombre_de_tabla, void Function(String) eliminar,String ci) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Confirmar Eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar esto?'),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text('Eliminar'),
              onPressed: () {
                eliminar(ci); // Llamar a la función proporcionada como parámetro con el argumento adecuado
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> buscadorID(String nombre_de_tabla, String ci) async {
    ci = AESCrypt.encrypt(ci);
    final usuario = await base_de_datos_control.obtenerDatosID(nombre_de_tabla, ci);
    return usuario;
  }

  void Editar(BuildContext context, String nombre_de_tabla, void Function(String, List<Map<String, dynamic>>) editar, String ci) async {
    List<Map<String, dynamic>> usuarios = await buscadorID(nombre_de_tabla, ci);
    print(usuarios);

    List<Map<String, dynamic>> nuevosUsuarios = List.from(usuarios);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Edición'),
          content: Column(
            children: nuevosUsuarios.map((usuario) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: usuario.keys.map((key) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(key), // Mostrar el nombre de la columna

                      // Cuadro de texto editable
                      TextField(
                        onChanged: (value) {
                          // Actualizar el valor del campo en tiempo real en el nuevo usuario
                          usuario[key] = value;
                        },
                        controller: TextEditingController(text: usuario[key].toString()),
                      ),
                    ],
                  );
                }).toList(),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              child: Text('Sí'),
              onPressed: () {
                dato = nuevosUsuarios; // Guardar los cambios en la variable 'dato'

                editar(ci, dato);// Guardar los cambios en la base de datos

                Navigator.of(context).pop(); // Cerrar la ventana de alerta
              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar la ventana de alerta
              },
            ),
          ],
        );
      },
    );
  }

}
