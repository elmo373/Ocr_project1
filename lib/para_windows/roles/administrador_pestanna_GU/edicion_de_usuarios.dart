import 'package:flutter/material.dart';
import 'package:postgre_flutter/para_windows/roles/editar.dart';
import 'package:postgre_flutter/para_windows/base_de_datos_control.dart';

class edicion_de_usuario extends StatefulWidget {
  @override
  _edicion_de_usuarioState createState() => _edicion_de_usuarioState();
}

class _edicion_de_usuarioState extends State<edicion_de_usuario> {
  List<Map<String, dynamic>> usuarios = [];
  String searchQuery = '';
  String nombre_de_tabla = 'usuarios';
  Map<String, dynamic>? editingUsuario;

  @override
  void initState() {
    super.initState();
    obtenerUsuarios();
  }

  void obtenerUsuarios() async {
    usuarios = await base_de_datos_control.obtenerDatos(nombre_de_tabla);
    setState(() {});
  }

  List<Map<String, dynamic>> getFilteredUsuarios() {
    if (searchQuery.isEmpty) {
      return usuarios;
    } else {
      return usuarios.where((usuario) {
        return usuario.values.any((value) => value.toString().toLowerCase().contains(searchQuery.toLowerCase()));
      }).toList();
    }
  }

  void editarUsuario(String ci, dynamic dato) async {
    await base_de_datos_control.editarDatos(nombre_de_tabla, ci, dato);
    obtenerUsuarios(); // Actualizar la lista de usuarios después de la eliminación
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsuarios = getFilteredUsuarios();

    return Scaffold(
      body: Container(
        color: Color.fromRGBO(3, 72, 128, 1),
        child: Column(
          children: [
            Container(
              color: Color.fromRGBO(3, 72, 128, 1),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.search),
                    color: Colors.white,
                    onPressed: () {
                      // Aquí puedes implementar la lógica adicional que desees al hacer clic en la lupa
                    },
                  ),
                  Text(
                    'Buscar:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      onChanged: (value) => setState(() => searchQuery = value),
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: filteredUsuarios.isNotEmpty
                    ? DataTable(
                  columns: [
                    ...filteredUsuarios.first.keys.map(
                          (String key) => DataColumn(
                        label: Text(
                          key,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Editar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                  rows: filteredUsuarios.map(
                        (Map<String, dynamic> usuario) {
                      final usuarioId = usuario['C.I.']; // Reemplaza con el identificador único del usuario

                      return DataRow(
                        cells: [
                          ...usuario.keys.map(
                                (String key) {
                              final cellValue = key == 'Fecha de Registro'
                                  ? '${usuario[key]}'.substring(0, 19)
                                  : '${usuario[key]}';

                              if (editingUsuario != null && editingUsuario!['C.I.'] == usuarioId) {
                                return DataCell(
                                  TextField(
                                    onChanged: (value) {
                                      setState(() {
                                        editingUsuario![key] = value;
                                      });
                                    },
                                    controller: TextEditingController(text: editingUsuario![key]),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                );
                              }

                              return DataCell(
                                Text(
                                  cellValue,
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            },
                          ),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  color: Colors.lightBlueAccent,
                                  onPressed: () {
                                    Editores editores = Editores();
                                    editores.Editar(context, nombre_de_tabla, editarUsuario, usuario['C.I.']);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ).toList(),
                )
                    : Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}