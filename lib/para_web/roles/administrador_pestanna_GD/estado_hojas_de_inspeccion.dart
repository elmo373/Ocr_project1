import 'package:flutter/material.dart';
import 'package:postgre_flutter/para_web/api_control.dart';
import 'package:url_launcher/url_launcher.dart';

class estado_hojas_de_inspeccion extends StatefulWidget {
  @override
  _estado_hojas_de_inspeccionState createState() => _estado_hojas_de_inspeccionState();
}

class _estado_hojas_de_inspeccionState extends State<estado_hojas_de_inspeccion> {
  List<Map<String, dynamic>> documentos = [];
  List<Map<String, dynamic>> estados = [];
  String consultaBusqueda = '';
  ScrollController controlScroll = ScrollController();
  final Map<String, String> titulosColumnas = {
    'Documento': 'Documento',
    'Registro': 'Registro',
    'Usuario': 'Usuario',
    'Nombre Empresa': 'Nombre de la Empresa',
    'Nombre Propietario': 'Nombre del Propietario',
    'Representante Legal': 'Representante Legal',
    'Cumple': 'Cumple',
    'Ubicación Depósito': 'Ubicación del Depósito',
    'Fecha Emisión': 'Fecha de Emisión',
    'PDF': 'PDF',
    'Estado': 'Estado',
  };

  @override
  void initState() {
    super.initState();
    obtenerDocumentos();
    obtenerEstados();
  }

  void obtenerDocumentos() async {
    documentos = await api_control.obtenerDatosinspeccion();
    setState(() {});
  }

  void obtenerEstados() async {
    estados = await api_control.obtenerEstadoDeDocumentoDeInspeccion();
    setState(() {});
  }

  void cambiar_estado (id) async {
    await api_control.cambiarEstadoDocumentoInspeccion(id);
    obtenerEstados();
  }

  String getEstadoById(String idDoc) {
    final estadoDoc = estados.firstWhere(
          (estado) => estado['id_doc'] == idDoc,
      orElse: () => {'id_doc': '', 'Estado': 'inactivo'},
    );
    return estadoDoc['Estado'];
  }

  List<Map<String, dynamic>> obtenerUsuariosFiltrados() {
    if (consultaBusqueda.isEmpty) {
      return documentos;
    } else {
      return documentos.where((documento) {
        return documento.values.any(
              (value) => value.toString().toLowerCase().contains(consultaBusqueda.toLowerCase()),
        );
      }).toList();
    }
  }

  void abrirEnlace(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuariosFiltrados = obtenerUsuariosFiltrados();

    return Scaffold(
      body: Container(
        color: Color.fromRGBO(3, 72, 128, 1),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Text(
              'Estado de hojas de inspección',
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
                        hintStyle: TextStyle(color: Colors.white),
                        hintText: 'Escriba su búsqueda aquí...',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Theme(
                data: ThemeData(
                  dividerColor: Colors.blue,
                ),
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
                        rows: usuariosFiltrados.map(
                              (Map<String, dynamic> usuario) {
                            return DataRow(
                              color: MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> estados) {
                                  return Colors.grey[350]!;
                                },
                              ),
                              cells: titulosColumnas.keys.map(
                                    (String clave) {
                                  if (clave == 'PDF') {
                                    return DataCell(
                                      ElevatedButton(
                                        child: Text('Abrir PDF'),
                                        onPressed: () => abrirEnlace(usuario[clave].toString()),
                                      ),
                                      showEditIcon: false,
                                    );
                                  } else if (clave == 'Estado') {
                                    final estado = getEstadoById(usuario['Documento']);
                                    return DataCell(
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: estado == 'activo' ? Colors.green : Colors.red,
                                        ),
                                        child: Text(estado),
                                        onPressed: () {
                                          cambiar_estado(usuario['Documento']);
                                        },
                                      ),
                                      showEditIcon: false,
                                    );
                                  } else {
                                    return DataCell(
                                      Text(
                                        usuario[clave]?.toString() ?? '',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      showEditIcon: false,
                                    );
                                  }
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
                            return Color.fromRGBO(53, 122, 178, 1);
                          },
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
