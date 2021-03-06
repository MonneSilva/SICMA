import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sembast/utils/value_utils.dart';
import 'package:flutter/services.dart';
import 'package:sicma/backEnd/data/pacient/pacient.dart';
import 'package:sicma/backEnd/data/pacient/pacient_dao.dart';
import 'package:intl/intl.dart';
import 'package:sicma/frontEnd/components/form/field.dart';
import 'package:sicma/frontEnd/components/form/row.dart';

class FormScreenPaciente extends StatefulWidget {
  FormScreenPaciente({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FormScreenPacienteState createState() => _FormScreenPacienteState();
}

class _FormScreenPacienteState extends State<FormScreenPaciente> {
  final birthdate = new TextEditingController();
  Map form = new Map();
  Map data;
  bool isLoading;
  final _formKey = GlobalKey<FormState>();
  @override
  initState() {
    super.initState();
    _fetchData();
  }

  getItems(data) {
    return (data as List)
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  _fetchData() async {
    setState(() {
      isLoading = true;
    });
    dynamic response = json.decode(
        await rootBundle.loadString("lib/backEnd/data/json/pacient.json"));
    if (response != null) {
      data = Map.from(response);
      setState(() {
        isLoading = false;
      });
    }
  }

  validateEmail(String value) {
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(value)) {
      return true;
    }
    return false;
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

  @override
  Widget build(BuildContext context) {
    final Pacient p = ModalRoute.of(context).settings.arguments as Pacient;
    bool hasData = p != null ? true : false;
    hasData ? form = cloneMap(p.data) : new Map();

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
                    iconTheme: IconThemeData(
                        color: Theme.of(context).primaryColorLight),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20))),
                    backgroundColor: Colors.transparent,
                    centerTitle: true,
                    title: Text(
                      hasData ? 'Editar Paciente' : "Nuevo paciente",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  )
                ])),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(30.0),
                    topRight: const Radius.circular(30.0),
                  ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.16),
                        spreadRadius: 3,
                        blurRadius: 3,
                        offset: Offset(7, 0)),
                  ],
                ),
                child: Container(
                    padding: EdgeInsets.all(20),
                    child: ListView(children: <Widget>[
                      Form(
                          key: _formKey,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Text('Informaci??n Personal',
                                      textAlign: TextAlign.center,
                                      style: new TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22.0)),
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text('*Campos obligatorios',
                                          style: TextStyle(fontSize: 10))
                                    ]),
                                CustomField(
                                  keyName: 'nombre',
                                  label: 'Nombre*',
                                  maxLength: 45,
                                  editable: true,
                                  isRequired: true,
                                  value:
                                      hasData ? form['nombre']['nombre'] : '',
                                  type: 'text',
                                  validator: (value) {
                                    if (value.isEmpty || !validateText(value)) {
                                      return 'Campo Obligatorio';
                                    }
                                    Map name;

                                    if (form.containsKey('nombre')) {
                                      name = form['nombre'];
                                      name['nombre'] = value;
                                      form['nombre'] = name;
                                    } else {
                                      name = new Map();
                                      name['nombre'] = value;
                                      form['nombre'] = name;
                                    }
                                    return null;
                                  },
                                ),
                                CustomField(
                                    label: 'Apellido Paterno*',
                                    maxLength: 45,
                                    editable: true,
                                    isRequired: true,
                                    type: 'text',
                                    keyName: 'apellidoPat',
                                    value: hasData
                                        ? form['nombre']['apellidoPat']
                                        : '',
                                    validator: (value) {
                                      if (value.isEmpty ||
                                          !validateText(value)) {
                                        return 'Campo Obligatorio';
                                      }
                                      Map name;

                                      if (form.containsKey('nombre')) {
                                        name = form['nombre'];
                                        name['apellidoPat'] = value;
                                        form['nombre'] = name;
                                      } else {
                                        name = new Map();
                                        name['apellidoPat'] = value;
                                        form['nombre'] = name;
                                      }
                                      return null;
                                    }),
                                CustomField(
                                  label: 'Apellido Materno',
                                  maxLength: 45,
                                  editable: true,
                                  isRequired: false,
                                  type: 'text',
                                  keyName: 'apellidoMat',
                                  value: hasData
                                      ? form['nombre']['apellidoMat']
                                      : '',
                                  validator: (value) {
                                    if (value.isEmpty || !validateText(value)) {
                                      Map name;
                                      if (form.containsKey('nombre')) {
                                        name = form['nombre'] as Map;
                                        if (name.containsKey('apellidoMat'))
                                          name.remove('apellidoMat');
                                      }
                                    } else {
                                      Map name;
                                      if (form.containsKey('nombre')) {
                                        name = form['nombre'] as Map;
                                        name['apellidoMat'] = value;
                                        form['nombre'] = name;
                                      } else {
                                        name = new Map();
                                        name['apellidoMat'] = value;
                                        form['nombre'] = name;
                                      }
                                      return null;
                                    }
                                  },
                                ),
                                CustomRow(columns: 2, children: [
                                  CustomField(
                                      label: 'F. de Nacimiento*',
                                      editable: true,
                                      isRequired: true,
                                      type: 'date',
                                      keyName: 'fechaNacimiento',
                                      formMap: form,
                                      value: hasData
                                          ? form['fechaNacimiento']
                                          : '',
                                      onChanged: (dynamic response) {
                                        this.form.addAll(response);
                                        birthdate.text = getAge(
                                                response['fechaNacimiento']
                                                    .toString()
                                                    .replaceAll(" ", ""))
                                            .toString();
                                      }),
                                  CustomField(
                                    label: 'Lugar de Nacimiento',
                                    maxLength: 45,
                                    editable: true,
                                    isRequired: false,
                                    type: 'text',
                                    keyName: 'lugarNacimiento',
                                    value:
                                        hasData ? form['lugarNacimiento'] : '',
                                    formMap: form,
                                    onChanged: (dynamic response) {
                                      this.form.addAll(response);
                                    },
                                  )
                                ]),
                                CustomRow(columns: 2, children: [
                                  CustomField(
                                    label: 'Sexo*',
                                    editable: true,
                                    isRequired: true,
                                    type: 'select',
                                    keyName: 'sexo',
                                    formMap: form,
                                    value: hasData ? form['sexo'] : '',
                                    items: getItems(data['sexo']),
                                    onChanged: (dynamic response) {
                                      this.form.addAll(response);
                                    },
                                  ),
                                  CustomField(
                                    controller: birthdate,
                                    label: 'Edad',
                                    editable: false,
                                    type: 'text',
                                    value: hasData
                                        ? getAge(form['fechaNacimiento']
                                                .toString()
                                                .replaceAll(" ", ""))
                                            .toString()
                                        : '',
                                  ),
                                ]),
                                CustomRow(
                                  columns: 2,
                                  children: [
                                    CustomField(
                                      label: 'Escolaridad',
                                      editable: true,
                                      isRequired: false,
                                      type: 'select',
                                      value: hasData ? form['escolaridad'] : '',
                                      validator: (value) {
                                        return null;
                                      },
                                      keyName: 'escolaridad',
                                      formMap: form,
                                      onChanged: (dynamic response) {
                                        this.form.addAll(response);
                                      },
                                      items: getItems(data['escolaridad']),
                                    ),
                                    CustomField(
                                      label: 'Ocupaci??n',
                                      maxLength: 45,
                                      editable: true,
                                      isRequired: false,
                                      type: 'text',
                                      keyName: 'ocupacion',
                                      value: hasData ? form['ocupacion'] : '',
                                      formMap: form,
                                      onChanged: (dynamic response) {
                                        this.form.addAll(response);
                                      },
                                    ),
                                  ],
                                ),
                                CustomRow(
                                  columns: 2,
                                  children: [
                                    CustomField(
                                      label: 'Religi??n',
                                      editable: true,
                                      isRequired: false,
                                      type: 'select',
                                      value: hasData ? form['religion'] : '',
                                      validator: (value) {
                                        return null;
                                      },
                                      items: getItems(data['religion']),
                                      keyName: 'religion',
                                      formMap: form,
                                      onChanged: (dynamic response) {
                                        this.form.addAll(response);
                                      },
                                    ),
                                    CustomField(
                                      label: 'Edo. Civ??l',
                                      editable: true,
                                      isRequired: false,
                                      type: 'select',
                                      items: getItems(data['edoCivil']),
                                      keyName: 'edoCivil',
                                      value: hasData ? form['edoCivil'] : '',
                                      formMap: form,
                                      onChanged: (dynamic response) {
                                        this.form.addAll(response);
                                      },
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 20, bottom: 20),
                                  padding: EdgeInsets.only(top: 10),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          top: BorderSide(
                                              width: 2.0,
                                              color: Theme.of(context)
                                                  .primaryColor))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: Text('Contacto',
                                            style: new TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22.0)),
                                      ),
                                      CustomField(
                                          label: 'Tel??fono*',
                                          editable: true,
                                          isRequired: true,
                                          type: 'phone',
                                          keyName: 'telefono',
                                          value: hasData
                                              ? form['contacto']['telefono']
                                              : '',
                                          validator: (value) {
                                            if (value.isEmpty ||
                                                !validateText(value)) {
                                              return 'Campo Obligatorio';
                                            }
                                            Map name;
                                            if (form.containsKey('contacto')) {
                                              name = form['contacto'] as Map;
                                              name['telefono'] = value;
                                              form['contacto'] = name;
                                            } else {
                                              name = new Map();
                                              name['telefono'] = value;
                                              form['contacto'] = name;
                                            }
                                            return null;
                                          }),
                                      CustomField(
                                          label: 'Correo Electr??nico*',
                                          maxLength: 320,
                                          editable: true,
                                          isRequired: true,
                                          type: 'email',
                                          keyName: 'correo',
                                          value: hasData
                                              ? form['contacto']['correo']
                                              : '',
                                          validator: (value) {
                                            Map name;

                                            if (form.containsKey('contacto')) {
                                              name = form['contacto'] as Map;
                                              name['correo'] = value;
                                              form['contacto'] = name;
                                            } else {
                                              name = new Map();
                                              name['correo'] = value;
                                              form['contacto'] = name;
                                            }
                                            return null;
                                          }),
                                    ],
                                  ),
                                ),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      ButtonTheme(
                                          minWidth: 130,
                                          height: 35.0,
                                          child: RaisedButton(
                                              textColor: Colors.white,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Cancelar'))),
                                      ButtonTheme(
                                          minWidth: 130,
                                          height: 35.0,
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
                                                    .validate()) {
                                                  var pD = PacientDao();
                                                  if (!hasData) {
                                                    form['_id'] = null;
                                                    form['estado'] = true;
                                                    form['fechaRegistro'] =
                                                        DateTime.now()
                                                            .toString();
                                                    form.remove('null');
                                                    Pacient pacient =
                                                        new Pacient(
                                                            id: null,
                                                            data:
                                                                Map.from(form));
                                                    pD.insert(pacient);
                                                    Navigator.of(context)
                                                        .pushNamedAndRemoveUntil(
                                                            "/Paciente/View",
                                                            ModalRoute.withName(
                                                                '/Paciente/Search'),
                                                            arguments: pacient);
                                                  } else {
                                                    form.remove('null');
                                                    p.data = Map.from(form);
                                                    pD.update(p);
                                                    Navigator.of(context)
                                                        .popAndPushNamed(
                                                            '/Pacient/View',
                                                            arguments: p);
                                                  }

                                                  print(form);
                                                }
                                              },
                                              child: Text('Guardar')))
                                    ]),
                              ]))
                    ]))));
  }

  _showMaterialDialog(Pacient p) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("Historial Cl??nico"),
              content: new Text("??Desea continuar con el Historial Cl??nico?"),
              actions: <Widget>[
                FlatButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        "/Paciente/View",
                        ModalRoute.withName('/Paciente/Search'),
                        arguments: p);
                  },
                ),
                FlatButton(
                  child: Text('Aceptar'),
                  onPressed: () {
                    print(form.toString());

                    Navigator.of(context).pushNamedAndRemoveUntil(
                        "/Historial/New", ModalRoute.withName('/Home'),
                        arguments: p);
                  },
                )
              ],
            ));
  }
}

getAge(date) {
  DateTime birthDate = DateFormat('dd/MM/yyyy').parse(date);
  DateTime currentDate = DateTime.now();
  int age = currentDate.year - birthDate.year;
  int month1 = currentDate.month;
  int month2 = birthDate.month;
  if (month2 > month1) {
    age--;
  } else if (month1 == month2) {
    int day1 = currentDate.day;
    int day2 = birthDate.day;
    if (day2 > day1) {
      age--;
    }
  }
  return age;
}
