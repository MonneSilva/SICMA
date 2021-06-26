//import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sicma/backEnd/data/pacient/pacient.dart';
import 'package:sicma/frontEnd/components/bluetooth/BTconnection.dart';
import 'package:sicma/frontEnd/components/cam/camara.dart';
import 'package:sicma/frontEnd/components/form/checkbox.dart';
import 'package:sicma/frontEnd/components/form/field.dart';
import 'package:sicma/frontEnd/components/form/row.dart';
import 'package:sicma/frontEnd/components/form/section.dart';
import 'package:sicma/frontEnd/components/tab/tabView.dart';

class NewScreenConsulta extends StatefulWidget {
  NewScreenConsulta({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NewScreenConsultaState createState() => _NewScreenConsultaState();
}

class _NewScreenConsultaState extends State<NewScreenConsulta>
    with TickerProviderStateMixin {
  TabController _tabController;
  Map form = new Map();
  Map data;
  Map meassures;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _tabController = new TabController(length: 4, vsync: this);
    super.initState();
    _fetchData();
  }

  getItems(data) {
    return (data as List)
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  validateText(text) {
    if (text != null) {
      String test = text;
      test = test.split(" ").join('');
      if (test.length == 0) {
        return false;
      }

      return true;
    }
    return false;
  }

  var isLoading = false;
  _fetchData() async {
    setState(() {
      isLoading = true;
    });
    dynamic response = json.decode(
        await rootBundle.loadString("lib/backEnd/data/json/pacient.json"));

    dynamic meassure = json.decode(
        await rootBundle.loadString("lib/backEnd/data/json/meassures.json"));

    if (response != null && meassure != null) {
      data = Map.from(response);
      meassures = Map.from(meassure);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Miniature photo1 = new Miniature();
    final Pacient p = ModalRoute.of(context).settings.arguments as Pacient;
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
                    "Consulta",
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
                                      CustomField(
                                        label: 'Sintomas:',
                                        editable: true,
                                        isRequired: false,
                                        type: 'text',
                                        items: getItems(data['enfermedades']
                                            ['heredofamiliares']),
                                      ),
                                      CheckBoxButton(
                                        label: '¿Se encuentra en tratamiento?',
                                        editable: true,
                                        state: data['tratamientos'],
                                        /* isRequired: false,
                                        type: 'checkbox',*/
                                      ),
                                      CustomField(
                                        label: '¿Cúales?',
                                        editable: true,
                                        isRequired: false,
                                        type: 'text',
                                      ),
                                      CustomSection(
                                        label: "Signos Vitales",
                                        type: 'dropDown',
                                        children: [
                                          MeasuresField(
                                            label: 'Temperatura',
                                            editable: true,
                                            isRequired: false,
                                            subLabel: "°C",
                                          ),
                                          MeasuresField(
                                            label: 'Pulso',
                                            editable: true,
                                            isRequired: false,
                                            subLabel: "",
                                          ),
                                          MeasuresField(
                                            label: 'TA',
                                            editable: true,
                                            isRequired: false,
                                            subLabel: "",
                                          ),
                                        ],
                                      ),
                                      CustomSection(
                                        label: "Exploración Física",
                                        type: 'dropDown',
                                        children: [
                                          Wrap(
                                              spacing: 2.0,
                                              runSpacing: 2.0,
                                              children: [
                                                InputChip(
                                                  padding: EdgeInsets.all(2.0),
                                                  label: Text(
                                                    'nombre',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  selectedColor:
                                                      Colors.blue.shade600,
                                                  onSelected:
                                                      (bool selected) {},
                                                  onDeleted: () {
                                                    setState(() {});
                                                  },
                                                )
                                              ]),
                                          CustomRow(columns: 2, children: [
                                            CustomField(
                                              label: 'Área',
                                              editable: true,
                                              isRequired: false,
                                              type: 'select',
                                              items: getItems(data['sexo']),
                                            ),
                                            Container()
                                          ]),
                                          CustomField(
                                            label: 'Observación:',
                                            editable: true,
                                            isRequired: false,
                                            type: 'text',
                                            items: getItems(data['sexo']),
                                          ),
                                        ],
                                      ),
                                    ],
                                    childrenFooter: [
                                      ButtonTheme(
                                          minWidth: 150.0,
                                          height: 50.0,
                                          child: RaisedButton(
                                              textColor: Colors.white,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                              ),
                                              onPressed: () {
                                                if (_formKey.currentState
                                                    .validate()) {}
                                              },
                                              child: Text('Siguiente')))
                                    ],
                                  ),
                                  CustomTabView(
                                    title: 'Antropometría',
                                    children: [
                                      photo1,
                                      CustomSection(
                                        label: "Medidas Básicas",
                                        type: 'dropDown',
                                        children: getFields('Medidas básicas'),
                                      ),
                                      CustomSection(
                                        label: "Perímetros",
                                        type: 'dropDown',
                                        children: getFields('Perímetros'),
                                      ),
                                      CustomSection(
                                        label: "Diámetros",
                                        type: 'dropDown',
                                        children: getFields('Diámetros'),
                                      ),
                                      CustomSection(
                                        label: "Longitudes",
                                        type: 'dropDown',
                                        children: getFields('Longitudes'),
                                      ),
                                      CustomSection(
                                        label: "Pligues Cutáneos",
                                        type: 'dropDown',
                                        children: [BTconnection()],
                                      ),
                                    ],
                                    childrenFooter: [
                                      ButtonTheme(
                                          minWidth: 150,
                                          height: 50.0,
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
                                              child: Text('Siguiente'))),
                                    ],
                                  ),
                                  CustomTabView(
                                    title: 'Diagnóstico',
                                    children: [
                                      CustomSection(label: "IMC", children: [
                                        CustomRow(
                                          columns: 2,
                                          children: [
                                            CustomField(
                                              label: '',
                                              editable: true,
                                              isRequired: false,
                                              type: 'select',
                                              validator: (value) {
                                                return null;
                                              },
                                              items:
                                                  getItems(data['grupoSangre']),
                                              onChanged: (value) {
                                                form['escolaridad'] = value;
                                              },
                                            ),
                                            CustomField(
                                              label: '',
                                              editable: false,
                                              isRequired: false,
                                              type: 'text',
                                              validator: (value) {
                                                return null;
                                              },
                                              items: getItems(data['rh']),
                                              onChanged: (value) {
                                                form['escolaridad'] = value;
                                              },
                                            ),
                                          ],
                                        ),
                                      ]),
                                      CustomSection(label: "ICC", children: [
                                        CustomRow(
                                          columns: 2,
                                          children: [
                                            CustomField(
                                              label: '',
                                              editable: true,
                                              isRequired: false,
                                              type: 'select',
                                              validator: (value) {
                                                return null;
                                              },
                                              items:
                                                  getItems(data['grupoSangre']),
                                              onChanged: (value) {
                                                form['escolaridad'] = value;
                                              },
                                            ),
                                            CustomField(
                                              label: '',
                                              editable: false,
                                              isRequired: false,
                                              type: 'text',
                                              validator: (value) {
                                                return null;
                                              },
                                              items: getItems(data['rh']),
                                              onChanged: (value) {
                                                form['escolaridad'] = value;
                                              },
                                            ),
                                          ],
                                        ),
                                      ]),
                                      CustomSection(
                                          label: "% Grasa",
                                          children: [
                                            CustomRow(
                                              columns: 2,
                                              children: [
                                                CustomField(
                                                  label: '',
                                                  editable: true,
                                                  isRequired: false,
                                                  type: 'select',
                                                  validator: (value) {
                                                    return null;
                                                  },
                                                  items: getItems(
                                                      data['grupoSangre']),
                                                  onChanged: (value) {
                                                    form['escolaridad'] = value;
                                                  },
                                                ),
                                                CustomField(
                                                  label: '',
                                                  editable: false,
                                                  isRequired: false,
                                                  type: 'text',
                                                  validator: (value) {
                                                    return null;
                                                  },
                                                  items: getItems(data['rh']),
                                                  onChanged: (value) {
                                                    form['escolaridad'] = value;
                                                  },
                                                ),
                                              ],
                                            ),
                                          ]),
                                      CustomSection(
                                          label: "Complexión",
                                          children: [
                                            CustomRow(
                                              columns: 2,
                                              children: [
                                                CustomField(
                                                  label: '',
                                                  editable: true,
                                                  isRequired: false,
                                                  type: 'select',
                                                  validator: (value) {
                                                    return null;
                                                  },
                                                  items: getItems(
                                                      data['grupoSangre']),
                                                  onChanged: (value) {
                                                    form['escolaridad'] = value;
                                                  },
                                                ),
                                                CustomField(
                                                  label: '',
                                                  editable: false,
                                                  isRequired: false,
                                                  type: 'text',
                                                  validator: (value) {
                                                    return null;
                                                  },
                                                  items: getItems(data['rh']),
                                                  onChanged: (value) {
                                                    form['escolaridad'] = value;
                                                  },
                                                ),
                                              ],
                                            ),
                                          ]),
                                      CustomSection(label: "Pi", children: [
                                        CustomRow(
                                          columns: 2,
                                          children: [
                                            CustomField(
                                              label: '',
                                              editable: true,
                                              isRequired: false,
                                              type: 'select',
                                              validator: (value) {
                                                return null;
                                              },
                                              items:
                                                  getItems(data['grupoSangre']),
                                              onChanged: (value) {
                                                form['escolaridad'] = value;
                                              },
                                            ),
                                            CustomField(
                                              label: '',
                                              editable: false,
                                              isRequired: false,
                                              type: 'text',
                                              validator: (value) {
                                                return null;
                                              },
                                              items: getItems(data['rh']),
                                              onChanged: (value) {
                                                form['escolaridad'] = value;
                                              },
                                            ),
                                          ],
                                        ),
                                      ]),
                                      CustomSection(label: "% Pi", children: [
                                        CustomRow(
                                          columns: 2,
                                          children: [
                                            CustomField(
                                              label: '',
                                              editable: true,
                                              isRequired: false,
                                              type: 'select',
                                              validator: (value) {
                                                return null;
                                              },
                                              items:
                                                  getItems(data['grupoSangre']),
                                              onChanged: (value) {
                                                form['escolaridad'] = value;
                                              },
                                            ),
                                            CustomField(
                                              label: '',
                                              editable: false,
                                              isRequired: false,
                                              type: 'text',
                                              validator: (value) {
                                                return null;
                                              },
                                              items: getItems(data['rh']),
                                              onChanged: (value) {
                                                form['escolaridad'] = value;
                                              },
                                            ),
                                          ],
                                        ),
                                      ]),
                                      CustomSection(label: "% Ph", children: [
                                        CustomRow(
                                          columns: 2,
                                          children: [
                                            CustomField(
                                              label: '',
                                              editable: true,
                                              isRequired: false,
                                              type: 'select',
                                              validator: (value) {
                                                return null;
                                              },
                                              items:
                                                  getItems(data['grupoSangre']),
                                              onChanged: (value) {
                                                form['escolaridad'] = value;
                                              },
                                            ),
                                            CustomField(
                                              label: '',
                                              editable: false,
                                              isRequired: false,
                                              type: 'text',
                                              validator: (value) {
                                                return null;
                                              },
                                              items: getItems(data['rh']),
                                              onChanged: (value) {
                                                form['escolaridad'] = value;
                                              },
                                            ),
                                          ],
                                        ),
                                      ]),
                                      CustomSection(label: "PI", children: [
                                        CustomRow(
                                          columns: 2,
                                          children: [
                                            CustomField(
                                              label: '',
                                              editable: true,
                                              isRequired: false,
                                              type: 'select',
                                              validator: (value) {
                                                return null;
                                              },
                                              items:
                                                  getItems(data['grupoSangre']),
                                              onChanged: (value) {
                                                form['escolaridad'] = value;
                                              },
                                            ),
                                            CustomField(
                                              label: '',
                                              editable: false,
                                              isRequired: false,
                                              type: 'text',
                                              validator: (value) {
                                                return null;
                                              },
                                              items: getItems(data['rh']),
                                              onChanged: (value) {
                                                form['escolaridad'] = value;
                                              },
                                            ),
                                          ],
                                        ),
                                      ]),
                                      CustomSection(
                                          label: "Densidad",
                                          children: [
                                            CustomRow(
                                              columns: 2,
                                              children: [
                                                CustomField(
                                                  label: '',
                                                  editable: true,
                                                  isRequired: false,
                                                  type: 'select',
                                                  validator: (value) {
                                                    return null;
                                                  },
                                                  items: getItems(
                                                      data['grupoSangre']),
                                                  onChanged: (value) {
                                                    form['escolaridad'] = value;
                                                  },
                                                ),
                                                CustomField(
                                                  label: '',
                                                  editable: false,
                                                  isRequired: false,
                                                  type: 'text',
                                                  validator: (value) {
                                                    return null;
                                                  },
                                                  items: getItems(data['rh']),
                                                  onChanged: (value) {
                                                    form['escolaridad'] = value;
                                                  },
                                                ),
                                              ],
                                            ),
                                          ]),
                                      CustomSection(
                                          label: "Actividad Física",
                                          children: [
                                            CustomRow(
                                              columns: 2,
                                              children: [
                                                CustomField(
                                                  label: '',
                                                  editable: true,
                                                  isRequired: false,
                                                  type: 'select',
                                                  validator: (value) {
                                                    return null;
                                                  },
                                                  items: getItems(
                                                      data['grupoSangre']),
                                                  onChanged: (value) {
                                                    form['escolaridad'] = value;
                                                  },
                                                ),
                                                CustomField(
                                                  label: '',
                                                  editable: false,
                                                  isRequired: false,
                                                  type: 'text',
                                                  validator: (value) {
                                                    return null;
                                                  },
                                                  items: getItems(data['rh']),
                                                  onChanged: (value) {
                                                    form['escolaridad'] = value;
                                                  },
                                                ),
                                              ],
                                            ),
                                          ]),
                                    ],
                                    childrenFooter: [
                                      ButtonTheme(
                                          minWidth: 150.0,
                                          height: 50.0,
                                          child: RaisedButton(
                                              textColor: Colors.white,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                              ),
                                              onPressed: () {
                                                if (_formKey.currentState
                                                    .validate()) {}
                                              },
                                              child: Text('Siguiente')))
                                    ],
                                  ),
                                  CustomTabView(
                                    title: 'Plan Nutricional',
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 20),
                                        child: CustomField(
                                          editable: true,
                                          type: 'text',
                                          orientation: 'horizontal',
                                          label: 'Tipo de dieta:',
                                        ),
                                      ),
                                      CustomSection(
                                          label: "Cálculo Dietético",
                                          type: 'dropDown',
                                          children: [
                                            CustomRow(
                                              columns: 2,
                                              children: [
                                                CustomField(
                                                  label: 'GEB',
                                                  editable: true,
                                                  isRequired: false,
                                                  type: 'select',
                                                  validator: (value) {
                                                    return null;
                                                  },
                                                  items: getItems(
                                                      data['grupoSangre']),
                                                  onChanged: (value) {
                                                    form['escolaridad'] = value;
                                                  },
                                                ),
                                                CustomField(
                                                  label: ' ',
                                                  editable: false,
                                                  isRequired: false,
                                                  type: 'text',
                                                  validator: (value) {
                                                    return null;
                                                  },
                                                  items: getItems(data['rh']),
                                                  onChanged: (value) {
                                                    form['escolaridad'] = value;
                                                  },
                                                ),
                                              ],
                                            ),
                                            CustomRow(
                                              columns: 2,
                                              children: [
                                                CustomField(
                                                  label: 'ETA',
                                                  editable: true,
                                                  isRequired: false,
                                                  type: 'select',
                                                  validator: (value) {
                                                    return null;
                                                  },
                                                  items: getItems(
                                                      data['grupoSangre']),
                                                  onChanged: (value) {
                                                    form['escolaridad'] = value;
                                                  },
                                                ),
                                                CustomField(
                                                  label: ' ',
                                                  editable: false,
                                                  isRequired: false,
                                                  type: 'text',
                                                  validator: (value) {
                                                    return null;
                                                  },
                                                  items: getItems(data['rh']),
                                                  onChanged: (value) {
                                                    form['escolaridad'] = value;
                                                  },
                                                ),
                                              ],
                                            ),
                                            CustomRow(
                                              columns: 2,
                                              children: [
                                                CustomField(
                                                  label: 'AF',
                                                  editable: true,
                                                  isRequired: false,
                                                  type: 'select',
                                                  validator: (value) {
                                                    return null;
                                                  },
                                                  items: getItems(
                                                      data['grupoSangre']),
                                                  onChanged: (value) {
                                                    form['escolaridad'] = value;
                                                  },
                                                ),
                                                CustomField(
                                                  label: ' ',
                                                  editable: false,
                                                  isRequired: false,
                                                  type: 'text',
                                                  validator: (value) {
                                                    return null;
                                                  },
                                                  items: getItems(data['rh']),
                                                  onChanged: (value) {
                                                    form['escolaridad'] = value;
                                                  },
                                                ),
                                              ],
                                            ),
                                            CustomRow(
                                              columns: 2,
                                              children: [
                                                CustomField(
                                                  label: 'GET',
                                                  editable: true,
                                                  isRequired: false,
                                                  type: 'select',
                                                  validator: (value) {
                                                    return null;
                                                  },
                                                  items: getItems(
                                                      data['grupoSangre']),
                                                  onChanged: (value) {
                                                    form['escolaridad'] = value;
                                                  },
                                                ),
                                                CustomField(
                                                  label: ' ',
                                                  editable: false,
                                                  isRequired: false,
                                                  type: 'text',
                                                  validator: (value) {
                                                    return null;
                                                  },
                                                  items: getItems(data['rh']),
                                                  onChanged: (value) {
                                                    form['escolaridad'] = value;
                                                  },
                                                ),
                                              ],
                                            ),
                                          ]),
                                      CustomSection(
                                          label: "Recordatorio 24 horas",
                                          type: 'dropDown',
                                          children: []),
                                      CustomSection(
                                          label: "Plan Semanal",
                                          type: 'dropDown',
                                          children: []),
                                      CustomField(
                                        label: 'Observaciones generales:',
                                        editable: true,
                                        isRequired: false,
                                        type: 'text',
                                        items: getItems(data['sexo']),
                                      ),
                                    ],
                                    childrenFooter: [
                                      ButtonTheme(
                                          minWidth: 300.0,
                                          height: 50.0,
                                          child: RaisedButton(
                                              textColor: Colors.white,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                              ),
                                              /* style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Theme.of(context)
                                                          .primaryColor)),*/
                                              onPressed: () {
                                                if (_formKey.currentState
                                                    .validate()) {}
                                              },
                                              child: Text('Guardar')))
                                    ],
                                  ),
                                ]),
                          )))
                ],
              ),
            ),
    );
  }

  getFields(title) {
    List m = meassures[title];
    List<Widget> widgets = new List();
    int i = 0;

    m.forEach((element) {
      widgets.add(MeasuresField(
        subLabel: 'cm',
        label: element['label'],
        editable: true,
        isRequired: true,
      ));
    });

    return widgets;
  }

  Widget buildChips(_values) {
    List<Widget> chips = new List();

    for (int i = 0; i < _values.length; i++) {
      InputChip actionChip = InputChip(
        label: Text(_values[i]),
        avatar: FlutterLogo(),
        elevation: 10,
        pressElevation: 5,
        shadowColor: Colors.teal,
        onDeleted: () {
          _values.removeAt(i);
          //_selected.removeAt(i);

          setState(() {
            _values = _values;
            //_selected = _selected;
          });
        },
      );

      chips.add(actionChip);
    }

    return ListView(
        // This next line does the trick.
        scrollDirection: Axis.horizontal,
        children: [Wrap(spacing: 2.0, runSpacing: 2.0, children: chips)]);
  }
}
