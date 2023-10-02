import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:postgre_flutter/para_app/Ocr_app/funciones_ocr.dart';
import 'package:postgre_flutter/para_app/Ocr_app/pdf_inspeccion.dart';

class PantallaResultado2 extends StatefulWidget {
  final String texto;
  final Map<String, dynamic> datos;
  final File archivo;

  PantallaResultado2({required this.texto, required this.datos, required this.archivo});

  @override
  _PantallaResultado2State createState() => _PantallaResultado2State();
}

class _PantallaResultado2State extends State<PantallaResultado2> {
  final llaves = [
    "Número de Registro",
    "Nombre Empresa",
    "Nombre Propietario",
    "Representante Legal",
    "Ubicación Depósito",
    "Cumple",
    "Fecha de Emisión",
  ];

  late Map<String, TextEditingController> _controladores;
  final _llaveFormulario = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controladores = {for (var llave in llaves) llave: TextEditingController()};
  }

  @override
  void dispose() {
    _controladores.values.forEach((controlador) => controlador.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var datosExtraidos = ExtractorDatosInspeccion.extraerDatos(widget.texto);

    if (datosExtraidos.isNotEmpty) {
      for (var llave in llaves) {
        _controladores[llave]?.text = datosExtraidos[0][llave] ?? '';
      }
    }


    return Scaffold(
      appBar: AppBar(
        title: Text('Información obtenida'),
        backgroundColor: Color.fromRGBO(3, 72, 128, 1),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Form(
          key: _llaveFormulario,
          child: ListView(
            children: <Widget>[
              ...llaves.map((llave) {
                return Card(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        campoTexto(_controladores[llave]!, llave),
                      ],
                    ),
                  ),
                );
              }).toList(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(3, 72, 128, 1)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          )
                      ),
                    ),
                    child: Text('Cancelar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(3, 72, 128, 1)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          )
                      ),
                    ),
                    child: Text('Siguiente', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    onPressed: () {
                      if (_llaveFormulario.currentState!.validate()) {
                        for (var llave in llaves) {
                          datosExtraidos[0][llave] = _controladores[llave]!.text;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Pdf_inspeccion(texto: widget.texto, datos: widget.datos, file: widget.archivo, resultados: datosExtraidos),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField campoTexto(TextEditingController controlador, String etiqueta) {
    String etiquetaMostrar = etiqueta;

    // Modificaciones para las etiquetas específicas:
    if (etiqueta == "Cumple") {
      etiquetaMostrar = "Cumple (Si/No)";
    } else if (etiqueta == "Fecha de Emisión") {
      etiquetaMostrar = "Fecha de Emisión (día/mes/año)";
    }

    return TextFormField(
      controller: controlador,
      decoration: InputDecoration(
        labelText: etiquetaMostrar,
        labelStyle: TextStyle(color: Color.fromRGBO(3, 72, 128, 1), fontSize: 16.0, fontWeight: FontWeight.bold),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(3, 72, 128, 1)),
        ),
      ),
      style: TextStyle(color: Color.fromRGBO(3, 72, 128, 1)),
      validator: (valor) {
        if (valor!.isEmpty) {
          return 'Por favor ingrese un valor';
        }

        if (etiqueta == 'Número de Registro' && valor.contains(RegExp(r'[^\d]'))) {
          return 'Por favor ingrese solo números';
        }

        if (etiqueta == 'Cumple' && !(valor.toLowerCase() == 'si' || valor.toLowerCase() == 'no')) {
          return 'Por favor ingrese Si o No';
        }

        if (etiqueta == 'Fecha de Emisión' && !RegExp(r'^\d{1,2}/\d{1,2}/\d{4}$').hasMatch(valor)) {
          return 'La fecha debe estar en el formato día/mes/año';
        }
        return null;
      },
    );
  }
}
