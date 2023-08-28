import 'package:flutter/material.dart';
import 'package:postgre_flutter/Colores.dart';
import 'package:postgre_flutter/Encriptacion.dart';
import 'package:postgre_flutter/para_web/api_control.dart';
import 'package:postgre_flutter/para_web/roles/validacion_datos.dart';

class EditoresApi {
  List<Map<String, dynamic>> dato = [];

  Future<List<Map<String, dynamic>>> buscadorID(String nombre_de_tabla, String ci) async {
    ci = AESCrypt.encriptar(ci);
    final usuario = await api_control.obtenerDatosId(nombre_de_tabla, ci);
    return usuario;
  }

  void Editar(BuildContext context, String nombre_de_tabla, void Function(String, List<Map<String, dynamic>>) editar, String ci) async {
    List<Map<String, dynamic>> usuarios = await buscadorID(nombre_de_tabla, ci);
    List<Map<String, dynamic>> nuevosUsuarios = List.from(usuarios);

    String Rol_a_cambiar = usuarios[0]['Rol'].toString();
    String botonElegido = "";
    String errorMensaje = "";

    List<Widget> construirWidgets() {
      List<Widget> widgets = [
        Text(
          "Edición de Usuarios",
          style: TextStyle(
            color: Colores.blanco,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
      ];

      for (var usuario in nuevosUsuarios) {
        for (var key in usuario.keys) {
          if (key == 'Fecha de Registro') continue;

          if (key == 'Rol') {
            widgets.add(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    key,
                    style: TextStyle(
                      color: Colores.blanco,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Cambiar rol $Rol_a_cambiar por:",
                    style: TextStyle(
                      color: Colores.blanco,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );

            for (int i = 0; i < ["Administrador", "Personal", "Técnico"].length; i += 2) {
              List<Widget> rowItems = [];
              for (int j = i; j < i + 2 && j < ["Administrador", "Personal", "Técnico"].length; j++) {
                rowItems.add(
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        color: botonElegido == ["Administrador", "Personal", "Técnico"][j] ? Colores.azul1 : Colores.blanco,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: TextButton(
                        onPressed: () {
                          botonElegido = ["Administrador", "Personal", "Técnico"][j];
                        },
                        child: Text(
                          ["Administrador", "Personal", "Técnico"][j],
                          style: TextStyle(
                            color: botonElegido == ["Administrador", "Personal", "Técnico"][j] ? Colores.blanco : Colores.azulPrincipal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
              widgets.add(Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: rowItems));
              if (i + 2 < ["Administrador", "Personal", "Técnico"].length) widgets.add(SizedBox(height: 10));
            }
          } else {
            widgets.add(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    key,
                    style: TextStyle(
                      color: Colores.blanco,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextFormField(
                    initialValue: usuario[key].toString(),
                    onChanged: (value) {
                      usuario[key] = value;
                    },
                    decoration: InputDecoration(
                      fillColor: Colores.grisPrincipal,
                      filled: true,
                      hintStyle: TextStyle(
                        color: Colores.azul3,
                        fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: Colores.grisPrincipal,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 18),
                ],
              ),
            );
          }
        }
      }
      return widgets;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Theme(
              data: ThemeData(
                dialogBackgroundColor: Colores.azulPrincipal,
              ),
              child: AlertDialog(
                title: Text('Confirmar Edición', style: TextStyle(color: Colores.blanco, fontSize: 30, fontWeight: FontWeight.bold,)),  // Agregué estilo al texto para que sea visible
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: construirWidgets().toList()..add(
                        Column(
                          children: [
                            errorMensaje != "" ? Text(errorMensaje, style: TextStyle(color: Colors.red)) : SizedBox.shrink()
                          ],
                        )
                    ),
                  ),
                ),
                actions: [
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          child: Text('Sí', style: TextStyle(color: Colores.blanco, fontSize: 20, fontWeight: FontWeight.bold)),
                          onPressed: () {
                            if (botonElegido != '') {
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
                          child: Text('No', style: TextStyle(color: Colores.blanco, fontSize: 20, fontWeight: FontWeight.bold)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
