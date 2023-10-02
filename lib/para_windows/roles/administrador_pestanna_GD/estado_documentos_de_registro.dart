import 'package:flutter/material.dart';
import 'package:postgre_flutter/para_windows/base_de_datos_control.dart';
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
  bool datosCargados = false;

  Map<String, String> titulosColumnas = {
    'Documento': 'Documento',
    'Usuario': 'Usuario',
    'Nombre Empresa': 'Nombre Empresa',
    'Fecha Emisión': 'Fecha Emisión',
    'Representante Legal': 'Representante Legal',
    'Nombre Propietario': 'Nombre Propietario',
    'PDF': 'PDF',
  };

  @override
  void initState() {
    super.initState();
    obtenerDocumentos();
    obtenerEstados();
  }

  void obtenerDocumentos() async {
    try {
      documentos = await base_de_datos_control.obtenerDatosregistro();
      if(estados.isNotEmpty) {
        datosCargados = true;
      }
      setState(() {});
    } catch (error) {
      print('Error obteniendo documentos: $error');
    }
  }

  void obtenerEstados() async {
    try {
      estados = await base_de_datos_control.obtenerEstadoDeRegistro();
      if(documentos.isNotEmpty) {
        datosCargados = true;
      }
      setState(() {});
    } catch (error) {
      print('Error obteniendo estados: $error');
    }
  }


  Future<void> cambiarEstadoRegistro(String ci) async {
    await base_de_datos_control.cambiarEstadoRegistro(ci);
    obtenerEstados();
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
    final Map<String, double> columnWidths = {
      'Documento': 180.0,
      'Usuario': 150.0,
      'Nombre Empresa': 280.0,
      'Fecha Emisión': 230.0,
      'Representante Legal': 320.0,
      'Nombre Propietario': 310.0,
      'PDF': 125.0,
    };

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
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.black,
                        canvasColor: Color.fromRGBO(53, 122, 178, 1),
                      ),
                      child: usuariosFiltrados.isNotEmpty
                          ? DataTable(
                        columns: [
                          ...titulosColumnas.keys.map(
                                (String key) => DataColumn(
                              label: Container(
                                width: columnWidths[key],  // Aquí aplicamos el ancho
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
                            label: Container(
                              // Este es un caso especial para la columna 'Estado'. Puedes ajustar el ancho como necesites.
                              width: 100.0,
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(color: Colors.black, width: 1.0),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Estado',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                        rows: usuariosFiltrados.map<DataRow>((documento) {
                          List<DataCell> cells = [];
                          for (var key in titulosColumnas.keys) {
                            if (documento.containsKey(key)) {
                              if (key == 'PDF') {
                                cells.add(
                                  DataCell(
                                    Container(
                                      width: columnWidths[key],  // Aquí aplicamos el ancho
                                      decoration: BoxDecoration(
                                        border: Border(
                                          right: BorderSide(color: Colors.black, width: 1.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          child: Text('Abrir PDF'),
                                          onPressed: () => abrirEnlace(documento[key]),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                cells.add(
                                  DataCell(
                                    Container(
                                      width: columnWidths[key],  // Asegúrate de tener un valor para cada clave.
                                      alignment: Alignment.centerLeft,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          right: BorderSide(color: Colors.black, width: 1.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          documento[key].toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    showEditIcon: false,
                                  ),
                                );
                              }
                            }
                          }

                          cells.add(
                            DataCell(
                              Container(
                                width: 100.0,
                                decoration: BoxDecoration(
                                  border: Border(
                                    right: BorderSide(color: Colors.black, width: 1.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Switch(
                                    value: datosCargados ?
                                    estados.firstWhere(
                                            (estado) => estado['Documento'] == documento['Documento'],
                                        orElse: () => {'Estado': 'activo'}
                                    )['Estado'] == 'activo'
                                        : true,  // Si los datos no están cargados, por defecto será true (activo)
                                    onChanged: (value) async {
                                      setState(() {
                                        estados.firstWhere((estado) => estado['Documento'] == documento['Documento'])['Estado'] = value ? 'activo' : 'inactivo';
                                      });
                                      await cambiarEstadoRegistro(documento['Documento']);
                                    },
                                    activeColor: Colors.green,
                                    inactiveThumbColor: Colors.red,
                                    activeTrackColor: Colors.green[200],
                                    inactiveTrackColor: Colors.red[200],
                                  ),
                                ),
                              ),
                            ),

                          );

                          // Verificación
                          assert(cells.length == titulosColumnas.length + 1);  // +1 por la columna 'Estado'

                          return DataRow(
                            color: MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> estados) {
                                  return Colors.grey[350]!;
                                }),
                            cells: cells,
                          );
                        }).toList(),
                        dividerThickness: 1.0,
                        horizontalMargin: 10.0,
                        columnSpacing: 10.0,
                        dataRowHeight: 45.0,
                        headingRowColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> estados) {
                              return Color.fromRGBO(53, 122, 178, 1);
                            }),
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
