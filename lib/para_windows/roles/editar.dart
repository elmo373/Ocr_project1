import 'package:flutter/material.dart';
import 'package:postgre_flutter/Encriptacion.dart';
import 'package:postgre_flutter/para_windows/base_de_datos_control.dart';
import 'package:postgre_flutter/para_windows/roles/validacion_datos.dart';

class Editores {
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
                eliminar(ci);
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> buscadorID(String nombre_de_tabla, String ci) async {
    ci = AESCrypt.encriptar(ci);
    final usuario = await base_de_datos_control.obtenerDatosID(nombre_de_tabla, ci);
    return usuario;
  }

  void Editar(BuildContext context, String nombre_de_tabla, void Function(String, List<Map<String, dynamic>>) editar, String ci) async {
    List<Map<String, dynamic>> usuarios = await buscadorID(nombre_de_tabla, ci);
    List<Map<String, dynamic>> nuevosUsuarios = List.from(usuarios);

    String Rol_a_cambiar = "Cambiar " + usuarios[0]['Rol'].toString() + " por:";

    TextEditingController textController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        String botonElegido = "";
        String errorMensaje = "";

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
                        return SizedBox.shrink();
                      } else if (key == 'Rol') {
                        if (usuario[key] == 'En Trámite para el Registro') {
                          return SizedBox.shrink();
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(key),
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
                            TextField(
                              readOnly: false,
                              controller: TextEditingController(text: usuario[key].toString()),
                              onChanged: (value) {
                                usuario[key] = value;
                              },
                            ),
                          ],
                        );
                      }
                    }).toList(),
                  );
                }).toList()..add(
                    Column(
                      children: [
                        errorMensaje != "" ? Text(errorMensaje, style: TextStyle(color: Colors.red)) : SizedBox.shrink()
                      ],
                    )
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Sí'),
                  onPressed: () {
                    if(botonElegido != ''){
                      for (var usuario in nuevosUsuarios) {
                        usuario['Rol'] = botonElegido;
                      }
                    }
                    var errores = validarUsuarios(nuevosUsuarios);
                    if (errores?.isEmpty ?? true) {
                      editar(ci, nuevosUsuarios);
                      Navigator.of(context).pop();
                    } else {
                      setState(() {
                        errorMensaje = errores?.join(", ") ?? "";
                      });
                    }
                  },
                ),
                TextButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop();
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
        String botonElegido = "";

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
                        return SizedBox.shrink();
                      } else if (key == 'Rol') {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(key),
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
                            TextField(
                              readOnly: false,
                              controller: TextEditingController(text: usuario[key].toString()),
                              onChanged: (value) {
                                usuario[key] = value;
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
                    if (botonElegido != "") {
                      nuevosUsuarios[0]['Rol'] = botonElegido;
                    }

                    agregar("x", nuevosUsuarios);
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
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
