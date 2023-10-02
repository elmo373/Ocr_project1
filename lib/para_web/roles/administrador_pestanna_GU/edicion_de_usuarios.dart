import 'package:flutter/material.dart';
import 'package:postgre_flutter/para_web/roles/editarApi.dart';
import 'package:postgre_flutter/para_web/api_control.dart';

class edicion_de_usuario extends StatefulWidget {
  @override
  _edicion_de_usuarioState createState() => _edicion_de_usuarioState();
}

class _edicion_de_usuarioState extends State<edicion_de_usuario> {
  List<Map<String, dynamic>> usuarios = [];
  String consultaBusqueda = '';
  String nombre_de_tabla = 'usuarios';
  ScrollController controlScroll = ScrollController();

  final Map<String, String> titulosColumnas = {
    "C.I.": "C.I.",
    'Nombre': 'Nombre',
    'Contraseña': 'Contraseña',
    'Correo Electrónico': 'Correo Electrónico',
    'Rol': 'Rol',
    'Numero de Telefono': 'Número de Teléfono'
  };

  @override
  void initState() {
    super.initState();
    cargarUsuarios();
  }

  void cargarUsuarios() async {
    usuarios = await api_control.obtenerDatos(nombre_de_tabla);
    setState(() {});
  }

  void editarUsuario(String ci, dynamic dato) async {
    await api_control.editarDatos(nombre_de_tabla, ci, dato);
    cargarUsuarios(); // Actualizar la lista de usuarios después de la eliminación
  }

  List<Map<String, dynamic>> obtenerUsuariosFiltrados() {
    if (consultaBusqueda.isEmpty) {
      return usuarios;
    } else {
      return usuarios.where((usuario) {
        return usuario.values.any((value) => value.toString().toLowerCase().contains(consultaBusqueda.toLowerCase()));
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuariosFiltrados = obtenerUsuariosFiltrados();

    final Map<String, double> columnWidths = {
      'C.I.': 100.0,
      'Nombre': 300.0,
      'Contraseña': 180.0,
      'Correo Electrónico': 320.0,
      'Rol': 130.0,
      'Numero de Telefono': 300.0
    };

    return Scaffold(
      body: Container(
        color: Color.fromRGBO(3, 72, 128, 1),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Text(
              'Edición de usuarios',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              color: Color.fromRGBO(3, 72, 128, 1),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.search),
                    color: Colors.white,
                    onPressed: () {},
                  ),
                  Text(
                    'Buscar:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      onChanged: (value) => setState(() => consultaBusqueda = value),
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
              child: Scrollbar(
                isAlwaysShown: true,
                controller: controlScroll,
                child: SingleChildScrollView(
                  controller: controlScroll,
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minWidth: 1000),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              dividerColor: Colors.black,
                              canvasColor: Color.fromRGBO(53, 122, 178, 1),
                            ),
                            child: DataTable(
                              columns: [
                                ...titulosColumnas.keys.map(
                                      (String key) => DataColumn(
                                    label: Container(
                                      width: columnWidths[key], // Asumo que tienes un mapa similar al anterior para los anchos
                                      alignment: Alignment.centerLeft,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          right: BorderSide(color: Colors.black, width: 1.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          titulosColumnas[key]!,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Editar',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                              rows: obtenerUsuariosFiltrados().map((usuario) {
                                return DataRow(
                                  color: MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                      return Colors.grey[350]!;
                                    },
                                  ),
                                  cells: [
                                    ...titulosColumnas.keys.map(
                                          (String key) => DataCell(
                                        Container(
                                          width: columnWidths[key],
                                          alignment: Alignment.centerLeft,
                                          decoration: BoxDecoration(
                                            border: Border(
                                              right: BorderSide(color: Colors.black, width: 1.0),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              usuario[key].toString(),
                                              style: TextStyle(color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        color: Color.fromRGBO(255, 184, 0, 1.0),
                                        onPressed: () {
                                          Editores editores = Editores();
                                          editores.Editar(context, nombre_de_tabla, editarUsuario, usuario['C.I.']);
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                              dividerThickness: 1.0,
                              horizontalMargin: 10.0,
                              columnSpacing: 10.0,
                              dataRowHeight: 45.0,
                              headingRowColor: MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                  return Color.fromRGBO(53, 122, 178, 1);
                                },
                              ),
                            ),
                          ),
                        )
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
