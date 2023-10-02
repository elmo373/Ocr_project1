import 'dart:core';

class ExtractorDatos {
  static List<Map<String, String>> extraerDatos(String texto) {
    print(texto);
    var regexNumeroCertificado = RegExp(r"N[°º]*\s*(\d+(/\d*)?)");
    var regexNombreEmpresa = RegExp(r"Nombre.*Raz[óo]n\s*Social.*:\s*(.+)");
    var regexRUC = RegExp(r"Registro\s*Único\s*de\s*Contribuyentes\s*R\.?U\.?C\.?:\s*(\d+)");
    var regexFechaEmision = RegExp(r"Fecha\s*de\s*Escritura.*Constitución\s*Social.*:\s*(\d+)");
    var regexDirectorMaterialBelico = RegExp(r"Matr[íi]cula\s*RENAREC.*:\s*(.+)");
    var regexDirectorGeneralLogistica = RegExp(r"Licencia\s*de\s*funcionamiento\s*Municipal.*:\s*(.+)");
    var regexRepresentanteLegal = RegExp(r"Representante\s*Legal.*:\s*(.+)");
    var regexActividadPrincipal = RegExp(r"Actividad\s*Principal.*:\s*(.+)");
    var regexNombrePropietario = RegExp(r"Nombre.*del\s*Propietario.*Gerente.*Director.*:\s*(.+)");


    var matchesNumeroCertificado = regexNumeroCertificado.allMatches(texto);
    var matchesNombreEmpresa = regexNombreEmpresa.allMatches(texto);
    var matchesRUC = regexRUC.allMatches(texto);
    var matchesFechaEmision = regexFechaEmision.allMatches(texto);
    var matchesDirectorMaterialBelico = regexDirectorMaterialBelico.allMatches(texto);
    var matchesDirectorGeneralLogistica = regexDirectorGeneralLogistica.allMatches(texto);
    var matchesRepresentanteLegal = regexRepresentanteLegal.allMatches(texto);
    var matchesActividadPrincipal = regexActividadPrincipal.allMatches(texto);
    var matchesNombrePropietario = regexNombrePropietario.allMatches(texto);


    List<Map<String, String>> resultados = [];

    for (var numeroCertificadoMatch in matchesNumeroCertificado) {
      var numeroCertificado = numeroCertificadoMatch.group(1)?.replaceAll(RegExp(r"\s|/.*"), "") ?? "";

      for (var nombreEmpresaMatch in matchesNombreEmpresa) {
        var nombreEmpresa = nombreEmpresaMatch.group(1) ?? "";
        var ruc = "";
        var fechaEmision = "";
        var directorMaterialBelico = "";
        var directorGeneralLogistica = "";
        var representanteLegal = "";
        var actividadPrincipal = "";
        var nombrePropietario = "";
        var provincia = "";
        var zona = "";
        var claseSociedad = "";
        var nombreNotario = "";
        var fechaFundacion = "";

        // Busca otras coincidencias
        for (var rucMatch in matchesRUC) {
          ruc = rucMatch.group(1) ?? "";
          break;
        }

        for (var fechaEmisionMatch in matchesFechaEmision) {
          fechaEmision = fechaEmisionMatch.group(1) ?? "";
          break;
        }

        for (var directorMaterialBelicoMatch in matchesDirectorMaterialBelico) {
          directorMaterialBelico = directorMaterialBelicoMatch.group(1) ?? "";
          break;
        }

        // Repite el proceso para otras coincidencias
        for (var directorGeneralLogisticaMatch in matchesDirectorGeneralLogistica) {
          directorGeneralLogistica = directorGeneralLogisticaMatch.group(1) ?? "";
          break;
        }

        for (var representanteLegalMatch in matchesRepresentanteLegal) {
          representanteLegal = representanteLegalMatch.group(1) ?? "";
          break;
        }

        for (var actividadPrincipalMatch in matchesActividadPrincipal) {
          actividadPrincipal = actividadPrincipalMatch.group(1) ?? "";
          break;
        }

        for (var nombrePropietarioMatch in matchesNombrePropietario) {
          nombrePropietario = nombrePropietarioMatch.group(1) ?? "";
          break;
        }


        directorMaterialBelico = "Sr. Abg. Ubaldo Rojas Cuchallo";
        directorGeneralLogistica = "Sr. Gral. Brig. Willy Gonzalo Espejo Bobarin";

        // Agrega los datos a la lista de resultados
        resultados.add({
          "Número Certificado": numeroCertificado,
          "Nombre Empresa": nombreEmpresa,
          "RUC": ruc,
          "Fecha de Emisión": fechaEmision,
          "Director Material Bélico": directorMaterialBelico,
          "Director General Logística": directorGeneralLogistica,
          "Representante Legal": representanteLegal,
          "Actividad Principal": actividadPrincipal,
          "Nombre Propietario": nombrePropietario,
        });
      }
    }

    print(resultados);

    return resultados;

  }

}

class ExtractorDatosInspeccion {
  static List<Map<String, String>> extraerDatos(String texto) {
    print(texto);
    var regexNumeroRegistro = RegExp(r"Número de Registro: (\d+)");
    var regexNombreEmpresa = RegExp(r"Nombre o razón social de la firma, Empresa o persona: (.+?)\.");
    var regexNombrePropietario = RegExp(r"Responsable de la Firma o Empresa: (.+)");
    var regexRepresentanteLegal = RegExp(r"Responsable de la Empresa: (.+)");
    var regexUbicacionDeposito = RegExp(r"Dirección \(Depósito\) Lugar: (.+)");
    var regexFechaEmision = RegExp(r"Lugar, fecha y hora de inspección: (\d+ de [a-zA-Z]+ del \d+)");

    List<Map<String, String>> resultados = [
      {
        "Número de Registro": "",
        "Nombre Empresa": "",
        "Nombre Propietario": "",
        "Representante Legal": "",
        "Ubicación Depósito": "",
        "Fecha de Emisión": ""
      }
    ];

    var numeroRegistro = _getMatchGroup(regexNumeroRegistro, texto);
    var nombreEmpresa = _getMatchGroup(regexNombreEmpresa, texto);
    var nombrePropietario = _getMatchGroup(regexNombrePropietario, texto);
    var representanteLegal = _getMatchGroup(regexRepresentanteLegal, texto);
    var ubicacionDeposito = _getMatchGroup(regexUbicacionDeposito, texto);
    var fechaEmision = _getMatchGroup(regexFechaEmision, texto);

    resultados[0] = {
      "Número de Registro": numeroRegistro,
      "Nombre Empresa": nombreEmpresa,
      "Nombre Propietario": nombrePropietario,
      "Representante Legal": representanteLegal,
      "Ubicación Depósito": ubicacionDeposito,
      "Fecha de Emisión": fechaEmision,
    };

    return resultados;
  }

  static String _getMatchGroup(RegExp regex, String text) {
    var match = regex.firstMatch(text);
    return (match != null && match.groupCount > 0 ? match.group(1) : "") ?? "";
  }
}

