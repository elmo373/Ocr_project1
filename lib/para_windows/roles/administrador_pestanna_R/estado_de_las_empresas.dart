import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:postgre_flutter/Encriptacion.dart';
import 'package:postgres/postgres.dart';
import 'package:postgre_flutter/para_windows/base_de_datos_control.dart';

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
  final Map<String, int> countByEstado = {'Registro activo': 0, 'Registro anulado': 0, 'Registro caducado': 0};

  @override
  void initState() {
    super.initState();
    actualizarEstadoDeEmpresas();
  }

  void actualizarEstadoDeEmpresas() async {
    final connection = PostgreSQLConnection(
      base_de_datos_control.Coneccion,
      5432,
      'ocrdb',
      username: 'emanuel',
      password: 'emi77',
    );

    try {
      await connection.open();
      final result = await connection.query('SELECT * FROM documento_de_registro');

      for (var row in result) {
        final fechaEmision = DateTime.parse(AESCrypt.desencriptar(row[3].toString()));
        final nombreEmpresa = AESCrypt.desencriptar(row[2].toString());

        String nuevoEstado;
        String razon;
        if (DateTime.now().difference(fechaEmision).inDays > 365 * 2) {
          nuevoEstado = 'Registro caducado';
          razon = 'El registro caduco';
        } else {
          // Consiguiendo el último documento de inspección
          final inspecciones = await connection.query(
            'SELECT * FROM documento_de_inspeccion WHERE nombre_empresa = @nombre ORDER BY fecha_de_emision DESC LIMIT 1',
            substitutionValues: {'nombre': AESCrypt.encriptar(nombreEmpresa)},
          );
          if (inspecciones.isNotEmpty && AESCrypt.desencriptar(inspecciones.first[6].toString()) == 'No') {
            nuevoEstado = 'Registro anulado';
            razon = 'La última inspección no fue exitosa';
          } else {
            nuevoEstado = 'Registro activo';
            razon = 'Cumplió con todo';
          }
        }

        await connection.query('UPDATE estado_empresa SET estado_de_la_empresa = @estado, razon = @razon WHERE nombre = @nombre',
            substitutionValues: {
              'nombre': AESCrypt.encriptar(nombreEmpresa),
              'estado': AESCrypt.encriptar(nuevoEstado),
              'razon': AESCrypt.encriptar(razon)
            });

        countByEstado[nuevoEstado] = (countByEstado[nuevoEstado] ?? 0) + 1;
      }

      print('Estado de las empresas actualizado correctamente');
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
    List<ChartData> chartData = countByEstado.entries.map((e) => ChartData(e.key, e.value)).toList();

    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 72, 128, 1),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return ListView(
            children: [
              Text(
                'Grafica de las empresas',
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
