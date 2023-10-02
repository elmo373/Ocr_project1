import 'package:flutter/material.dart';
import 'package:postgre_flutter/para_windows/base_de_datos_control.dart';

class lista_usuarios extends StatefulWidget {
  @override
  _lista_usuariosState createState() => _lista_usuariosState();
}

class _lista_usuariosState extends State<lista_usuarios> {
  List<Map<String, dynamic>> usuarios = [];
  String consultaBusqueda = '';
  String nombreTabla = 'usuarios';
  Map<String, dynamic>? usuarioEditando;
  ScrollController controlScroll = ScrollController();

  final Map<String, String> titulosColumnas = {
    'C.I.': 'C.I.',
    'Nombre': 'Nombre',
    'Contraseña': 'Contraseña',
    'Correo Electrónico': 'Correo Electrónico',
    'Rol': 'Rol',
    'Fecha de Registro': 'Fecha de Registro',
    'Numero de Telefono': 'Número de Teléfono'
  };

  @override
  void initState() {
    super.initState();
    cargarUsuarios();
  }

  void cargarUsuarios() async {
    usuarios = await base_de_datos_control.obtenerDatos(nombreTabla);
    setState(() {});
  }

  List<Map<String, dynamic>> obtenerUsuariosFiltrados() {
    if (consultaBusqueda.isEmpty) {
      return usuarios;
    } else {
      return usuarios.where((usuario) {
        return usuario.values.any(
                (value) => value.toString().toLowerCase().contains(consultaBusqueda.toLowerCase()));
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
      'Fecha de Registro': 230.0,
      'Numero de Telefono': 260.0
    };

    return Scaffold(
      body: Container(
        color: Color.fromRGBO(3, 72, 128, 1),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Text(
              'Lista de usuarios',
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
                      onChanged: (valor) => setState(() => consultaBusqueda = valor),
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
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minWidth: 1000),
                          child: usuariosFiltrados.isNotEmpty
                              ? Theme(
                            data: Theme.of(context).copyWith(
                              dividerColor: Colors.black, // Color de las líneas divisorias cambiado a negro
                              canvasColor: Color.fromRGBO(53, 122, 178, 1),
                            ),
                            child: DataTable(
                              columns: titulosColumnas.keys.map(
                                    (String key) {
                                  final width = columnWidths[key];
                                  return DataColumn(
                                    label: Container(
                                      width: width,
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
                                  );
                                },
                              ).toList(),
                              rows: usuariosFiltrados.map(
                                    (Map<String, dynamic> usuario) {
                                  return DataRow(
                                    color: MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> estados) {
                                        return Colors.grey[350]!;  // Color para las filas de datos
                                      },
                                    ),
                                    cells: usuario.keys.map(
                                          (String clave) {
                                        final valorCelda = '${usuario[clave]}';
                                        return DataCell(
                                          Container(
                                            width: columnWidths[clave],
                                            alignment: Alignment.centerLeft,
                                            decoration: BoxDecoration(
                                              border: Border(
                                                right: BorderSide(color: Colors.black, width: 1.0),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                valorCelda,
                                                style: TextStyle(color: Colors.black),
                                              ),
                                            ),
                                          ),
                                          showEditIcon: false,
                                        );
                                      },
                                    ).toList(),
                                  );
                                },
                              ).toList(),
                              dividerThickness: 1.0,
                              horizontalMargin: 10.0,
                              columnSpacing: 10.0,
                              dataRowHeight: 45.0,
                              headingRowColor: MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                  return Color.fromRGBO(53, 122, 178, 1); // Color para el encabezado
                                },
                              ),
                            ),
                          )
                              : Container(),
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
