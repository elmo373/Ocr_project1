import 'package:flutter/material.dart';
import '../base_de_datos_control.dart';

void main(){
  runApp(WindowsPersonalListaDeUsuarios());
}

class WindowsPersonalListaDeUsuarios extends StatelessWidget {
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
                    DataColumn(
                      label: Text(
                        'Nombre',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Correo Electronico',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Telefono',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                  rows: filteredUsuarios.map((Map<String, dynamic> usuario) {
                    // Reemplaza con el identificador único del usuario

                    return DataRow(
                      cells: [
                        DataCell(
                          Text(
                            '${usuario['Nombre']}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DataCell(
                          Text(
                            '${usuario['Correo Electrónico']}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DataCell(
                          Text(
                            '${usuario['Numero de Telefono']}',
                            style: TextStyle(color: Colors.white),
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
