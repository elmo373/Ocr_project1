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

    List<Map<String, dynamic>> consolidado = [];
    for (var inspeccion in inspecciones) {
      var empresa = inspeccion['Nombre Empresa'];
      var registro = registros.firstWhere((r) => r['Nombre Empresa'] == empresa, orElse: () => {});
      var usuario = usuarios.firstWhere((u) => u['Nombre'] == empresa, orElse: () => {});

      consolidado.add({
        'Nombre Empresa': empresa,
        'Fecha Emisión Inspección': inspeccion['Fecha Emisión'] ?? 'N/A',
        'PDF Inspección': inspeccion['PDF'],
        'Fecha Emisión Registro': registro['Fecha Emisión'] ?? 'N/A',
        'PDF Registro': registro['PDF'],
        'Fecha Registro Usuario': usuario['Fecha de Registro'] ?? 'N/A',
        'Línea de Tiempo': 'Ver Línea de Tiempo',  // Aquí se ha añadido la línea de tiempo
      });
    }

    return consolidado;
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
                  indicatorStyle: IndicatorStyle(width: 20),
                  endChild: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Fecha Emisión Inspección: ${dato['Fecha Emisión Inspección']}'),
                  ),
                ),
                TimelineTile(
                  alignment: TimelineAlign.manual,
                  lineXY: 0.3,
                  indicatorStyle: IndicatorStyle(width: 20),
                  endChild: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Fecha Emisión Registro: ${dato['Fecha Emisión Registro']}'),
                  ),
                ),
                TimelineTile(
                  alignment: TimelineAlign.manual,
                  lineXY: 0.3,
                  isLast: true,
                  indicatorStyle: IndicatorStyle(width: 20),
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
            child: Center(
              child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
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
                    rows: datosConsolidados.map(
                          (Map<String, dynamic> dato) {
                        return DataRow(
                          color: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> estados) {
                              return Colors.grey[350]!;  // Color para las filas de datos
                            },
                          ),
                          cells: titulosColumnas.keys.map(
                                (String clave) {
                              final valorCelda = '${dato[clave] ?? 'N/A'}';
                              if (clave == 'PDF Inspección' || clave == 'PDF Registro') {
                                return DataCell(
                                  ElevatedButton(
                                    child: Text('Abrir PDF'),
                                    onPressed: () => abrirEnlace(dato[clave].toString()),
                                  ),
                                  showEditIcon: false,
                                );
                              } else if (clave == 'Línea de Tiempo') {  // Esta es la nueva condición agregada
                                return DataCell(
                                  ElevatedButton(
                                    child: Text('Ver Línea de Tiempo'),
                                    onPressed: () => mostrarGrafica(dato),
                                  ),
                                  showEditIcon: false,
                                );
                              } else {
                                return DataCell(
                                  Text(
                                    valorCelda,
                                    style: TextStyle(color: Colors.black),
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
        ],
      ),
    );
  }
}
