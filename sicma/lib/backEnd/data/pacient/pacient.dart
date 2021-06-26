//import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:sicma/backEnd/data/consult/consult.dart';
import 'package:sicma/backEnd/data/history/history.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sicma/backEnd/data/history/history_dao.dart';

class Pacient {
  //all information is save here
  int id;
  Map<String, dynamic> data;
  History history;

  Pacient({@required this.id, @required this.data, @required this.history});

  static Pacient fromMap(int id, Map<String, dynamic> map) {
    return Pacient(id: id, data: map, history: null);
  }

  int get age {
    String date = data['fechaNacimiento'].toString().replaceAll(' ', '');
    int years = 0;
    var d = DateFormat('d/M/yyyy').parse(date);
    if (d != null) {
      final now = DateTime.now();
      years = now.year - d.year;
      if (d.month > now.month) {
        years--;
      } else if (d.month == now.month) {
        if (d.day > now.day) {
          years--;
        }
      }
      return years;
    }
  }

//FROM JSON FORM TO OBJECT
  Pacient.fromJson(int id, Map<String, dynamic> json) {
    this.id = id;
    this.data = json;
  }
  Pacient.fromForm(int id, Map<String, dynamic> json) {
    this.id = id;
    this.data = new Map<String, dynamic>();
    List<dynamic> fields = json['fields'];
    fields.forEach((element) {
      if (element['value'] != null)
        data.putIfAbsent(element['title'], () => element['value']);
    });
    print(data.toString());
  }

  getData() {
    return data;
  }

  String get name {
    Map name = data['nombre'];
    String nombre = name.containsKey('apellidoMat') ? name['apellidoMat'] : '';
    return name['nombre'] + " " + name['apellidoPat'] + " " + nombre;
  }

  getConsults() {
    List<Consult> consultas = new List();
    return consultas;
  }

  getElement(String key) {
    if (data.isNotEmpty && (data.containsKey(key))) //Is not null and key exist
      return data.values.toList();
    else
      return null;
  }

  setData(Map<String, dynamic> data) {
    this.data = data;
  }

  setElement(String key, dynamic value) {
    return data.putIfAbsent(key, () => value);
  }

  setHistory(History h) {
    history = h;
  }

  searchHistory() async {
    this.history =
        await new HistoryDao().getHistoryByKey(this.id, "paciente_id");
    print("Lol");
  }

  dbCreator() {}
}
