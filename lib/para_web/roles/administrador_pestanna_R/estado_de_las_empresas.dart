import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:postgre_flutter/Base de datos/actualizacion_general.dart';
import 'package:postgre_flutter/para_web/api_control.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:postgre_flutter/Encriptacion.dart';
import 'package:http/http.dart' as http;

class estado_empresa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EstadoEmpresaPage(),
    );
  }
}

class EstadoEmpresaPage extends StatefulWidget {
  @override
  _EstadoEmpresaPageState createState() => _EstadoEmpresaPageState();
}

class _EstadoEmpresaPageState extends State<EstadoEmpresaPage> {
  final Map<String, int> countByEstado = {
    'Registro activo': 0,
    'Registro anulado': 0,
    'Registro caducado': 0,
    'Registro en proceso': 0,  // Nuevo estado
    'Registro en observación': 0,  // Nuevo estado
  };

  final Link = api_control.BASE_URL;

  @override
  void initState() {
    super.initState();
    EstadoDeEmpresas();
  }

  void EstadoDeEmpresas() async {
    await actualizacion_general.cambios();
    final actualizarEstadoDeEmpresa = '$Link/query/EstadoDeEmpresas';
    final response = await http.get(Uri.parse(actualizarEstadoDeEmpresa));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      List<Map<String, dynamic>> empresas = jsonData.map<Map<String, dynamic>>((row) {
        return {
          'id_empresa': AESCrypt.desencriptar(row['id_empresa']),
          'estado_de_la_empresa': AESCrypt.desencriptar(row['estado_de_la_empresa']),
          'nombre': AESCrypt.desencriptar(row['nombre']),
          'razon': AESCrypt.desencriptar(row['razon']),
        };
      }).toList();

      empresas.forEach((empresa) {
        if (countByEstado.containsKey(empresa['estado_de_la_empresa'])) {
          countByEstado[empresa['estado_de_la_empresa']] = (countByEstado[empresa['estado_de_la_empresa']] ?? 0) + 1;
        }
      });

      if (mounted) {
        setState(() {});
      }
    } else {
      print('Error en la solicitud obtenerEstadoDeRegistro HTTP: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<ChartData> chartData = countByEstado.entries.map((e) => ChartData(e.key, e.value)).toList();

    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 72, 128, 1),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return ListView(
            children: [
              Text(
                'Gráfica de las empresas',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: constraints.maxHeight * 0.05),
                height: constraints.maxHeight > 500 ? 500 : constraints.maxHeight * 0.9,
                width: constraints.maxWidth * 0.9,
                child: Center(
                  child: SfCartesianChart(
                    backgroundColor: Color.fromRGBO(53, 122, 178, 1),
                    primaryXAxis: CategoryAxis(
                      majorGridLines: MajorGridLines(color: Color.fromRGBO(0, 15, 65, 1.0)),
                      axisLine: AxisLine(color: Color.fromRGBO(0, 15, 65, 1.0)),
                      labelStyle: TextStyle(color: Color.fromRGBO(0, 15, 65, 1.0), fontSize: 20),
                    ),
                    primaryYAxis: NumericAxis(
                      majorGridLines: MajorGridLines(color: Color.fromRGBO(0, 15, 65, 1.0)),
                      axisLine: AxisLine(color: Color.fromRGBO(0, 15, 65, 1.0)),
                      labelStyle: TextStyle(color: Color.fromRGBO(0, 15, 65, 1.0)),
                    ),
                    series: <ChartSeries>[
                      ColumnSeries<ChartData, String>(
                        dataSource: chartData,
                        xValueMapper: (ChartData estado, _) => estado.estado,
                        yValueMapper: (ChartData estado, _) => estado.cantidad,
                        pointColorMapper: (ChartData estado, _) => getColor(estado),
                        dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                          textStyle: TextStyle(
                            color: Color.fromRGBO(0, 15, 65, 1.0),
                            fontWeight: FontWeight.bold,
                            fontSize: 22,  // Tamaño aumentado en 2
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Una función para asignar colores a las columnas
  Color getColor(ChartData estado) {
    if (estado.estado == "Registro activo") {
      return Colors.red;
    } else if (estado.estado == "Registro anulado") {
      return Colors.green;
    } else if (estado.estado == "Registro en proceso") { // Nuevo estado
      return Colors.yellow; // Puedes cambiar el color
    } else if (estado.estado == "Registro en observación") { // Nuevo estado
      return Colors.orange; // Puedes cambiar el color
    } else {
      return Colors.blue;
    }
  }
}

class ChartData {
  final String estado;
  final int cantidad;

  ChartData(this.estado, this.cantidad);
}
