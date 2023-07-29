import 'package:flutter/material.dart';
import 'package:postgre_flutter/Encriptacion.dart';
import 'package:postgre_flutter/para_windows/roles/editar.dart';
import 'package:postgre_flutter/para_windows/base_de_datos_control.dart';

class estado_de_usuarios extends StatefulWidget {
  @override
  _estado_de_usuariosState createState() => _estado_de_usuariosState();
}

class _estado_de_usuariosState extends State<estado_de_usuarios> {
  List<Map<String, dynamic>> usuarios = [];
  String searchQuery = '';
  String nombre_de_tabla = 'usuarios';
  Map<String, dynamic>? editingUsuario;
  Map<String, String> estadosUsuarios = {}; // Estado local de los usuarios

  @override
  void initState() {
    super.initState();
    obtenerUsuarios();
  }

  void obtenerUsuarios() async {
    usuarios = await base_de_datos_control.obtenerDatos(nombre_de_tabla);
    // Obtener los estados de los usuarios y guardarlos en el estado local
    for (final usuario in usuarios) {
      final ci = AESCrypt.encriptar(usuario['C.I.'].toString());
      estadosUsuarios[ci] = await base_de_datos_control.obtenerEstado(ci);
    }
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

  void eliminarUsuario(String ci) async {
    await base_de_datos_control.eliminarDatos(nombre_de_tabla, ci);
    obtenerUsuarios(); // Actualizar la lista de usuarios después de la eliminación
  }

  Future<void> cambiarEstadoUsuario(String ci) async {
    final nuevoEstado = estadosUsuarios[ci] == 'activo' ? 'inactivo' : 'activo';
    await base_de_datos_control.cambiarEstado(ci);
    // Actualizar el estado local con el nuevo estado
    estadosUsuarios[ci] = nuevoEstado;
    setState(() {});
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
                        'Estado',
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
                                // Reemplazar el IconButton con el Switch
                                Switch(
                                  value:  estadosUsuarios[AESCrypt.encriptar(usuario['C.I.'])] == 'activo',
                                  onChanged: (value) async {
                                    setState(() {
                                      estadosUsuarios[AESCrypt.encriptar(usuario['C.I.'])] = value ? 'activo' : 'inactivo';
                                    });
                                    await cambiarEstadoUsuario(usuario['C.I.']);
                                  },
                                  activeColor: estadosUsuarios[AESCrypt.encriptar(usuario['C.I.'])] == 'inactivo' ? Colors.green : Colors.grey,
                                  inactiveThumbColor: estadosUsuarios[AESCrypt.encriptar(usuario['C.I.'])] == 'inactivo' ? Colors.grey : Colors.green,
                                  activeTrackColor: estadosUsuarios[AESCrypt.encriptar(usuario['C.I.'])] == 'activo' ? Colors.lightGreenAccent : Colors.grey[300],
                                  inactiveTrackColor: estadosUsuarios[AESCrypt.encriptar(usuario['C.I.'])] == 'activo' ? Colors.grey[300] : Colors.lightGreenAccent,
                                )
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
