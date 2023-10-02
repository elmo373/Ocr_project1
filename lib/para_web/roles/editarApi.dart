import 'package:flutter/material.dart';
import 'package:postgre_flutter/Colores.dart';
import 'package:postgre_flutter/Encriptacion.dart';
import 'package:postgre_flutter/para_web/api_control.dart';
import 'package:postgre_flutter/para_web/roles/validacion_datos.dart';

class Editores {
  List<Map<String, dynamic>> dato = [];

  Future<List<Map<String, dynamic>>> buscadorID(String nombre_de_tabla, String ci) async {
    ci = AESCrypt.encriptar(ci);
    final usuario = await api_control.obtenerDatosId(nombre_de_tabla, ci);
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
              backgroundColor: Colores.azulPrincipal,
              title: Text('Confirmar Edición', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold,)),
              content: Container(
                width: MediaQuery.of(context).size.width * 0.45, // 450% del ancho de la pantalla
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colores.azul4,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Editar Usuario",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                    ]..addAll(nuevosUsuarios.map((usuario) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: usuario.keys.map((key) {
                          if (key == 'Fecha de Registro') {
                            return SizedBox.shrink();
                          } else if (key == 'Rol') {
                            if (usuario[key] == 'Empresa') {
                              return SizedBox.shrink();
                            } else {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(key, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  Text(Rol_a_cambiar, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: ["Administrador", "Personal", "Técnico"].map((buttonText) {
                                      return Expanded(
                                        child: Container(
                                          margin: EdgeInsets.symmetric(horizontal: 4.0),
                                          decoration: BoxDecoration(
                                            color: buttonText == botonElegido ? Colores.azulPrincipal : Colors.white,
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
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: buttonText == botonElegido ? Colors.white : Colores.azulPrincipal,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              );
                            }
                          } else {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(key, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                TextField(
                                  readOnly: false,
                                  controller: TextEditingController(text: usuario[key].toString()),
                                  onChanged: (value) {
                                    usuario[key] = value;
                                  },
                                  decoration: InputDecoration(
                                    fillColor: Colores.grisPrincipal,
                                    filled: true,
                                    hintStyle: TextStyle(
                                      color: Color.fromRGBO(1, 20, 100, 1.0),
                                      fontSize: 16,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide(
                                        color: Colores.grisPrincipal,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        }).toList(),
                      );
                    }))..add(
                        Column(
                          children: [
                            errorMensaje != "" ? Text(errorMensaje, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)) : SizedBox.shrink()
                          ],
                        )
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.white, // Color de las letras
                    backgroundColor: Colors.blue, // Color de fondo del botón
                  ),
                  child: Text('Sí', style: TextStyle(fontWeight: FontWeight.bold)),
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
                  style: TextButton.styleFrom(
                    primary: Colors.white, // Color de las letras
                    backgroundColor: Colors.blue, // Color de fondo del botón
                  ),
                  child: Text('No', style: TextStyle(fontWeight: FontWeight.bold)),
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
