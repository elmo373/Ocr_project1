import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:postgre_flutter/Encriptacion.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:postgre_flutter/para_windows/base_de_datos_control.dart';

class depositos_por_departamento extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DepositosPorDepartamentoPage(),
    );
  }
}

class DepositosPorDepartamentoPage extends StatefulWidget {
  @override
  _DepositosPorDepartamentoPageState createState() => _DepositosPorDepartamentoPageState();
}

class _DepositosPorDepartamentoPageState extends State<DepositosPorDepartamentoPage> {
  Map<String, int> depositosPorDepartamento = {};
  Map<String, Map<String, String>> ultimaFechaPorCiudad = {};

  @override
  void initState() {
    super.initState();
    consultarDepositosPorDepartamento();
  }

  void consultarDepositosPorDepartamento() async {
    final connection = PostgreSQLConnection(
      base_de_datos_control.Coneccion,
      5432,
      'ocrdb',
      username: 'emanuel',
      password: 'emi77',
    );

    try {
      await connection.open();
      final result = await connection.query('SELECT ubicacion_deposito, fecha_de_emision FROM documento_de_inspeccion ORDER BY fecha_de_emision DESC');

      for (var row in result) {
        final ubicacionEncriptada = row[0].toString();
        final fechaInspeccion = AESCrypt.desencriptar(row[1].toString());
        final ubicacionDesencriptada = AESCrypt.desencriptar(ubicacionEncriptada);
        final partes = ubicacionDesencriptada.split(',');
        final departamento = partes[0].trim();
        final ciudad = partes.length > 1 ? partes[2].trim() : "";

        depositosPorDepartamento[departamento] = (depositosPorDepartamento[departamento] ?? 0) + 1;

        if (!ultimaFechaPorCiudad.containsKey(departamento)) {
          ultimaFechaPorCiudad[departamento] = {};
        }
        if (!ultimaFechaPorCiudad[departamento]!.containsKey(ciudad) || ciudad == "") {
          ultimaFechaPorCiudad[departamento]![ciudad] = fechaInspeccion;
        }
      }

      print('Datos consultados correctamente');
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
    final Map<String, double> dataMap = depositosPorDepartamento.isNotEmpty
        ? depositosPorDepartamento.map((key, value) => MapEntry(key, value.toDouble()))
        : {};

    var departamentosOrdenados = depositosPorDepartamento.keys.toList()
      ..sort((a, b) => (depositosPorDepartamento[b] ?? 0).compareTo(depositosPorDepartamento[a] ?? 0));

    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 72, 128, 1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Cantidad de depositos por departamento',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: dataMap.isNotEmpty
                  ? PieChart(
                dataMap: dataMap,
                chartType: ChartType.ring,
                colorList: [Colors.red, Colors.green, Colors.blue, Colors.yellow, Colors.purple, Colors.orange, Colors.pink, Colors.amber, Colors.cyan],
                chartValuesOptions: ChartValuesOptions(
                  showChartValues: true,
                  showChartValuesInPercentage: false,
                  showChartValuesOutside: false,
                  decimalPlaces: 0,
                ),
              )
                  : Center(child: Text("", style: TextStyle(color: Color.fromRGBO(0, 15, 65, 1.0)))),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: departamentosOrdenados.length,
              itemBuilder: (context, index) {
                final departamento = departamentosOrdenados[index];
                final depositos = depositosPorDepartamento[departamento];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        'Número de depósitos en $departamento es de $depositos',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    ...ultimaFechaPorCiudad[departamento]!.entries.map((ciudadData) {
                      return ListTile(
                        title: Text(
                          ciudadData.key,
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          'Última fecha de inspección: ${ciudadData.value}',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
