import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sicma/backEnd/data/consult/consult.dart';
import 'package:sicma/backEnd/data/history/history.dart';
import 'package:sicma/backEnd/data/history/history_dao.dart';
import 'package:sicma/backEnd/data/pacient/pacient.dart';
import 'package:sicma/frontEnd/components/bluetooth/BTconnection.dart';
import 'package:sicma/frontEnd/components/cam/camara.dart';
import 'package:sicma/frontEnd/components/form/formula.dart';

import 'package:sicma/frontEnd/components/form/json_schema.dart';
import 'package:sicma/frontEnd/components/form/section.dart';
import 'package:sicma/frontEnd/components/tab/tabView.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sembast/utils/value_utils.dart';

class FormScreenConsulta extends StatefulWidget {
  FormScreenConsulta({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FormScreenConsultaState createState() => _FormScreenConsultaState();
}

class _FormScreenConsultaState extends State<FormScreenConsulta>
    with TickerProviderStateMixin {
  TabController _tabController;
  Map data;
  final _formKey = GlobalKey<FormState>();
  String formString;
  dynamic response;
  Map info = Map();
  Map form = Map();
  String aux;
  String aux1;
  String aux2;
  String aux3;
  String aux4;
  bool cameraFlag = true;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 4, vsync: this);
    _fetchData();
  }

  var isLoading = false;
  _fetchData() async {
    setState(() {
      isLoading = true;
    });

    response =
        await rootBundle.loadString("lib/backEnd/data/json/consult.json");
    if (response != null) {
      aux = response;

      print(form);
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load form');
    }

    response =
        await rootBundle.loadString("lib/backEnd/data/json/consult1.json");
    if (response != null) {
      aux1 = response;

      print(form);
      setState(() {
        isLoading = false;
      });
    } else {
      response = '';
      throw Exception('Failed to load form');
    }
    response =
        await rootBundle.loadString("lib/backEnd/data/json/consult2.json");
    if (response != null) {
      aux2 = response;

      print(form);
      setState(() {
        isLoading = false;
      });
    } else {
      response = '';
      throw Exception('Failed to load form');
    }
    response =
        await rootBundle.loadString("lib/backEnd/data/json/consult3.json");
    if (response != null) {
      aux3 = response;

      print(form);
      setState(() {
        isLoading = false;
      });
    } else {
      response = '';
      throw Exception('Failed to load form');
    }

    response =
        await rootBundle.loadString("lib/backEnd/data/json/consult4.json");
    if (response != null) {
      aux4 = response;

      print(form);
      setState(() {
        isLoading = false;
      });
    } else {
      response = '';
      throw Exception('Failed to load form');
    }
  }

  Pacient p;

  List<Consult> getConsults(consultas) {
    List<Consult> cons = [];
    consultas.forEach((value) {
      cons.add(new Consult(id: null, data: value));
    });
    return cons;
  }

  bool meassure = true;
  @override
  Widget build(BuildContext context) {
    List arguments = ModalRoute.of(context).settings.arguments;
    p = arguments[0] as Pacient;

    bool hasData = p != null ? true : false;
    hasData ? form = cloneMap(p.history.data) : new Map();
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
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
                    "Consulta Clínico",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                )
              ])),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                children: [
                  // give the tab bar a height [can change hheight to preferred height]
                  Container(
                      height: 45,
                      padding: EdgeInsets.only(right: 10, left: 10),
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: TabBar(
                          indicatorSize: TabBarIndicatorSize.tab,
                          controller: _tabController,
                          // give the indicator a decoration (color and border radius)
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                            color: Colors.white,
                          ),
                          labelColor: Theme.of(context).primaryColor,
                          unselectedLabelColor: Colors.white,
                          tabs: [
                            // first tab [you can add an icon using the icon property]
                            Tab(
                              icon: Icon(Icons.access_time_sharp),
                            ),
                            Tab(
                              icon: Icon(Icons.accessibility_new),
                            ),
                            Tab(
                              icon: Icon(Icons.assignment_outlined),
                            ),
                            Tab(
                              icon: Icon(Icons.calendar_today),
                            )
                          ],
                        ),
                      )),
                  Expanded(
                      child: Form(
                          key: _formKey,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(30.0),
                                topRight: const Radius.circular(30.0),
                              ),
                              color: Colors.white,
                            ),
                            child: TabBarView(
                                physics: NeverScrollableScrollPhysics(),
                                controller: _tabController,
                                children: [
                                  CustomTabView(
                                    title: 'Estado Actual',
                                    children: [
                                      JsonSchema(
                                          data: form,
                                          editable: true,
                                          form: aux,
                                          onChanged: (response) {
                                            Map aux =
                                                this.info['Estado Actual'];
                                            aux[Map.castFrom(response)
                                                    .keys
                                                    .first] =
                                                Map.castFrom(response)
                                                    .values
                                                    .first;
                                            print(this.info);
                                          })
                                    ],
                                    childrenFooter: [
                                      ButtonTheme(
                                          minWidth: 120,
                                          height: 40.0,
                                          child: RaisedButton(
                                              textColor: Colors.white,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .popAndPushNamed(
                                                        '/Consulta/New',
                                                        arguments: p);
                                              },
                                              child: Text('Omitir'))),
                                      ButtonTheme(
                                          minWidth: 120,
                                          height: 40.0,
                                          child: RaisedButton(
                                              textColor: Colors.white,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                              ),
                                              onPressed: () {
                                                _tabController.index++;
                                              },
                                              child: Text('Siguiente')))
                                    ],
                                  ),
                                  CustomTabView(
                                    title: 'Antropometría',
                                    children: [
                                      Visibility(
                                          visible: meassure,
                                          child: Miniature(
                                            onTaken: (value) {
                                              setState(() {
                                                meassure = value;
                                              });
                                            },
                                          )),
                                      //  photo1,
                                      Visibility(
                                          visible: !meassure,
                                          child: Column(children: [
                                            JsonSchema(
                                                data: form,
                                                editable: true,
                                                form: aux1,
                                                onChanged: (dynamic response) {
                                                  Map aux = this
                                                      .info['Estado Actual'];
                                                  aux[Map.castFrom(response)
                                                          .keys
                                                          .first] =
                                                      Map.castFrom(response)
                                                          .values
                                                          .first;
                                                  print(this.info);
                                                }),
                                            CustomSection(
                                              label: "Pligues Cutáneos",
                                              type: 'dropDown',
                                              children: [BTconnection()],
                                            )
                                          ])),
                                    ],
                                    childrenFooter: [
                                      Visibility(
                                          visible: !meassure,
                                          child: ButtonTheme(
                                              minWidth: 120,
                                              height: 40.0,
                                              child: RaisedButton(
                                                  textColor: Colors.white,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25.0),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      meassure = true;
                                                    });
                                                  },
                                                  child: Text('Cancelar')))),
                                      Visibility(
                                          visible: !meassure,
                                          child: ButtonTheme(
                                              minWidth: 120,
                                              height: 40.0,
                                              child: FlatButton(
                                                  textColor: Colors.white,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25.0),
                                                  ),
                                                  onPressed: () {
                                                    print("form: " +
                                                        aux1.toString());
                                                    _tabController.index++;
                                                  },
                                                  child: Text('Siguiente'))))
                                    ],
                                  ),
                                  CustomTabView(
                                    title: 'Resultados',
                                    children: [
                                      JsonSchema(
                                          data: form,
                                          editable: true,
                                          form: aux2,
                                          onChanged: (dynamic response) {
                                            Map aux =
                                                this.info['Estado Actual'];
                                            aux[Map.castFrom(response)
                                                    .keys
                                                    .first] =
                                                Map.castFrom(response)
                                                    .values
                                                    .first;
                                            print(this.info);
                                          })
                                    ],
                                    childrenFooter: [
                                      ButtonTheme(
                                          minWidth: 120,
                                          height: 40.0,
                                          child: RaisedButton(
                                              textColor: Colors.white,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .popAndPushNamed(
                                                        '/Consulta/New',
                                                        arguments: p);
                                              },
                                              child: Text('Omitir'))),
                                      ButtonTheme(
                                          minWidth: 120,
                                          height: 40.0,
                                          child: RaisedButton(
                                              textColor: Colors.white,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                              ),
                                              onPressed: () {
                                                _tabController.index++;
                                              },
                                              child: Text('Guardar')))
                                    ],
                                  ),
                                  CustomTabView(
                                      title: 'Plan Nutricional',
                                      children: [
                                        Text(this.info.toString()),
                                        JsonSchema(
                                            data: form,
                                            editable: true,
                                            form: aux3,
                                            onChanged: (dynamic response) {
                                              this.info = response;
                                              print(response);
                                            })
                                      ],
                                      childrenFooter: []),
                                ]),
                          )))
                ],
              ),
            ),
    );
  }
}
