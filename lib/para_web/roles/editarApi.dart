import 'package:flutter/material.dart';
import 'package:postgre_flutter/Encriptacion.dart';
import 'package:postgre_flutter/para_web/api_control.dart';

class EditoresApi {
  List<Map<String, dynamic>> dato = [];

  void Eliminador(BuildContext context, String nombre_de_tabla, void Function(String) eliminar, String ci) {
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
    final usuario = await api_control.obtenerDatosId(nombre_de_tabla, ci);
    return usuario;
  }

  void Editar(BuildContext context, String nombre_de_tabla, void Function(String, List<Map<String, dynamic>>) editar, String ci) async {
    List<Map<String, dynamic>> usuarios = await buscadorID(nombre_de_tabla, ci);
    List<Map<String, dynamic>> nuevosUsuarios = List.from(usuarios);

    String Rol_a_cambiar = "Cambiar " + usuarios[0]['Rol'].toString() + " por:";

    TextEditingController textController = TextEditingController(); // Controlador de texto

    showDialog(
      context: context,
      builder: (BuildContext context) {
        String botonElegido = ""; // Variable para almacenar el botón seleccionado

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Confirmar Edición'),
              content: Column(
                children: nuevosUsuarios.map((usuario) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: usuario.keys.map((key) {
                      if (key == 'Fecha de Registro') {
                        return SizedBox.shrink(); // No mostrar la fecha de registro
                      } else if (key == 'Rol') {
                        if (usuario[key] == 'En Trámite para el Registro') {
                          return SizedBox.shrink(); // Ocultar la columna "Rol" si el rol es "En Trámite para el Registro"
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(key),
                              // Mostrar el nombre de la columna
                              Text(Rol_a_cambiar),
                              for (String buttonText in ["Administrador", "Personal", "Técnico"])
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: buttonText == botonElegido ? Colors.red : Colors.blue,
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        botonElegido = buttonText;
                                      });
                                      // Acción a realizar cuando se presione el botón
                                      // Puedes agregar aquí la lógica para editar el rol
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(
                                        buttonText,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        }
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(key),
                            // Cuadro de texto editable
                            TextField(
                              readOnly: false,
                              controller: TextEditingController(text: usuario[key].toString()), // Utilizar el mismo controlador para todos los campos de texto
                              onChanged: (value) {
                                usuario[key] = value; // Actualizar el valor en la lista nuevosUsuarios al escribir en el campo de texto
                              },
                            ),
                          ],
                        );
                      }
                    }).toList(),
                  );
                }).toList(),
              ),
              actions: [
                TextButton(
                  child: Text('Sí'),
                  onPressed: () {
                    // Cambiar el valor del campo "rol" en nuevosUsuarios según el botón seleccionado
                    if(botonElegido != ''){
                      for (var usuario in nuevosUsuarios) {
                        usuario['Rol'] = botonElegido;
                      }
                    }

                    editar(ci, nuevosUsuarios); // Guardar los cambios en la base de datos
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
      },
    );
  }

  void Insertar(BuildContext context, String nombre_de_tabla, void Function(String, List<Map<String, dynamic>>) agregar) async{
    List<Map<String, dynamic>> nuevosUsuarios = [
      {
        'C.I.': '',
        'Nombre': '',
        'Contraseña': '',
        'Correo Electrónico': '',
        'Rol': '',
        'Fecha de Registro': '',
        'Numero de Telefono': ''}
    ];

    String Rol_a_cambiar = "Seleccionar rol:";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        String botonElegido = ""; // Variable para almacenar el botón seleccionado

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Confirmar Agregar'),
              content: Column(
                children: nuevosUsuarios.map((usuario) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: usuario.keys.map((key) {
                      if (key == 'Fecha de Registro') {
                        return SizedBox.shrink(); // No mostrar la fecha de registro
                      } else if (key == 'Rol') {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(key),
                            // Mostrar el nombre de la columna
                            Text(Rol_a_cambiar),
                            for (String buttonText in ["Administrador", "Personal", "Técnico","En Trámite para el Registro"])
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: buttonText == botonElegido ? Colors.red : Colors.blue,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      botonElegido = buttonText;
                                    });
                                    // Acción a realizar cuando se presione el botón
                                    // Puedes agregar aquí la lógica para agregar el rol
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      buttonText,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(key),
                            // Cuadro de texto editable
                            TextField(
                              readOnly: false,
                              controller: TextEditingController(text: usuario[key].toString()), // Utilizar el mismo controlador para todos los campos de texto
                              onChanged: (value) {
                                usuario[key] = value; // Actualizar el valor en la lista nuevosUsuarios al escribir en el campo de texto
                              },
                            ),
                          ],
                        );
                      }
                    }).toList(),
                  );
                }).toList(),
              ),
              actions: [
                TextButton(
                  child: Text('Agregar'),
                  onPressed: () {
                    // Crear un nuevo usuario con los valores seleccionados
                    Map<String, dynamic> nuevoUsuario = {
                      'Rol': botonElegido,
                    };
                    print(nuevoUsuario);

                    nuevosUsuarios.add(nuevoUsuario);
                    print(nuevosUsuarios);

                    agregar("x", nuevosUsuarios); // Agregar el usuario a la base de datos
                    Navigator.of(context).pop(); // Cerrar la ventana de alerta
                  },
                ),

                TextButton(
                  child: Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Cerrar la ventana de alerta
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
