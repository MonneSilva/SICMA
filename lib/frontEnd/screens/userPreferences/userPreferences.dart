import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sicma/backEnd/data/pacient/pacient.dart';
import 'package:sicma/backEnd/data/pacient/pacient_dao.dart';
import 'package:sicma/frontEnd/components/form/field.dart';
import 'package:sicma/frontEnd/components/form/row.dart';

class UserPreferencesScreen extends StatefulWidget {
  UserPreferencesScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _UserPreferencesScreenState createState() => _UserPreferencesScreenState();
}

class _UserPreferencesScreenState extends State<UserPreferencesScreen> {
  final controller = new TextEditingController();
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
                      "Nuevo paciente",
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
                              child: Text('Información Personal',
                                  style: new TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 22.0)),
                            ),
                            CustomField(
                              label: 'Teléfono',
                              editable: true,
                              isRequired: false,
                              type: 'date',
                              keyName: 'telefono',
                              formMap: form,
                              onChanged: (dynamic response) {
                                this.form = response;
                              },
                              /*validator: (value) {
                                if (value.isEmpty || !validateText(value)) {
                                  return 'Campo Obligatorio';
                                }
                                Map aux;
                                if (value.length != 10) {
                                  return 'Número no valido';
                                }
                                if (form.containsKey('contacto')) {
                                  aux = form['contacto'] as Map;
                                  aux['telefono'] = value;
                                  form['contacto'] = aux;
                                } else {
                                  aux = new Map();
                                  aux['telefono'] = value;
                                  form['contacto'] = aux;
                                }
                                return null;
                              },*/
/*onChanged: (value) {
                                  form['contacto'] = value;
                                }*/
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Theme.of(context).primaryColor)),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancelar')),
                          ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Theme.of(context).primaryColor)),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  form['_id'] = null;
                                  form['estado'] = true;
                                  form['fechaRegistro'] =
                                      DateTime.now().toString();
                                  /*Pacient p = new Pacient(
                                      id: null, data: Map.from(form));
                                  var pD = PacientDao();
                                  pD.insert(p);*/

                                  print(form);
                                  //_showMaterialDialog(p);
                                }
                              },
                              child: Text('Guardar'))
                        ],
                      )
                    ]))));
  }

  _showMaterialDialog(Pacient p) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("Historial Clínico"),
              content: new Text("¿Desea continuar con el Historial Clínico?"),
              actions: <Widget>[
                FlatButton(
                  child: Text('Cancelar'),
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
                    /*  Navigator.of(context).pushNamedAndRemoveUntil(
                        "/Paciente/View",
                        ModalRoute.withName('/Paciente/Search'),
                        arguments: p);
                    Navigator.of(context)
                        .pushNamed('/Historial/New', arguments: p);*/
                  },
                )
              ],
            ));
  }
}
