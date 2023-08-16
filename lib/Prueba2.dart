import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:postgre_flutter/Encriptacion.dart';
import 'package:postgres/postgres.dart';
import 'dart:async';

void main() {
  runApp(EstadoEmpresaApp());
}

class EstadoEmpresaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      '35.225.248.224',
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

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<ChartData> chartData = countByEstado.entries.map((e) => ChartData(e.key, e.value)).toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent[700],
        title: Text('Estado de las empresas'),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return ListView(
            children: [
              Container(
                height: constraints.maxHeight > 500 ? 500 : constraints.maxHeight * 0.9,
                width: constraints.maxWidth * 0.9,
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  series: <ChartSeries>[
                    ColumnSeries<ChartData, String>(
                      dataSource: chartData,
                      xValueMapper: (ChartData estado, _) => estado.estado,
                      yValueMapper: (ChartData estado, _) => estado.cantidad,
                    )
                  ],
                ),
              ),
              // Añade aquí el widget para mostrar la tabla estado_empresa
            ],
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
