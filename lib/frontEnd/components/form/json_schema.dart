library json_to_form;

import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:sicma/frontEnd/components/form/datepicker.dart';
import 'package:sicma/frontEnd/components/form/field.dart';
import 'package:sicma/frontEnd/components/form/formula.dart';

class JsonSchema extends StatefulWidget {
  const JsonSchema({
    @required this.editable,
    @required this.form,
    @required this.data,
    @required this.onChanged,
    this.padding,
    this.formMap,
    this.errorMessages = const {},
    this.validations = const {},
    this.decorations = const {},
    this.buttonSave,
    this.actionSave,
    GlobalKey<FormState> key,
  });

  final Map errorMessages;
  final Map validations;
  final Map decorations;
  final String form;
  final dynamic data;
  final bool editable;
  final Map formMap;
  final double padding;
  final Widget buttonSave;
  final Function actionSave;
  final ValueChanged<dynamic> onChanged;

  @override
  _CoreFormState createState() =>
      new _CoreFormState(formMap ?? json.decode(form));
}

class _CoreFormState extends State<JsonSchema> {
  final dynamic formGeneral;

  List<bool> visible = [];

  initData() {
    if (widget.data != null) {
      widget.data.forEach((key, value) {
        var n = formGeneral['fields'].length;
        print("n: " + n.toString());
        for (var count1 = 0; count1 < formGeneral['fields'].length; count1++) {
          //Recorre por cada elemento el "fields"
          Map item = formGeneral['fields']
              [count1]; //Mapea la informacion de cada "field"
          if (key == item['title']) {
            item['value'] = value;

            var k = item['key'];
            var v = value;
            Map field = new Map();
            field[k] = v;
            _handleChanged(field);
          }
        }
      });
    }
  }

  int radioValue;

  // validators

  String isRequired(item, value) {
    if (value.isEmpty) {
      return widget.errorMessages[item['key']] ?? 'Please enter some text';
    }
    return null;
  }

  String validateEmail(item, String value) {
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(value)) {
      return null;
    }
    return 'Email is not valid';
  }

  bool labelHidden(item) {
    if (item.containsKey('hiddenLabel')) {
      if (item['hiddenLabel'] is bool) {
        return !item['hiddenLabel'];
      }
    } else {
      return true;
    }
    return false;
  }

  // Return widgets

  List<Widget> jsonToForm() {
    initData();

    List<Widget> listWidget = new List<Widget>();
    //Ciclo para recorrer cada elemento de "fileds"
    for (var count = 0; count < formGeneral['fields'].length; count++) {
      Map item = formGeneral['fields'][count]; //Mapea cada elemento de fileds

      //Comienza a crear cada "field"
      listWidget.addAll(getField(item));

      if (widget.buttonSave != null) {
        listWidget.add(new Container(
          margin: EdgeInsets.only(top: 10.0),
          child: InkWell(
            onTap: () {
              if (_formKey.currentState.validate()) {
                widget.actionSave(formGeneral);
              }
            },
            child: widget.buttonSave,
          ),
        ));
      }
      formGeneral['fields'][count] = item;
    }
    return listWidget;
  }

  getField(Map item) {
    List<Widget> listWidget = new List<Widget>();
    switch (item['type']) {
      case 'Section':
        List<Widget> widgets = [];
        if (item['label'] != null)
          widgets.add(Center(
              child: Text(item['label'],
                  style: new TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontWeight: FontWeight.normal,
                      fontSize: 20.0))));
        for (var count = 0; count < item['fields'].length; count++) {
          Map aux = item['fields'][count]; //Mapea cada elemento de fileds

          //Comienza a crear cada "field"
          widgets.addAll(getField(aux));
        }

        listWidget.add(
          Container(
            //padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(30.0),
                topRight: const Radius.circular(30.0),
              ),
            ),
            //margin: new EdgeInsets.only(top: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widgets,
            ),
          ),
        );
        return listWidget;

        break;

      case "Group":
        bool visible = item['state'] != null ? item['state'] : false;
        List<Widget> widgets = [];
        for (var count = 0; count < item['fields'].length; count++) {
          Map aux = item['fields'][count]; //Mapea cada elemento de fileds

          //Comienza a crear cada "field"
          widgets.addAll(getField(aux));
        }

        listWidget.add(Container(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: EdgeInsets.only(top: 20),
              child: Container(
                height: 1,
                color: Theme.of(context).primaryColor,
              )),
          Row(children: [
            Expanded(
                flex: 8,
                child: Text(item['label'],
                    style: new TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.normal,
                        fontSize: 22.0))),
            Expanded(
                flex: 1,
                child: IconButton(
                    color: Theme.of(context).primaryColor,
                    icon: Icon(visible
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down),
                    onPressed: () {
                      setState(() {
                        item['state'] = !visible;
                      });
                    })),
          ]),
          Visibility(visible: visible, child: Column(children: widgets))
        ])));

        break;

      case "Input":
      case "Password":
      case "Email":
      case "TextArea":
      case "TextInput":
        Widget label = SizedBox.shrink();
        if (labelHidden(item)) {
          label = new Container(
            //  padding: EdgeInsets.only(left: 20),
            child: new Text(
              item['label'],
              style:
                  new TextStyle(fontWeight: FontWeight.normal, fontSize: 16.0),
            ),
          );
        }

        listWidget.add(new Container(
          margin: new EdgeInsets.only(top: 5.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              label,
              new TextFormField(
                cursorColor: Theme.of(context).primaryColorDark,
                enabled: widget.editable,
                controller: null,
                initialValue: item['value'] ?? null,
                decoration: item['decoration'] ??
                    widget.decorations[item['key']] ??
                    InputDecoration(
                        contentPadding: EdgeInsets.only(left: 15),
                        hintText: item['placeholder'],
                        // labelText: item['label'],
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)))),
                maxLines: item['type'] == "TextArea" ? 10 : 1,
                onChanged: (String value) {
                  item['value'] = value;
                  var k = item['key'];
                  var v = value;
                  Map field = new Map();
                  field[k] = v;
                  _handleChanged(field);
                },
                obscureText: item['type'] == "Password" ? true : false,
                validator: (value) {
                  if (widget.validations.containsKey(item['key'])) {
                    return widget.validations[item['key']](item, value);
                  }
                  if (item.containsKey('validator')) {
                    if (item['validator'] != null) {
                      if (item['validator'] is Function) {
                        return item['validator'](item, value);
                      }
                    }
                  }
                  if (item['type'] == "Email") {
                    return validateEmail(item, value);
                  }

                  if (item.containsKey('required')) {
                    if (item['required'] == true) {
                      return isRequired(item, value);
                    }
                  }

                  return null;
                },
              ),
            ],
          ),
        ));
        break;
      case "Date":
        Widget label = SizedBox.shrink();
        if (labelHidden(item)) {
          label = new Container(
            child: new Text(
              item['label'],
              style:
                  new TextStyle(fontWeight: FontWeight.normal, fontSize: 16.0),
            ),
          );
        }

        listWidget.add(new Container(
            margin: new EdgeInsets.only(top: 5.0),
            child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  label,
                  DatePicker(
                    prefixIcon: Icon(Icons.date_range),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                    lastDate: DateTime.now().add(Duration(days: 366)),
                    firstDate: DateTime(1900, 01),
                    initialDate: DateTime.now().add(Duration(days: 1)),
                    onDateChanged: (selectedDate) {
                      item['value'] = selectedDate;

                      var k = item['key'];
                      var v = selectedDate;
                      Map field = new Map();
                      field[k] = v;
                      _handleChanged(field);
                    },
                  )
                ])));
        break;
      case "Measure":
        listWidget.add(
          MeasuresField(
            label: item['label'],
            value: item['value'],
            editable: true, // item['editable'],
            isRequired: false,
            subLabel: item['unit'],
            onChanged: (value) {
              item['value'] = value;

              var k = item['key'];
              var v = value;
              Map field = new Map();
              field[k] = v;
              _handleChanged(field);
            },
          ),
        );
        break;
      case "Formula":
        listWidget.add(
          FormulaField(
            label: item['label'],
            value: item['value'],
            editable: false,
            items: item['items'],
            onChanged: (value) {
              item['value'] = value;

              var k = item['key'];
              var v = value;
              Map field = new Map();
              field[k] = v;
              _handleChanged(field);
            },
          ),
        );
        break;
      case "Phone":
        Widget label = SizedBox.shrink();
        if (labelHidden(item)) {
          label = new Container(
            padding: EdgeInsets.only(left: 20),
            child: new Text(
              item['label'],
              style:
                  new TextStyle(fontWeight: FontWeight.normal, fontSize: 16.0),
            ),
          );
        }

        listWidget.add(new Container(
          margin: new EdgeInsets.only(top: 5.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              label,
              new TextFormField(
                enabled: widget.editable,
                controller: null,
                initialValue: item['value'] ?? null,
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                keyboardType: TextInputType.number,
                decoration: item['decoration'] ??
                    widget.decorations[item['key']] ??
                    new InputDecoration(
                        contentPadding: EdgeInsets.only(left: 15),
                        hintText: item['placeholder'] ?? "",
                        helperText: item['helpText'] ?? "",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)))),
                maxLines: item['type'] == "TextArea" ? 10 : 1,
                onChanged: (String value) {
                  item['value'] = value;

                  var k = item['key'];
                  var v = value;
                  Map field = new Map();
                  field[k] = v;
                  _handleChanged(field);
                },
                validator: (value) {
                  if (widget.validations.containsKey(item['key'])) {
                    return widget.validations[item['key']](item, value);
                  }
                  if (item.containsKey('validator')) {
                    if (item['validator'] != null) {
                      if (item['validator'] is Function) {
                        return item['validator'](item, value);
                      }
                    }
                  }

                  if (item.containsKey('required')) {
                    if (item['required'] == true) {
                      return isRequired(item, value);
                    }
                  }

                  return null;
                },
              ),
            ],
          ),
        ));

        break;
      case "RadioButton":
        List<Widget> radios = [];

        if (labelHidden(item)) {
          radios.add(new Text(item['label'],
              style: new TextStyle(
                  fontWeight: FontWeight.normal, fontSize: 16.0)));
        }
        radioValue = item['value'];
        for (var i = 0; i < item['items'].length; i++) {
          radios.add(
            new Row(
              children: <Widget>[
                new Expanded(child: new Text(item['items'][i]['label'])),
                new Radio<int>(
                    value: item['items'][i]['value'],
                    groupValue: radioValue,
                    onChanged: (int value) {
                      this.setState(() {
                        radioValue = value;
                        item['value'] = value;

                        var k = item['key'];
                        var v = value;
                        Map field = new Map();
                        field[k] = v;
                        _handleChanged(field);
                      });
                    })
              ],
            ),
          );
        }

        listWidget.add(
          new Container(
            margin: new EdgeInsets.only(top: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: radios,
            ),
          ),
        );
        break;
      case "Switch":
        if (item['value'] == null) {
          item['value'] = false;
        }
        listWidget.add(
          new Container(
            margin: new EdgeInsets.only(top: 5.0),
            child: new Row(children: <Widget>[
              new Expanded(child: new Text(item['label'])),
              /*  new Switch(
                value: item['value'] ?? false,
                onChanged: (bool value) {
                  this.setState(() {
                    item['value'] = value;
                    _handleChanged();
                  });
                },
              ),*/
              RaisedButton(
                child: Text(item['value'] ? 'Sí' : 'No'),
                textColor: item['value']
                    ? Colors.white
                    : Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(color: Theme.of(context).primaryColor)),
                color: item['value']
                    ? Theme.of(context).primaryColor
                    : Colors.white,
                onPressed: () => widget.editable
                    ? setState(() {
                        item['value'] = !item['value'];

                        var k = item['key'];
                        var v = !item['value'];
                        Map field = new Map();
                        field[k] = v;
                        _handleChanged(field);
                      })
                    : '',
              ),
            ]),
          ),
        );
        break;
      case "Checkbox":
        List<Widget> checkboxes = [];
        if (labelHidden(item)) {
          checkboxes.add(new Text(item['label'],
              style: new TextStyle(
                  fontWeight: FontWeight.normal, fontSize: 16.0)));
        }
        for (var i = 0; i < item['items'].length; i++) {
          checkboxes.add(
            new Row(
              children: <Widget>[
                new Expanded(child: new Text(item['items'][i]['label'])),
                /* new Checkbox(
                  value: item['items'][i]['value'],
                  onChanged: (bool value) {
                    this.setState(
                      () {
                        item['items'][i]['value'] = value;
                        _handleChanged();
                      },
                    );
                  },
                ),*/
                RaisedButton(
                  child: Text(item['items'][i]['value'] ? 'Sí' : 'No'),
                  textColor: item['items'][i]['value']
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide(color: Theme.of(context).primaryColor)),
                  color: item['items'][i]['value']
                      ? Theme.of(context).primaryColor
                      : Colors.white,
                  onPressed: () => widget.editable
                      ? setState(() => item['items'][i]['value'] =
                          !item['items'][i]['value'])
                      : '',
                ),
              ],
            ),
          );
        }

        listWidget.add(
          new Container(
            margin: new EdgeInsets.only(top: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: checkboxes,
            ),
          ),
        );
        break;
      case "Select":
        Widget label = SizedBox.shrink();
        if (labelHidden(item)) {
          label = new Text(item['label'],
              style:
                  new TextStyle(fontWeight: FontWeight.normal, fontSize: 16.0));
        }

        listWidget.add(new Container(
          margin: new EdgeInsets.only(top: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              label,
              DropdownButtonFormField<String>(
                icon: Icon(Icons.keyboard_arrow_down),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 15, right: 15),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)))),
                hint: new Text(""),
                value: item['value'],
                onChanged: (String value) {
                  setState(() {
                    item['value'] = value;

                    HashMap field = new HashMap<String, dynamic>();
                    field[item['key']] = value;

                    _handleChanged(field);
                  });
                },
                items:
                    item['items'].map<DropdownMenuItem<String>>((dynamic data) {
                  return DropdownMenuItem<String>(
                    value: data['value'],
                    child: new Text(
                      data['label'],
                      style: new TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ));
        break;
      default:
    }
    return listWidget;
  }

  _CoreFormState(this.formGeneral);

  void _handleChanged(field) {
    widget.onChanged(field);
  }

  final _formKey = GlobalKey<FormState>();
  int _index = 0;
  buildMenu() {
    List<Widget> widgetForm = jsonToForm();
    List<Widget> menu = List();

    int i = 0;
    widgetForm.forEach((element) {
      menu.add(IconButton(
          icon: Icon(Icons.timeline),
          onPressed: () {
            setState(() {
              _index = i;
            });
          }));
      i++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidate: formGeneral['autoValidated'] ?? false,
      key: _formKey,
      child: Container(
        padding: new EdgeInsets.all(0.0),
        child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: jsonToForm()),
      ),
    );
  }
}
