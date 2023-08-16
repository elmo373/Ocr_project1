import 'dart:core';

class ExtractorDatos {
  static List<Map<String, String>> extraerDatos(String texto) {
    var regexNumeroCertificado1 = RegExp(r"N° (\d+/\d+)");
    var regexNombreEmpresa1 = RegExp(r"Nombre o Razón Social: (.+)");
    var regexRUC1 = RegExp(r"Registro Único de Contribuyentes R.U.C.: (\d+)");
    var regexFechaEmision1 = RegExp(r"La Paz, (\d+ de [a-zA-Z]+ de \d+)");
    var regexDirectorMaterialBelico1 = RegExp(
        r"Director de Material Bélico\s+Sr\. (.+?)\s{2,}");
    var regexDirectorGeneralLogistica1 = RegExp(
        r"Director General de Logística\s+Sr\. (.+)");
    var regexRepresentanteLegal1 = RegExp(r"Representante legal: (.+)");
    var regexActividadPrincipal1 = RegExp(r"Actividad Principal: (.+)");
    var regexNombrePropietario1 = RegExp(
        r"Nombre del Propietario, Gerente, Director: (.+)");

    var regexNumeroCertificado2 = RegExp(r"N[°|º]\s*(\d+(/\d+)?)");
    var regexNombreEmpresa2 = RegExp(
        r"Nombre\s*o\s*Raz[ó|o]n\s*Social\s*:\s*(.+)");
    var regexRUC2 = RegExp(
        r"Registro\s*[U|ú]nico\s*de\s*Contribuyentes\s*R[\.|\. ]?U[\.|\. ]?C[\.|\. ]?:\s*(\d+)");
    var regexFechaEmision2 = RegExp(
        r"Fecha\s*de\s*Escritura\s*de\s*Constituci[ó|o]n\s*Social\s*:\s*(\d+)");
    var regexDirectorMaterialBelico2 = RegExp(
        r"Matr[í|i]cula\s*RENAREC\s*:\s*(.+)");
    var regexDirectorGeneralLogistica2 = RegExp(
        r"Licencia\s*de\s*funcionamiento\s*Municipal\s*:\s*(.+)");
    var regexRepresentanteLegal2 = RegExp(r"Representante\s*Legal\s*:\s*(.+)");
    var regexActividadPrincipal2 = RegExp(r"Actividad\s*Principal\s*:\s*(.+)");
    var regexNombrePropietario2 = RegExp(
        r"Nombre\s*del\s*Propietario,\s*Gerente,\s*Director:\s*(.+)");

    var matchesNumeroCertificado = regexNumeroCertificado1.allMatches(texto);
    var matchesNombreEmpresa = regexNombreEmpresa1.allMatches(texto);
    var matchesRUC = regexRUC1.allMatches(texto);
    var matchesFechaEmision = regexFechaEmision1.allMatches(texto);
    var matchesDirectorMaterialBelico = regexDirectorMaterialBelico1.allMatches(
        texto);
    var matchesDirectorGeneralLogistica = regexDirectorGeneralLogistica1
        .allMatches(texto);
    var matchesRepresentanteLegal = regexRepresentanteLegal1.allMatches(texto);
    var matchesActividadPrincipal = regexActividadPrincipal1.allMatches(texto);
    var matchesNombrePropietario = regexNombrePropietario1.allMatches(texto);

    if (matchesNumeroCertificado.isEmpty) {
      matchesNumeroCertificado = regexNumeroCertificado2.allMatches(texto);
    }
    if (matchesNombreEmpresa.isEmpty) {
      matchesNombreEmpresa = regexNombreEmpresa2.allMatches(texto);
    }
    if (matchesRUC.isEmpty) {
      matchesRUC = regexRUC2.allMatches(texto);
    }
    if (matchesFechaEmision.isEmpty) {
      matchesFechaEmision = regexFechaEmision2.allMatches(texto);
    }
    if (matchesDirectorMaterialBelico.isEmpty) {
      matchesDirectorMaterialBelico =
          regexDirectorMaterialBelico2.allMatches(texto);
    }
    if (matchesDirectorGeneralLogistica.isEmpty) {
      matchesDirectorGeneralLogistica =
          regexDirectorGeneralLogistica2.allMatches(texto);
    }
    if (matchesRepresentanteLegal.isEmpty) {
      matchesRepresentanteLegal = regexRepresentanteLegal2.allMatches(texto);
    }
    if (matchesActividadPrincipal.isEmpty) {
      matchesActividadPrincipal = regexActividadPrincipal2.allMatches(texto);
    }
    if (matchesNombrePropietario.isEmpty) {
      matchesNombrePropietario = regexNombrePropietario2.allMatches(texto);
    }

    List<Map<String, String>> resultados = [
      {
        "Número Certificado": "",
        "Nombre Empresa": "",
        "RUC": "",
        "Fecha Emisión": "",
        "Director Material Bélico": "",
        "Director General Logística": "",
        "Representante Legal": "",
        "Actividad Principal": "",
        "Nombre Propietario": ""
      }
    ];

    for (var i = 0; i < matchesNumeroCertificado.length; i++) {
      var numeroCertificado = matchesNumeroCertificado.length > i
          ? matchesNumeroCertificado.elementAt(i).group(1) ?? ""
          : "";
      var nombreEmpresa = matchesNombreEmpresa.length > i
          ? matchesNombreEmpresa.elementAt(i).group(1) ?? ""
          : "";
      var ruc = matchesRUC.length > i ? matchesRUC.elementAt(i).group(1) ?? ""
          : "";
      var fechaEmision = matchesFechaEmision.length > i
          ? matchesFechaEmision.elementAt(i).group(1) ?? ""
          : "";
      var directorMaterialBelico = matchesDirectorMaterialBelico.length > i
          ? matchesDirectorMaterialBelico.elementAt(i).group(1) ?? ""
          : "";
      var directorGeneralLogistica =
      matchesDirectorGeneralLogistica.length > i
          ? matchesDirectorGeneralLogistica.elementAt(i).group(1) ?? ""
          : "";
      var representanteLegal = matchesRepresentanteLegal.length > i
          ? matchesRepresentanteLegal.elementAt(i).group(1) ?? ""
          : "";
      var actividadPrincipal = matchesActividadPrincipal.length > i
          ? matchesActividadPrincipal.elementAt(i).group(1) ?? ""
          : "";
      var nombrePropietario = matchesNombrePropietario.length > i
          ? matchesNombrePropietario.elementAt(i).group(1) ?? ""
          : "";

      resultados = [{
        "Número Certificado": numeroCertificado,
        "Nombre Empresa": nombreEmpresa,
        "RUC": ruc,
        "Fecha Emisión": fechaEmision,
        "Director Material Bélico": directorMaterialBelico,
        "Director General Logística": directorGeneralLogistica,
        "Representante Legal": representanteLegal,
        "Actividad Principal": actividadPrincipal,
        "Nombre Propietario": nombrePropietario
      }];
    }

    return resultados;
  }
}

class ExtractorDatosInspeccion {
  static List<Map<String, String>> extraerDatos(String texto) {
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

