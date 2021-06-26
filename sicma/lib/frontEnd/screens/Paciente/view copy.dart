import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sicma/backEnd/data/pacient/pacient.dart';
import 'package:sicma/backEnd/data/pacient/pacient_dao.dart';
import 'package:sicma/frontEnd/components/form/json_schema.dart';

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
  bool editable = false;
  @override
  void initState() {
    super.initState();
    _fetchData();
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

    final routes =
        ModalRoute.of(context).settings.arguments as Map<String, Pacient>;
    p = routes.values.first;
    Map<String, dynamic> d = p.data;

    if (d != null) {
      data = d;
      print("Paciente: " + d.toString());
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(80.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AppBar(
                    automaticallyImplyLeading: false,
                    leading: Container(
                      margin: EdgeInsets.only(top: 8, bottom: 8),
                      color: Theme.of(context).primaryColorLight,
                      child: IconButton(
                        color: Theme.of(context).primaryColorLight,
                        icon: Icon(
                          Icons.keyboard_arrow_left,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    bottomOpacity: 0.0,
                    elevation: 0.0,
                    iconTheme: IconThemeData(
                        color: Theme.of(context).primaryColorLight),
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
                          onSelected: handleClick,
                          itemBuilder: (BuildContext context) => [
                                PopupMenuItem(
                                    value: '1',
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              2, 2, 8, 2),
                                          child: Icon(Icons.add_circle_outline,
                                              color: Colors.black),
                                        ),
                                        Text('Editar'),
                                      ],
                                    )),
                                PopupMenuItem(
                                    value: '2',
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              2, 2, 8, 2),
                                          child: Icon(Icons.add_circle_outline,
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
            : ListView(children: <Widget>[
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Column(children: <Widget>[
                          JsonSchema(
                            data: data,
                            editable: editable,
                            form: form,
                            onChanged: (dynamic response) {
                              this.response = response;
                            },
                          ),
                          RaisedButton(
                              child: Text('Guardar'),
                              onPressed: () async {
                                //print(this.response);
                                var p = Pacient.fromForm(
                                    null,
                                    Map.castFrom(json
                                        .decode(json.encode(this.response))));
                                var pD = PacientDao();
                                print("Update: " + p.data.toString());
                                pD.update(p);
                                setState(() {
                                  editable = false;
                                });
                                /*
                                Navigator.of(context).popAndPushNamed(
                                    '/Paciente/View',
                                    arguments: <String, Pacient>{'Pacient': p});*/

                                //Enviar a guardar
                              }),
                          RaisedButton(
                              child: Text('Cancelar'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              })
                        ]),
                      ),
                    ],
                  ),
                ),
              ]));
  }
}
