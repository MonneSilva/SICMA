import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_localizations/flutter_localizations.dart';
/*import 'package:sicma/backEnd/data/history/history.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sicma/backEnd/data/history/history_dao.dart';
import 'package:sicma/backEnd/data/pacient/pacient.dart';
import 'package:sicma/backEnd/data/pacient/pacient_dao.dart';*/
import 'dart:async';
import 'package:sicma/routes.dart';

import 'backEnd/data/history/history.dart';
import 'backEnd/data/history/history_dao.dart';

Future<void> main() async {
  runApp(MyApp());
/*
  var pD = PacientDao();
  List p = await pD.getAll();
  p.forEach((element) {
    print(element.id.toString() + ' : ' + element.data.toString());
  });*/
  /*
  var h = History(
      id: null,
      data: Map.castFrom(json.decode(await rootBundle
          .loadString("lib/backEnd/data/json/history_example.json"))));
  var hD = HistoryDao();
  hD.insert(h);

  var hD1 = HistoryDao();
  List h1 = await hD1.getAll();
  h1.forEach((element) {
    print(element.id.toString() + ' : ' + element.data.toString());
  });
  List<History> h = await hD1.getHistoryByKey(4, "paciente_id");
  print(h);
  var p = Pacient(
      id: null,
      data: Map.castFrom(json.decode(await rootBundle
          .loadString("lib/backEnd/data/json/pacient_example.json"))));
  var pD = PacientDao();
  pD.insert(p);
*/
  //hD.delete(5);

  //h.insert(data: Map.castFrom(json.encode("lib/backEnd/data/json/history.json")));
  //for (int i = 0; i < 26; i++) await p.delete(i);
  /*List<Pacient> tdl = p.getAll() as List;
  tdl.forEach((element) async {
    print(element.data.toString());
  });*/
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //  localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: [const Locale('en')],
      title: 'SICMA',
      theme: ThemeData(
          primaryColor: Color.fromARGB(255, 105, 176, 169),
          primaryColorDark: Color.fromARGB(255, 123, 185, 178),
          primaryColorLight: Color.fromARGB(255, 148, 198, 194),
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          backgroundColor: Colors.white),
      initialRoute: '/Home',
      routes: routes,
    );
  }
}
