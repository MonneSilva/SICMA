//import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sicma/backEnd/data/consult/consult.dart';
import 'package:sicma/backEnd/data/history/history.dart';
import 'package:sicma/backEnd/data/history/history_dao.dart';
import 'package:sicma/backEnd/data/pacient/pacient.dart';
import 'package:sicma/frontEnd/components/form/field.dart';
import 'package:sicma/frontEnd/components/form/json_schema.dart';
import 'package:sicma/frontEnd/components/form/row.dart';
import 'package:sicma/frontEnd/components/form/section.dart';
import 'package:sicma/frontEnd/components/tab/tabView.dart';
import 'package:flutter/services.dart' show rootBundle;

class FormScreenHistorial extends StatefulWidget {
  FormScreenHistorial({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FormScreenHistorialState createState() => _FormScreenHistorialState();
}

class _FormScreenHistorialState extends State<FormScreenHistorial>
    with TickerProviderStateMixin {
  TabController _tabController;
  Map form = new Map();
  Map data;
  final _formKey = GlobalKey<FormState>();
  String formString;
  String response;

  @override
  void initState() {
    _tabController = new TabController(length: 4, vsync: this);
    super.initState();
    _fetchData();
  }

  var isLoading = false;
  _fetchData() async {
    setState(() {
      isLoading = true;
    });
    dynamic form = json.decode(
        await rootBundle.loadString("lib/backEnd/data/json/sample_form.json"));
    if (form != null) {
      data = Map.from(form);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List arguments = ModalRoute.of(context).settings.arguments;
    final Pacient p = arguments[0] as Pacient;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
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
                    "Historial Clínico",
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
                              icon: Icon(Icons.group),
                            ),
                            Tab(
                              icon: Icon(Icons.person),
                            ),
                            Tab(
                              icon: Icon(Icons.medical_services_outlined),
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
                                    title: 'Antecedentes Heredofamiliares',
                                    children: [
                                      JsonSchema(
                                        form: this.response,
                                        onChanged: (dynamic response) {
                                          this.response = response;
                                        },
                                        actionSave: (data) {
                                          print(data);
                                        },
                                        buttonSave: new Container(
                                          height: 40.0,
                                          color: Colors.blueAccent,
                                          child: Center(
                                            child: Text("Login",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ),
                                      ),
                                    ],
                                    childrenFooter: [
                                      ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Theme.of(context)
                                                          .primaryColor)),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Omitir')),
                                      ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Theme.of(context)
                                                          .primaryColor)),
                                          onPressed: () {
                                            _tabController.index++;
                                          },
                                          child: Text('Siguente'))
                                    ],
                                  ),
                                  CustomTabView(
                                    title:
                                        'Antecedentes Personales No Patológicos',
                                    children: [],
                                    childrenFooter: [
                                      ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Theme.of(context)
                                                          .primaryColor)),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Omitir')),
                                      ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Theme.of(context)
                                                          .primaryColor)),
                                          onPressed: () {
                                            _tabController.index++;
                                          },
                                          child: Text('Siguiente'))
                                    ],
                                  ),
                                  CustomTabView(
                                    title:
                                        'Antecedentes Personales Patológicos',
                                    children: [],
                                    childrenFooter: [
                                      ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Theme.of(context)
                                                          .primaryColor)),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Omitir')),
                                      ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Theme.of(context)
                                                          .primaryColor)),
                                          onPressed: () {
                                            _tabController.index++;
                                          },
                                          child: Text('Siguiente'))
                                    ],
                                  ),
                                  CustomTabView(
                                    title: 'Consulta',
                                    children: [],
                                    childrenFooter: [
                                      ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Theme.of(context)
                                                          .primaryColor)),
                                          onPressed: () {
                                            _tabController.index++;
                                          },
                                          child: Text('Omitir')),
                                      ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Theme.of(context)
                                                          .primaryColor)),
                                          onPressed: () {
                                            form['paciente_id'] = p.id;
                                            form['fecha'] =
                                                DateTime.now().toString();
                                            print(form.toString());
                                            var hD = new HistoryDao();
                                            hD.insert(new History(
                                                id: null,
                                                data: Map.from(form)));
                                            print('ya');
                                            _tabController.index++;
                                          },
                                          child: Text('Guardar'))
                                    ],
                                  ),
                                ]),
                          )))
                ],
              ),
            ),
    );
  }
}
