import 'package:flutter/material.dart';
import 'package:postgre_flutter/para_web/api_control.dart';

class lista_de_usuarios_otros extends StatefulWidget {
  @override
  _lista_de_usuarios_otrosState createState() => _lista_de_usuarios_otrosState();
}

class _lista_de_usuarios_otrosState extends State<lista_de_usuarios_otros> {
  List<Map<String, dynamic>> usuarios = [];
  List<Map<String, dynamic>> estados = [];
  String searchQuery = '';
  String nombre_de_tabla = 'usuarios';
  ScrollController _scrollController = ScrollController();

  final Map<String, String> titulosColumnas = {
    'Nombre': 'Nombre',
    'Correo Electrónico': 'Correo Electrónico',
    'Numero de Telefono': 'Número de Teléfono'
  };

  @override
  void initState() {
    super.initState();
    obtenerUsuarios();
  }

  void obtenerUsuarios() async {
    usuarios = await api_control.obtenerDatos(nombre_de_tabla);
    estados = await api_control.obtenerEstadolista();
    usuarios = usuarios.where((usuario) {
      final ci = usuario['C.I.'];
      final estadoUsuario = estados.firstWhere((estado) => estado['C.I.'] == ci);
      return estadoUsuario['Estado'] == 'activo';
    }).toList();
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
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Text(
              'Lista de usuarios activos',
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
              child: Scrollbar(
                isAlwaysShown: true,
                controller: _scrollController,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minWidth: 1000),
                          child: filteredUsuarios.isNotEmpty
                              ? Theme(
                            data: Theme.of(context).copyWith(
                              dividerColor: Color.fromRGBO(53, 122, 178, 1),
                              canvasColor: Color.fromRGBO(53, 122, 178, 1),
                            ),
                            child: DataTable(
                              columns: titulosColumnas.keys.map(
                                    (String key) => DataColumn(
                                  label: Text(
                                    titulosColumnas[key]!,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ).toList(),
                              rows: filteredUsuarios.map(
                                    (Map<String, dynamic> usuario) {
                                  return DataRow(
                                    color: MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                        return Colors.grey[350]!;  // Color para las filas de datos
                                      },
                                    ),
                                    cells: titulosColumnas.keys.map(
                                          (String key) {
                                        final cellValue = '${usuario[key]}';
                                        return DataCell(
                                          Text(
                                            cellValue,
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        );
                                      },
                                    ).toList(),
                                  );
                                },
                              ).toList(),
                            ),
                          )
                              : Container(
                            child: Center(
                              child: Text(
                                "",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
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
