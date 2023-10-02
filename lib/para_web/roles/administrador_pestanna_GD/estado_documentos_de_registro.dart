import 'package:flutter/material.dart';
import 'package:postgre_flutter/para_web/api_control.dart';
import 'package:url_launcher/url_launcher.dart';

class estado_documentos_de_registro extends StatefulWidget {
  @override
  _estado_documentos_de_registroState createState() =>
      _estado_documentos_de_registroState();
}

class _estado_documentos_de_registroState
    extends State<estado_documentos_de_registro> {
  List<Map<String, dynamic>> documentos = [];
  List<Map<String, dynamic>> estados = [];
  String consultaBusqueda = '';
  ScrollController controlScroll = ScrollController();

  @override
  void initState() {
    super.initState();
    obtenerDocumentos();
    obtenerEstados();
  }

  void obtenerDocumentos() async {
    documentos = await api_control.obtenerDatosregistro();
    setState(() {});
  }

  void obtenerEstados() async {
    estados = await api_control.obtenerEstadoDeRegistro();
    setState(() {});
  }
  
  void cambiar_estado (id) async {
    await api_control.cambiarEstadoRegistro(id);
    obtenerEstados();
  }

  String getEstadoById(String idDoc) {
    final estadoDoc = estados.firstWhere(
            (estado) => estado['id_doc'] == idDoc,
        orElse: () => {'id_doc': '', 'Estado': 'inactivo'});
    return estadoDoc['Estado'];
  }

  List<Map<String, dynamic>> obtenerUsuariosFiltrados() {
    if (consultaBusqueda.isEmpty) {
      return documentos;
    } else {
      return documentos.where((documento) {
        return documento.values.any((value) =>
            value.toString().toLowerCase().contains(consultaBusqueda.toLowerCase()));
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
    final columnas = documentos.isNotEmpty
        ? documentos[0].keys.where((key) => key != "RUC" && key != "Actividad Principal").toList()
        : [];

    return Scaffold(
      body: Container(
        color: Color.fromRGBO(3, 72, 128, 1),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Text(
              'Estado de documentos de registro',
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
              child: Theme(
                data: ThemeData(
                  dividerColor: Color.fromRGBO(3, 72, 128, 1),
                ),
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
                          child: DataTable(
                            columns: [
                              for (var key in columnas)
                                DataColumn(
                                  label: Text(
                                    key,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              DataColumn(
                                label: Text(
                                  'Estado',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                            rows: usuariosFiltrados.map<DataRow>((documento) {
                              List<DataCell> cells = [];
                              for (var key in columnas) {
                                if (key == 'PDF') {
                                  cells.add(
                                    DataCell(
                                      ElevatedButton(
                                        child: Text('Abrir PDF'),
                                        onPressed: () =>
                                            abrirEnlace(documento[key]),
                                      ),
                                    ),
                                  );
                                } else {
                                  cells.add(
                                    DataCell(
                                      Text(documento[key].toString()),
                                    ),
                                  );
                                }
                              }
                              final estado = getEstadoById(documento['Documento']);
                              cells.add(
                                DataCell(
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: estado == 'activo'
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                    child: Text(estado),
                                    onPressed: () async {
                                      cambiar_estado(documento['Documento']);
                                    },
                                  ),
                                ),
                              );

                              return DataRow(
                                color: MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> estados) {
                                    return Colors.grey[350]!;
                                  },
                                ),
                                cells: cells,
                              );
                            }).toList(),
                            dividerThickness: 1.0,
                            horizontalMargin: 10.0,
                            columnSpacing: 10.0,
                            dataRowHeight: 45.0,
                            headingRowColor: MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> estados) {
                                return Color.fromRGBO(53, 122, 178, 1);  // Color para el encabezado
                              },
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
