import 'package:flutter/material.dart';
import 'package:postgre_flutter/para_windows/base_de_datos_control.dart';
import 'package:postgre_flutter/para_windows/roles/editar.dart';


class creacion_de_usaurios extends StatefulWidget {
  @override
  _creacion_de_usauriosState createState() => _creacion_de_usauriosState();
}

class _creacion_de_usauriosState extends State<creacion_de_usaurios> {
  String searchQuery = '';
  String nombre_de_tabla = 'usuarios';
  List<Map<String, dynamic>> usuarios = [
    {
      'C.I.': '',
      'Nombre': '',
      'Contraseña': '',
      'Correo Electrónico': '',
      'Rol': '',
      'Fecha de Registro': '',
      'Numero de Telefono': '',
    }
  ];
  void obtenerUsuarios() async {
    usuarios = await base_de_datos_control.obtenerDatos(nombre_de_tabla);
    setState(() {});
  }

  void agregarUsuario(String x,dynamic dato) async {
    await base_de_datos_control.agregarDatos(nombre_de_tabla, dato);
    obtenerUsuarios(); // Actualizar la lista de usuarios después de la eliminación
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(3, 72, 128, 1),
        padding: EdgeInsets.all(16),
        child: ListView(
          children: usuarios.map((usuario) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: usuario.keys.map((key) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      key,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    TextField(
                      controller: TextEditingController(text: usuario[key].toString()),
                      onChanged: (value) {
                        setState(() {
                          usuario[key] = value;
                        });
                      },
                    ),
                  ],
                );
              }).toList(),
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Editores editores = Editores();
          editores.Insertar(context, nombre_de_tabla, agregarUsuario);
        },
      ),
    );
  }
}
