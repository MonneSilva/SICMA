import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sicma/backEnd/data/consult/consult.dart';
import 'package:sicma/backEnd/data/history/history.dart';
import 'package:sicma/backEnd/data/history/history_dao.dart';
import 'package:sicma/backEnd/data/pacient/pacient.dart';
import 'package:sicma/backEnd/data/pacient/pacient_dao.dart';
import 'package:intl/intl.dart';

class ViewScreenPaciente extends StatefulWidget {
  ViewScreenPaciente({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ViewScreenPacienteState createState() => _ViewScreenPacienteState();
}

class _ViewScreenPacienteState extends State<ViewScreenPaciente> {
  dynamic response;
  String form;
  Map data;
  Pacient p;
  Consult consult;
  bool editable = false;
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  getAge(date) {
    date = date.toString().replaceAll(' ', '');
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
      return years.toString();
    }
  }

  var isLoading = false;
  _fetchData() async {
    setState(() {
      isLoading = true;
    });
    String response = json.encode(json.decode(
        await rootBundle.loadString("lib/backEnd/data/json/pacient.json")));
    if (response != null) {
      form = response;
      // print(form);
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load form');
    }
  }

  void handleClick(String value) {
    switch (value) {
      case '1':
        setState(() {
          editable = true;
        });
        //Navigator.of(context).pushNamed('/Paciente/New');
        break;
      case '2':
        var pD = PacientDao();
        pD.delete(p.id);
        Navigator.of(context).pop();
        break;
    }
  }

  getYears(date) {
    DateTime d = DateTime.parse(date);
    DateTime t = DateTime.now();
    //calcular edad
  }

  @override
  Widget build(BuildContext context) {
    final Pacient data = ModalRoute.of(context).settings.arguments as Pacient;
    data.searchHistory();
    bool hasData = false;

    /* bool hasData = data.history ?? true;
    if (hasData) if (data.history.data['Consultas'] != null) {
      final List list = data.history.data['Consultas'] as List;
      consult = new Consult(id: null, data: Map.castFrom(list.last));
    }*/

    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(80.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: <
                    Widget>[
              AppBar(
                automaticallyImplyLeading: false,
                leading: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    borderRadius: new BorderRadius.only(
                      bottomRight: const Radius.circular(10.0),
                      topRight: const Radius.circular(10.0),
                    ),
                  ),
                  margin: EdgeInsets.only(top: 3, bottom: 3),
                  child: IconButton(
                    color: Theme.of(context).primaryColorLight,
                    icon: Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                bottomOpacity: 0.0,
                elevation: 0.0,
                iconTheme:
                    IconThemeData(color: Theme.of(context).primaryColorLight),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20))),
                backgroundColor: Colors.transparent,
                centerTitle: true,
                title: Text(
                  "Paciente",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 25),
                ),
                actions: <Widget>[
                  PopupMenuButton<String>(
                      color: Color.fromARGB(255, 92, 105, 99),
                      onSelected: (value) async {
                        switch (value) {
                          case '1':
                            Navigator.of(context)
                                .pushNamed('/Paciente/New', arguments: data);
                            break;
                          case '2':
                            var pD = PacientDao();
                            pD.delete(p.id);
                            Navigator.of(context).pop();
                            break;
                          case '3':
                            hasData
                                ? Navigator.of(context).pushNamed(
                                    '/Historial/New',
                                    arguments: [data, true])
                                : Navigator.of(context).pushNamed(
                                    '/Historial/New',
                                    arguments: [data, false]);

                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                            PopupMenuItem(
                                value: '1',
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(2, 2, 8, 2),
                                      child: Icon(Icons.create,
                                          color: Colors.black),
                                    ),
                                    Text('Editar'),
                                  ],
                                )),
                            PopupMenuItem(
                                value: '3',
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(2, 2, 8, 2),
                                      child: hasData != null
                                          ? Icon(Icons.visibility,
                                              color: Colors.black)
                                          : Icon(Icons.add_circle_outline,
                                              color: Colors.black),
                                    ),
                                    Text(hasData
                                        ? 'Ver Historial'
                                        : 'Crear Historial'),
                                  ],
                                )),
                            PopupMenuItem(
                                value: '2',
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(2, 2, 8, 2),
                                      child: Icon(Icons.cancel,
                                          color: Colors.black),
                                    ),
                                    Text('Eliminar'),
                                  ],
                                ))
                          ]),
                ],
              )
            ])),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView(children: [
                Stack(alignment: Alignment.bottomCenter, children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(top: 30),
                      alignment: Alignment.topCenter,
                      height: MediaQuery.of(context).size.height * 0.90,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              children: [
                                Text(data.data['nombre']['nombre'] ?? '',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25)),
                                Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text('Nombre(s)',
                                        style: TextStyle(color: Colors.white))),
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                    data.data['nombre']
                                                            ['apellidoPat'] ??
                                                        '',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 25)),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10),
                                                    child: Text(
                                                        'Apellido Paterno',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)))
                                              ])),
                                      Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                    data.data['nombre']
                                                            ['apellidoMat'] ??
                                                        '',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 25)),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10),
                                                    child: Text(
                                                        'Apellido Materno',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)))
                                              ]))
                                    ])
                              ],
                            )
                          ]),
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(30.0),
                          topRight: const Radius.circular(30.0),
                        ),
                        color: Theme.of(context).primaryColor,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.16),
                              spreadRadius: 3,
                              blurRadius: 3,
                              offset: Offset(7, 0)),
                        ],
                      )),
                  Container(
                      padding: EdgeInsets.only(top: 30),
                      alignment: Alignment.topCenter,
                      height: MediaQuery.of(context).size.height * 0.68,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              children: [
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(data.data['sexo'] ?? '',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20)),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10),
                                                    child: Text('Sexo',
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color:
                                                                Colors.white)))
                                              ])),
                                      Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                    getAge(data.data[
                                                            'fechaNacimiento']) ??
                                                        '',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20)),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10),
                                                    child: Text('Edad',
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color:
                                                                Colors.white)))
                                              ])),
                                      Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                    data.data['tipoConsulta'] ??
                                                        '',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20)),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10),
                                                    child: Text(
                                                        'Tipo de Consulta',
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color:
                                                                Colors.white)))
                                              ]))
                                    ])
                              ],
                            )
                          ]),
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(30.0),
                          topRight: const Radius.circular(30.0),
                        ),
                        color: Theme.of(context).primaryColorDark,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.26),
                              spreadRadius: 3,
                              blurRadius: 3,
                              offset: Offset(7, 0)),
                        ],
                      )),
                  Container(
                      padding: EdgeInsets.only(top: 30),
                      alignment: Alignment.topCenter,
                      height: MediaQuery.of(context).size.height * 0.55,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            if (hasData)
                              if (consult.data != null)
                                Container(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        Text('Última Consulta',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25,
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text('Fecha',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: Colors.black)),
                                            Padding(
                                                padding: EdgeInsets.all(10),
                                                child: Text(
                                                    DateFormat('dd/MM/yyyy')
                                                        .parse(consult
                                                            .data['fecha'])
                                                        .toString()
                                                        .split(" ")[0],
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black))),
                                          ],
                                        ),
                                        Text('Observación:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: Colors.black)),
                                        Text(
                                            consult.data['observacion'] != null
                                                ? consult.data['observacion']
                                                : 'No hay observación',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black)),
                                        Padding(
                                            padding: EdgeInsets.only(top: 20),
                                            child: Container(
                                              height: 1,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ))
                                      ],
                                    )),
                            Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text('Contacto',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25,
                                              color: Theme.of(context)
                                                  .primaryColor)),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text('Teléfono:',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20,
                                                        color: Colors.black)),
                                                Padding(
                                                    padding: EdgeInsets.all(10),
                                                    child: Text(
                                                        data.data['contacto']
                                                                ['telefono'] ??
                                                            '',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            color:
                                                                Colors.black)))
                                              ]),
                                          Text('Correo electrónico:',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: Colors.black)),
                                          Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Text(
                                                  data.data['contacto']
                                                          ['correo'] ??
                                                      '',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.black)))
                                        ],
                                      )
                                    ]))
                          ]),
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(30.0),
                          topRight: const Radius.circular(30.0),
                        ),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.26),
                              spreadRadius: 3,
                              blurRadius: 3,
                              offset: Offset(7, 0)),
                        ],
                      )),
                ])
              ]));
  }
}
