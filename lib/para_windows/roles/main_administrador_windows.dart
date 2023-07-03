import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:postgre_flutter/Encriptacion.dart';

void main() {
  runApp(WindowsAdministradorMain());
}

class WindowsAdministradorMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WindowsHomePage(),
    );
  }
}

class WindowsHomePage extends StatefulWidget {
  @override
  _WindowsHomePageState createState() => _WindowsHomePageState();
}

class _WindowsHomePageState extends State<WindowsHomePage> {
  List<Map<String, dynamic>> usuarios = [];
  String searchQuery = '';
  Map<String, dynamic>? editingUsuario = null;


  @override
  void initState() {
    super.initState();
    obtenerUsuarios();
  }

  void obtenerUsuarios() async {
    final connection = PostgreSQLConnection(
      'localhost',
      5432,
      'ocrdb',
      username: 'emanuel',
      password: 'Emi77',
    );

    try {
      await connection.open();

      final results = await connection.query("SELECT * FROM usuarios");
      usuarios = results.map((row) {
        final usuario = {
          'C.I.': AESCrypt.decrypt(row[0]),
          'Nombre': AESCrypt.decrypt(row[1]),
          'Contraseña': AESCrypt.decrypt(row[2]),
          'Correo Electrónico': AESCrypt.decrypt(row[3]),
          'Rol': getRolName(AESCrypt.decrypt(row[4])),
          'Fecha de Registro': row[5],
          'Numero de Telefono': AESCrypt.decrypt(row[6]),
        };
        return usuario;
      }).toList();
    } catch (e) {
      print('Error en la conexión a PostgreSQL: $e');
    } finally {
      await connection.close();
    }

    setState(() {});
  }

  String getRolName(String rol) {
    switch (rol) {
      case 'administrador':
        return 'Administrador';
      case 'personal_regular':
        return 'Personal';
      case 'tecnico':
        return 'Técnico';
      case 'interesado_en_el_registro':
        return 'En Trámite para el Registro';
      default:
        return '';
    }
  }

  List<Map<String, dynamic>> getFilteredUsuarios() {
    if (searchQuery.isEmpty) {
      return usuarios;
    } else {
      return usuarios.where((usuario) {
        return usuario.values.any((value) =>
            value.toString().toLowerCase().contains(searchQuery.toLowerCase()));
      }).toList();
    }
  }

  void editarUsuario(String usuarioId) {
    setState(() {
      editingUsuario = usuarios.firstWhere((usuario) => usuario['C.I.'] == usuarioId);
    });
  }

  void eliminarUsuario(String ci) async {
    final connection = PostgreSQLConnection(
      'localhost',
      5432,
      'ocrdb',
      username: 'emanuel',
      password: 'Emi77',
    );

    try {
      await connection.open();
      ci = AESCrypt.encrypt(ci);
      await connection.execute("DELETE FROM usuarios WHERE id_ci = '$ci'");
      print('Usuario eliminado exitosamente');
    } catch (e) {
      print('Error al eliminar el usuario: $e');
    } finally {
      await connection.close();
    }

    obtenerUsuarios(); // Actualizar la lista de usuarios después de la eliminación
  }

  void guardarCambios() async {
    final connection = PostgreSQLConnection(
      'localhost',
      5432,
      'ocrdb',
      username: 'emanuel',
      password: 'Emi77',
    );

    try {
      await connection.open();
      final ci = AESCrypt.encrypt(editingUsuario!['C.I.']);
      final nombre = AESCrypt.encrypt(editingUsuario!['Nombre']);
      final contrasenna = AESCrypt.encrypt(editingUsuario!['Contraseña']);
    final correo = AESCrypt.encrypt(editingUsuario!['Correo Electrónico']);
    final rol = getRolValue(editingUsuario!['Rol']);
    final telefono = AESCrypt.encrypt(editingUsuario!['Numero de Telefono']);

      final String formattedDateTime = 'NOW()';

    await connection.query("UPDATE usuarios SET id_ci = '$ci', nombre = '$nombre', contrasenna = '$contrasenna', correo_electronico = '$correo', rol = '$rol', numero_de_telefono = '$telefono', fecha_de_registro ='$formattedDateTime' WHERE id_ci = '$ci'");

    print('Cambios guardados exitosamente');
    } catch (e) {
    print('Error al guardar los cambios: $e');
    } finally {
    await connection.close();
    setState(() {

    });
    }

    obtenerUsuarios(); // Actualizar la lista de usuarios después de guardar los cambios
  }

  String getRolValue(String rolName) {
    switch (rolName) {
      case 'Administrador':
        return 'administrador';
      case 'Personal':
        return 'personal_regular';
      case 'Técnico':
        return 'tecnico';
      case 'En Trámite para el Registro':
        return 'interesado_en_el_registro';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsuarios = getFilteredUsuarios();

    return Scaffold(
      body: Container(
        color: Colors.indigo[900],
        child: Column(
          children: [
            Container(
              color: Colors.indigo[900],
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    'Buscar:',
                    style: TextStyle(
                      color: Colors.lightGreenAccent[700],
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      style: TextStyle(color: Colors.lightGreenAccent[700]),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightGreenAccent.shade700),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightGreenAccent.shade700),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    color: Colors.lightGreenAccent[700],
                    onPressed: () {
                      // Aquí puedes implementar la lógica adicional que desees al hacer clic en la lupa
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.person_add),
                    color: Colors.lightGreenAccent[700],
                    onPressed: () {
                      // Implementa la lógica para agregar usuarios
                    },
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
                    ...filteredUsuarios.first.keys.map((String key) {
                      return DataColumn(
                        label: Text(
                          key,
                          style: TextStyle(
                            color: Colors.lightGreenAccent[700],
                            fontSize: 18,
                          ),
                        ),
                      );
                    }),
                    DataColumn(
                      label: Text(
                        'Acciones',
                        style: TextStyle(
                          color: Colors.lightGreenAccent[700],
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                  rows: filteredUsuarios.map((Map<String, dynamic> usuario) {
                    final usuarioId = usuario['C.I.']; // Reemplaza con el identificador único del usuario

                    return DataRow(
                      cells: [
                        ...usuario.keys.map((String key) {
                          final cellValue = key == 'Fecha de Registro'
                              ? '${usuario[key]}'.substring(0, 10)
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
                                style: TextStyle(color: Colors.lightGreenAccent[700]),
                              ),
                            );
                          }

                          return DataCell(
                            Text(
                              cellValue,
                              style: TextStyle(color: Colors.lightGreenAccent[700]),
                            ),
                          );
                        }),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                color: Colors.lightBlueAccent,
                                onPressed: () {
                                  editarUsuario(usuarioId);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                color: Colors.redAccent,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Confirmar Eliminación'),
                                        content: Text('¿Estás seguro de que deseas eliminar este usuario?'),
                                        actions: [
                                          TextButton(
                                            child: Text('Cancelar'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text('Eliminar'),
                                            onPressed: () {
                                              eliminarUsuario(usuario['C.I.']);
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                              if (editingUsuario != null && editingUsuario!['C.I.'] == usuarioId)
                                IconButton(
                                  icon: Icon(Icons.check),
                                  color: Colors.greenAccent,
                                  onPressed: () {
                                    guardarCambios();
                                  },
                                ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
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
