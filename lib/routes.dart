import 'package:flutter/widgets.dart';
import 'package:sicma/frontEnd/components/image/widgetImage.dart';

import 'package:sicma/frontEnd/screens/Historial/search.dart';

import 'package:sicma/frontEnd/screens/home.dart';
import 'package:sicma/frontEnd/screens/Report/search.dart';

import 'package:sicma/frontEnd/screens/Paciente/search.dart';
import 'package:sicma/frontEnd/screens/Paciente/new.dart';
import 'package:sicma/frontEnd/screens/Paciente/edit.dart';
import 'package:sicma/frontEnd/screens/Paciente/view.dart';

import 'package:sicma/frontEnd/screens/Consulta/search.dart';
import 'package:sicma/frontEnd/screens/Consulta/new.dart';

import 'package:sicma/frontEnd/screens/Historial/new.dart';
import 'package:sicma/frontEnd/screens/Historial/edit.dart';
import 'package:sicma/frontEnd/screens/Historial/view.dart';
import 'package:sicma/frontEnd/screens/userPreferences/userPreferences.dart';

import 'frontEnd/screens/Historial/form.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  "/Home": (BuildContext context) => new HomeScreen(),
  "/Paciente/Search": (BuildContext context) => new SearchScreenPaciente(),
  "/Reporte/Search": (BuildContext context) => new SearchScreenReporte(),
  "/Consulta/Search": (BuildContext context) => new SearchScreenConsulta(),
  "/Historial/Search": (BuildContext context) => new SearchScreenHistory(),
  "/Paciente/New": (BuildContext context) => new NewScreenPaciente(),
  //"/Historial/New": (BuildContext context) => new NewScreenHistorial(),
  "/Historial/New": (BuildContext context) => new FormScreenHistorial(),
  "/Consulta/New": (BuildContext context) => new NewScreenConsulta(),
  "/Paciente/Edit": (BuildContext context) => new EditScreenPaciente(),
  "/Historial/Edit": (BuildContext context) => new EditScreenHistorial(),
  "/Image": (BuildContext context) => new ToImage(),

  //"/Reporte/Generator": (BuildContext context) =>
  //   new Generator(), //"/Consulta/View": (BuildContext context) => new ViewScreenConsulta(),
  "/Paciente/View": (BuildContext context) => new ViewScreenPaciente(),
  "/Historial/View": (BuildContext context) => new ViewScreenHistorial(),
  "/Configures": (BuildContext context) => new UserPreferencesScreen(),
};
