import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:postgre_flutter/Encriptacion.dart';
import 'package:pie_chart/pie_chart.dart';

void main() {
  runApp(DepositosPorDepartamentoApp());
}

class DepositosPorDepartamentoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DepositosPorDepartamentoPage(),
    );
  }
}

class DepositosPorDepartamentoPage extends StatefulWidget {
  @override
  _DepositosPorDepartamentoPageState createState() => _DepositosPorDepartamentoPageState();
}

class _DepositosPorDepartamentoPageState extends State<DepositosPorDepartamentoPage> {
  Map<String, int> depositosPorDepartamento = {
    'La Paz': 0,
    'Oruro': 0,
    'Potosí': 0,
    'Cochabamba': 0,
    'Chuquisaca': 0,
    'Tarija': 0,
    'Santa Cruz': 0,
    'Beni': 0,
    'Pando': 0,
  };

  @override
  void initState() {
    super.initState();
    consultarDepositosPorDepartamento();
  }

  void consultarDepositosPorDepartamento() async {
    final connection = PostgreSQLConnection(
      '35.225.248.224',
      5432,
      'ocrdb',
      username: 'emanuel',
      password: 'emi77',
    );

    try {
      await connection.open();

      final result = await connection.query('SELECT ubicacion_deposito FROM documento_de_inspeccion');

      for (var row in result) {
        final ubicacionEncriptada = row[0].toString();
        final ubicacionDesencriptada = AESCrypt.desencriptar(ubicacionEncriptada);
        final departamento = ubicacionDesencriptada.split(',')[0].trim();

        depositosPorDepartamento[departamento] = (depositosPorDepartamento[departamento] ?? 0) + 1;
      }

      print('Datos consultados correctamente');
    } catch (e) {
      print('Error en la conexión a PostgreSQL: $e');
    } finally {
      await connection.close();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Calculamos los datos para el gráfico
    final Map<String, double> dataMap = {};
    depositosPorDepartamento.forEach((key, value) {
      dataMap[key] = value.toDouble();
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent[700],
        title: Text('Depósitos por Departamento'),
      ),
      body: Column(
        children: [
          Expanded(
            child: PieChart(
              dataMap: dataMap,
              chartType: ChartType.ring,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: depositosPorDepartamento.keys.length,
              itemBuilder: (context, index) {
                final departamento = depositosPorDepartamento.keys.elementAt(index);
                final depositos = depositosPorDepartamento[departamento];
                return ListTile(
                  title: Text(departamento),
                  subtitle: Text('Depósitos: $depositos'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
