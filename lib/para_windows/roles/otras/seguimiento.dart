import 'package:flutter/material.dart';
import 'package:postgre_flutter/para_windows/base_de_datos_control.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeline_tile/timeline_tile.dart';

class seguimiento extends StatefulWidget {
  @override
  _seguimientoState createState() => _seguimientoState();
}

class _seguimientoState extends State<seguimiento> {
  List<Map<String, dynamic>> datosConsolidados = [];
  String consultaBusqueda = '';
  ScrollController controlScroll = ScrollController();
  Map<String, String> titulosColumnas = {
    'Nombre Empresa': 'Nombre Empresa',
    'Fecha Emisión Inspección': 'Fecha Emisión Inspección',
    'PDF Inspección': 'PDF Inspección',
    'Fecha Emisión Registro': 'Fecha Emisión Registro',
    'PDF Registro': 'PDF Registro',
    'Fecha Registro Usuario': 'Fecha Registro Usuario',
    'Línea de Tiempo': 'Línea de Tiempo',
  };

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    datosConsolidados = await obtenerDatosConsolidados();
    setState(() {});
  }

  Future<List<Map<String, dynamic>>> obtenerDatosConsolidados() async {
    List<Map<String, dynamic>> inspecciones = await base_de_datos_control.obtenerDatosinspeccion();
    List<Map<String, dynamic>> registros = await base_de_datos_control.obtenerDatosregistro();
    List<Map<String, dynamic>> usuarios = await base_de_datos_control.obtenerDatos('usuarios');

    Map<String, Map<String, dynamic>> consolidado = {};

    for (var inspeccion in inspecciones) {
      var empresa = inspeccion['Nombre Empresa'];

      var registro = registros.firstWhere((r) => r['Nombre Empresa'] == empresa, orElse: () => {});
      var usuario = usuarios.firstWhere((u) => u['Nombre'] == empresa, orElse: () => {});

      var fechaInspeccion = DateTime.tryParse(inspeccion['Fecha Emisión'] ?? '');
      var fechaExistente = consolidado[empresa] != null ? DateTime.tryParse(consolidado[empresa]?['Fecha Emisión Inspección'] ?? '') : null;

      if (consolidado[empresa] == null || (fechaInspeccion != null && fechaExistente != null && fechaInspeccion.isAfter(fechaExistente))) {
        var estadoInspeccion = 'Activo';
        var estadoRegistro = 'Activo';

        consolidado[empresa] = {
          'Nombre Empresa': empresa,
          'Fecha Emisión Inspección': inspeccion['Fecha Emisión'] ?? 'N/A',
          'PDF Inspección': inspeccion['PDF'],
          'Estado Inspección': estadoInspeccion,
          'Cumple': inspeccion['Cumple'],
          'Fecha Emisión Registro': registro['Fecha Emisión'] ?? 'N/A',
          'PDF Registro': registro['PDF'],
          'Estado Registro': estadoRegistro,
          'Fecha Registro Usuario': usuario['Fecha de Registro'] ?? 'N/A',
          'Línea de Tiempo': 'Ver Línea de Tiempo',
        };
      }
    }

    List<Map<String, dynamic>> sortedList = consolidado.values.toList()
      ..sort((a, b) {
        DateTime dateA = DateTime.parse(a['Fecha Emisión Inspección'] ?? '');
        DateTime dateB = DateTime.parse(b['Fecha Emisión Inspección'] ?? '');

        if (dateA != null && dateB != null) {
          return dateA.compareTo(dateB);
        } else if (dateA != null) {
          return -1;
        } else if (dateB != null) {
          return 1;
        }
        return 0;
      });

    return sortedList;
  }

  void abrirEnlace(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir $url';
    }
  }

  void mostrarGrafica(Map<String, dynamic> dato) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Línea de Tiempo para ${dato['Nombre Empresa']}'),
          content: Container(
            height: 200,
            width: 300,
            child: ListView(
              children: [
                TimelineTile(
                  alignment: TimelineAlign.manual,
                  lineXY: 0.3,
                  isFirst: true,
                  indicatorStyle: IndicatorStyle(
                      width: 20,
                      color: (dato['Estado Inspección'] == 'Activo' && dato['Cumple'] == 'Si') ? Colors.blue : Colors.red
                  ),
                  endChild: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Fecha Emisión Inspección: ${dato['Fecha Emisión Inspección']}'),
                  ),
                ),
                TimelineTile(
                  alignment: TimelineAlign.manual,
                  lineXY: 0.3,
                  indicatorStyle: IndicatorStyle(width: 20, color: dato['Estado Registro'] == 'Activo' ? Colors.blue : Colors.red),
                  endChild: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Fecha Emisión Registro: ${dato['Fecha Emisión Registro']}'),
                  ),
                ),
                TimelineTile(
                  alignment: TimelineAlign.manual,
                  lineXY: 0.3,
                  isLast: true,
                  endChild: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Fecha Registro Usuario: ${dato['Fecha Registro Usuario']}'),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final Map<String, double> columnWidths = {
      'Nombre Empresa': 280.0,
      'Fecha Emisión Inspección': 330.0,
      'PDF Inspección': 220.0,
      'Fecha Emisión Registro': 330.0,
      'PDF Registro': 220.0,
      'Fecha Registro Usuario': 330.0,
      'Línea de Tiempo': 250.0,
    };

    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 72, 128, 1),  // Cambio de color aquí
      body: Column(
        children: [
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
                            ],
                            rows: datosConsolidados.map(
                                  (Map<String, dynamic> dato) {
                                return DataRow(
                                  color: MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                      return Colors.grey[350]!;
                                    },
                                  ),
                                  cells: titulosColumnas.keys.map(
                                        (String clave) {
                                      final valorCelda = '${dato[clave] ?? 'N/A'}';
                                      if (clave == 'PDF Inspección' || clave == 'PDF Registro') {
                                        return DataCell(
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            decoration: BoxDecoration(
                                              border: Border(
                                                right: BorderSide(color: Colors.black, width: 1.0),
                                              ),
                                            ),
                                            child: ElevatedButton(
                                              child: Text('Abrir PDF'),
                                              onPressed: () => abrirEnlace(dato[clave].toString()),
                                            ),
                                          ),
                                          showEditIcon: false,
                                        );
                                      } else if (clave == 'Línea de Tiempo') {
                                        return DataCell(
                                          ElevatedButton(
                                            child: Text('Ver Línea de Tiempo'),
                                            onPressed: () => mostrarGrafica(dato),
                                          ),
                                          showEditIcon: false,
                                        );
                                      } else {
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
            ),
          ),

        ],
      ),
    );
  }
}
