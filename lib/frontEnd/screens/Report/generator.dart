import 'dart:async';
import 'dart:io';

import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sicma/backEnd/data/consult/consult.dart';
import 'package:sicma/backEnd/data/pacient/pacient.dart';
import 'package:intl/intl.dart';

class Generator {
  String generatedPdfFilePath;
  String grid = "";

  String getMeasureGrid(Consult c) {
    Map data = c.data['Antropometria']['medidas'];

    grid +=
        '<table> <thead> <tr><td width="60%"></td><td width="40%">MEDIDAS</td></tr>';
    data.forEach((key, value) {
      grid += getMeasureDetailGrid(value);
    });
    grid += '</tr></tbody></table>';

    return grid;
  }

  String getIndicatorGrid(Consult c) {
    String grid = "";
    List data = c.data['Antropometria']['diagnosticos'];
    grid +=
        '<table><thead><tr><td COLSPAN="2">ÍNDICE</td><td width="20%">CLASIFICACIÓN</td><td width="20%">FÓRMULA</td><td width="20%">INDICADOR</td></tr></thead><tbody>';
    data.forEach((element) {
      grid += '<tr><td>' +
          element['nombre'] +
          '</td><td >' +
          element['magnitud'] +
          '</td><td width="20%"' +
          element['formula'] +
          '</td><td width="20%">' +
          element['indicador'] +
          '</td></tr>';
    });
    grid += '</tbody></table>';
    return grid;
  }

  String getCDGrid(Consult c) {
    String grid = "";
    List data = c.data['PlanNutricional']['calculoDietetico'];
    grid +=
        '<table width="70%"><thead><tr><td width="50%"></td><td width="50%">INDICADOR</td></thead><tbody>';
    data.forEach((element) {
      grid += '<tr><td>' +
          element['nombre'] +
          '</td><td >' +
          element['magnitud'].toString() +
          '</td></tr>';
    });
    grid += '</tbody></table>';
    return grid;
  }

  String getCCGrid(Consult c) {
    String grid = "";
    double total = 0;
    List data = c.data['Antropometria']['composiciones'];
    grid +=
        '<table width="70%"><thead><tr><td>Componente</td><td>%</td><td>Peso</td><td>Fórmula</td><td>Drinkwater</td></thead><tbody>';
    data.forEach((element) {
      grid += '<tr><td>' +
          element['tipo'] +
          '</td><td >' +
          element['porcentaje'].toString() +
          '</td><td >' +
          element['peso'].toString() +
          '</td><td >' +
          element['formula'] +
          '</td><td >' +
          element['drinkWater'].toString() +
          '</td></tr>';
      total += double.parse(element['drinkWater'].toString());
    });
    grid += '<tr><td colspan="3"></td><td >Total D-w (%) </td><td >' +
        total.toString() +
        '</td></tr>';
    grid +=
        '<tr align="center"><td colspan="5"><div style="width:200px;height:200px; border-style:solid;" ></div></td></tr>';

    grid += '</tbody></table>';
    return grid;
  }

  String getSportGrid(Pacient c) {
    String grid = "";
    List data = c.history.data['Antecedentes']['NoPatologicos']['Deportivos']
        ['deportesActuales'];
    grid +=
        '<table width="70%"><thead><tr><td>Deporte</td><td>Fase Entto</td><td>h/día</td><td>Modalida</td><td>Posiciones</td></thead><tbody>';
    data.forEach((element) {
      grid += '<tr><td>' +
          element['nombre'] +
          '</td><td >' +
          element['faseEntto'] +
          '</td><td >' +
          element['horaDia'] +
          '</td><td >' +
          element['modalidad'] +
          '</td><td >' +
          element['posiciones'].toString() +
          '</td></tr>';
    });
    grid += '</tbody></table>';
    return grid;
  }

  String getMeasureDetailGrid(List c) {
    List data = c;
    String grid = "";

    data.forEach((element) {
      grid += '</td><td width="60%">' +
          element['nombre'] +
          '</td><td width="40%">' +
          element['magnitud'].toString() +
          '</td></tr>';
    });

    return grid;
  }

  String getSportDetailGrid(List c) {
    List data = c;
    String grid = "";

    data.forEach((element) {
      grid += '</td><td width="60%">' +
          element['nombre'] +
          '</td><td width="40%">' +
          element['magnitud'].toString() +
          '</td></tr>';
    });

    return grid;
  }

  String getSomatocarta(Consult c) {
    // Map data = c;
    String grid =
        '<table width="100%"> <tbody><tr><td><table width="100%"><tbody><tr><td>Edomorfia:</td><td></td></tr><tr><td>Mesomorfia:</td><td></td></tr><tr><td>Ectomorfia:</td><td></td></tr></tbody></table></td><td><table width="100%"><tbody><tr><td>Clasificación:</td><td></td></tr></tbody></table></td></tr><tr><td align="center" colspan="2"><div style="width:300px;height:300px; border-style:solid;" ></div></td></tr></tbody></table>';

    return grid;
  }

  Future<void> generateExampleDocument(Pacient p, Consult c) async {
    String name = p.name;
    String fN = p.data['fechaNacimiento'];
    String sexo = p.data['sexo'];
    String age = p.age.toString();
    String f = DateFormat('dd/MM/yyyy')
        .parse(c.data['fecha'])
        .toString()
        .split(" ")[0];

    String gridMeasure = getMeasureGrid(c);
    String gridIndicators = getIndicatorGrid(c);
    String gridCD = getCDGrid(c);
    String gridCC = getCCGrid(c);
    String somatocarta = getSomatocarta(c);
    String sports = getSportGrid(p);

    var htmlContent = """
    <!DOCTYPE html>
    <html>
      <head>
      </head>
      <style>
      .header {
  font-size: 8px;
}
     .title {
  font-size: 16px;
}
#page{
  heigth:800px;

}
.footer{
  font-size:8px;
}

     .subtitle {
  font-size: 14px;
}
table{
  font-size:11px;
}
      </style>
      <body>
      <div id="page">
        <table style="width: 100%;">
	<tbody>
		<tr style="height: 50px;">
			<td width="50%" align="rigth"></td>
			<td style="border-left-style: solid;" align="right" width="50%" class="header">generado por <img style="width:70px;height:20px;" src="file:///android_asset/flutter_assets/lib/frontEnd/assets/image/logoHori.png"></td>
		</tr>
		<tr>
			<td colspan="2"></td>
		</tr>
		<tr style="height: 50px;">
			<td colspan="2" align="center" class="title">REPORTE ANTROPOMETRICO</td>
		</tr>
		<tr>
			<td colspan="2"></td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<table style="width: 95%;" >
					<tbody>
						<tr>
							<td>Paciente</td>
							<td colspan="6">$name</td>
							<td></td>
							<td>Fecha</td>
							<td>$f</td>
						</tr>
						<tr>
							<td>Fecha nacimiento</td>
							<td colspan="3">$fN</td>
							<td></td>
							<td>Edad</td>
							<td>$age</td>
              <td></td>
							<td>Sexo</td>
							<td>$sexo</td>
						</tr>
					</tbody>
				</table>
			</td>
		</tr>
		<tr>
			<td colspan="2"></td>
		</tr>
		
      <tr>
        <td colspan="2"></td>
      </tr>
		<tr>
			<td width="30%">
      <table width="100%" > 
      <tbody>
      <tr>
       <td rowspan="2">DATOS ANTROPOMETRICOS</td>
       <td style="border-bottom-style:solid;"></td> 
       </tr>
       <tr> 
       <td width="70%"></td>
        </tr> 
        </tbody>
        </table>
</td>
			<td width="70%">
      <table width="100%" > 
      <tbody>
      <tr>
       <td rowspan="2">INDICES CORPORALES</td>
       <td style="border-bottom-style:solid;"></td> 
       </tr>
       <tr> 
       <td width="70%"></td>
        </tr> 
        </tbody>
        </table>
</td>
		</tr>
		<tr>
			<td rowspan="8" >
      $gridMeasure
			</td>
			<td>
      $gridIndicators
			</td>
		</tr>
      <tr>
        <td></td>	
      </tr>
      <tr>
			<td>
      
</tr>
</tbody>     
</table>
</div>
<div id="page">
<table style="width: 100%;">
	<tbody>
  
		
		<tr>
			<td colspan="2"></td>
		</tr>
    <table width="100%" > 
      <tbody>
      <tr>
			<td colspan="2" class="subtitle">
      <table width="100%" > 
      <tbody>
      <tr>
       <td rowspan="2">MODALIDAD DEPORTIVA</td>
       <td style="border-bottom-style:solid;"></td> 
       </tr>
       <tr> 
       <td width="70%"></td>
        </tr> 
        </tbody>
        </table>

      </td>
		</tr>
		<tr>
			<td colspan="2" align="center">
      $sports
      </td>
				
			</td>
		</tr>
      <tr>
			<td><table width="100%" > 
      <tbody>
      <tr>
       <td rowspan="2">COMPOSICIÓN CORPORAL</td>
       <td style="border-bottom-style:solid;"></td> 
       </tr>
       <tr> 
       <td width="70%"></td>
        </tr> 
        </tbody>
        </table>

</td>
		</tr>
      <tr>
        <td align="center">
				$gridCC
        			</td>
		</tr>
    <tr>
    <td>
    <table width="100%"> 
    <tbody>
    <tr> 
    <td rowspan="2">SOMATOCARTA</td>
    <td style="border-bottom-style:solid;">
    </td> 
    </tr>
    <tr> 
    <td width="70%">
    </td> 
    </tr>
    <tr>
			<td colspan="2">$somatocarta</td>
		</tr> 
    </tbody>
    </table>

    </td>
    </tr>
      
	</tbody>
</table>
</tr>
	</tbody>
</table></div>
<div id="page">
<table>
<tbody>
<tr>
			<td colspan="2" class="subtitle">
      <table width="100%" > 
      <tbody>
      <tr>
       <td rowspan="2">PLAN NUTRICIONAL</td>
       <td style="border-bottom-style:solid;"></td> 
       </tr>
       <tr> 
       <td width="70%"></td>
        </tr> 
        </tbody>
        </table>

      </td>
		</tr>
    <tr>
			<td width="30%" >
      <table width="100%" > 
      <tbody>
      <tr>
       <td rowspan="2">CÁLCULO DIETÉTICO</td>
       <td style="border-bottom-style:solid;"></td> 
       </tr>
       <tr> 
       <td width="70%"></td>
        </tr> 
        </tbody>
        </table>
</td>
			<td></td>
		</tr>
      <tr>
        <td>
				$gridCD
			</td>
		</tr>
	</tbody>
</table>
</div>
      </body>
    </html>
    """;

    Directory appDocDir = await getExternalStorageDirectory();
    var targetPath = appDocDir.path;
    var targetFileName = "example-1pdf";

    var generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
        htmlContent, targetPath, targetFileName);
    generatedPdfFilePath = generatedPdfFile.path;

    print(generatedPdfFilePath);
  }
}
