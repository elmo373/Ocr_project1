import 'package:flutter/material.dart';
import 'package:postgre_flutter/para_windows/base_de_datos_control.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:postgre_flutter/Encriptacion.dart';
import 'package:postgres/postgres.dart';
import 'package:postgre_flutter/para_windows/base_de_datos_control.dart';

class estados_de_usuarios extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EstadoUsuarioPage(),
    );
  }
}

class EstadoUsuarioPage extends StatefulWidget {
  @override
  _EstadoUsuarioPageState createState() => _EstadoUsuarioPageState();
}

class _EstadoUsuarioPageState extends State<EstadoUsuarioPage> {
  final roles = ['administrador', 'personal_regular', 'tecnico', 'interesado_en_el_registro'];
  final Map<String, Map<String, int>> countByRol = {};

  @override
  void initState() {
    super.initState();
    actualizarEstadoDeUsuarios();
  }

  void actualizarEstadoDeUsuarios() async {
    final connection = PostgreSQLConnection(
      base_de_datos_control.Coneccion,
      5432,
      'ocrdb',
      username: 'emanuel',
      password: 'emi77',
    );

    try {
      await connection.open();

      for (var rol in roles) {
        countByRol[rol] = {'Total': 0, 'Activos': 0, 'Inactivos': 0};

        final result = await connection.query('SELECT * FROM usuarios WHERE rol = @rol',
            substitutionValues: {'rol': AESCrypt.encriptar(rol)});

        for (var row in result) {
          final idCi = AESCrypt.desencriptar(row[0].toString());

          final estadoResult = await connection.query('SELECT * FROM estado WHERE id_ci = @id',
              substitutionValues: {'id': AESCrypt.encriptar(idCi)});

          if (estadoResult.isNotEmpty) {
            final estado = estadoResult.first[1].toString();

            countByRol[rol]!['Total'] = (countByRol[rol]?['Total'] ?? 0) + 1;
            if (estado == 'activo') {
              countByRol[rol]?['Activos'] = (countByRol[rol]?['Activos'] ?? 0) + 1;
            } else {
              countByRol[rol]?['Inactivos'] = (countByRol[rol]?['Inactivos'] ?? 0) + 1;
            }
          }
        }
      }

      print('Estado de los usuarios actualizado correctamente');
    } catch (e) {
      print('Error en la conexión a PostgreSQL: $e');
    } finally {
      await connection.close();
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 72, 128, 1),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return ListView(
            children: roles.map((rol) {
              final cambio_rol = base_de_datos_control.Vista_de_rol(rol);
              List<ChartData> chartData = [];
              if (countByRol[rol] != null) {
                chartData = countByRol[rol]!.entries.map((e) => ChartData(e.key, e.value)).toList();
              }
              return Container(
                height: constraints.maxHeight > 500 ? 500 : constraints.maxHeight * 0.9,
                width: constraints.maxWidth * 0.9,
                child: Column(
                  children: [
                    Text(
                      'Estado de los usuarios',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('Rol: $cambio_rol', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    SfCartesianChart(
                      backgroundColor: Color.fromRGBO(53, 122, 178, 1),
                      primaryXAxis: CategoryAxis(
                        majorGridLines: MajorGridLines(color: Color.fromRGBO(0, 15, 65, 1.0)),
                        axisLine: AxisLine(color: Color.fromRGBO(0, 15, 65, 1.0)),
                        labelStyle: TextStyle(color: Color.fromRGBO(0, 15, 65, 1.0), fontSize: 20),
                      ),
                      primaryYAxis: NumericAxis(
                        title: AxisTitle(
                          text: 'Cantidad',
                          textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromRGBO(0, 15, 65, 1.0)),
                        ),
                        majorGridLines: MajorGridLines(color: Color.fromRGBO(0, 15, 65, 1.0)),
                        axisLine: AxisLine(color: Color.fromRGBO(0, 15, 65, 1.0)),
                        labelStyle: TextStyle(color: Color.fromRGBO(0, 15, 65, 1.0), fontSize: 20),
                      ),
                      series: <ChartSeries>[
                        // Serie para "Total"
                        ColumnSeries<ChartData, String>(
                          name: 'Total',
                          dataSource: chartData.where((data) => data.estado == 'Total').toList(),
                          xValueMapper: (ChartData estado, _) => estado.estado,
                          yValueMapper: (ChartData estado, _) => estado.cantidad,
                          color: Colors.lightGreenAccent,
                          dataLabelSettings: DataLabelSettings(
                            isVisible: true,
                            textStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromRGBO(0, 15, 65, 1.0)),
                          ),
                        ),
                        // Serie para "Activos"
                        ColumnSeries<ChartData, String>(
                          name: 'Activos',
                          dataSource: chartData.where((data) => data.estado == 'Activos').toList(),
                          xValueMapper: (ChartData estado, _) => estado.estado,
                          yValueMapper: (ChartData estado, _) => estado.cantidad,
                          color: Colors.orange,
                          dataLabelSettings: DataLabelSettings(
                            isVisible: true,
                            textStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromRGBO(0, 15, 65, 1.0)),
                          ),
                        ),
                        // Serie para "Inactivos"
                        ColumnSeries<ChartData, String>(
                          name: 'Inactivos',
                          dataSource: chartData.where((data) => data.estado == 'Inactivos').toList(),
                          xValueMapper: (ChartData estado, _) => estado.estado,
                          yValueMapper: (ChartData estado, _) => estado.cantidad,
                          color: Colors.red,
                          dataLabelSettings: DataLabelSettings(
                            isVisible: true,
                            textStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromRGBO(0, 15, 65, 1.0)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class ChartData {
  final String estado;
  final int cantidad;

  ChartData(this.estado, this.cantidad);
}
