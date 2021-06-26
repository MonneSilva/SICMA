library json_to_form;

import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:meta/meta.dart';
import 'package:select_form_field/select_form_field.dart';

class CustomField extends StatefulWidget {
  const CustomField(
      {@required this.editable,
      @required this.type,
      this.data,
      this.value,
      this.maxLength,
      this.onChanged,
      this.padding,
      this.validator,
      this.buttonSave,
      this.actionSave,
      this.form,
      this.label,
      this.keyName,
      this.formMap,
      this.title,
      this.items,
      this.isRequired,
      this.orientation,
      this.controller});
  final dynamic value;
  final int maxLength;
  final List<Map> items;
  final bool isRequired;
  final String type;
  final String keyName;
  final String title;
  final ValueChanged<dynamic> validator;
  final String form;
  final String data;
  final String label;
  final bool editable;
  final Map formMap;
  final double padding;
  final Widget buttonSave;
  final Function actionSave;
  final ValueChanged<dynamic> onChanged;
  final String orientation;
  final controller;

  @override
  _CustomFieldState createState() =>
      _CustomFieldState(formMap ?? new Map<String, dynamic>());
}

class _CustomFieldState extends State<CustomField> {
  final Map formGeneral;
  TextEditingController controller;
  bool _checked = false;

  _CustomFieldState(this.formGeneral);
  String isRequired(value) {
    if (value.isEmpty) {
      return 'Campo obligatorio';
    }
    return null;
  }

  initData() {
    controller = widget.controller ?? TextEditingController();
    // widget.controller.text = formGeneral[widget.keyName] ?? '';
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
      text = text.trim();
      String test = text;
      test = test.split(" ").join('');
      if (test.length == 0) {
        return false;
      }
      return true;
    }
    return false;
  }

  Widget getField() {
    initData();
    switch (widget.type) {
      case 'text':
        widget.value != null ? controller.text = widget.value : '';
        return (widget.orientation != 'horizontal')
            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                if (widget.label != '')
                  Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                      child: Text(widget.label,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 16.0))),
                TextFormField(
                  maxLength: widget.maxLength,
                  enabled: widget.editable,
                  controller: controller,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 15),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(30.0)))),
                  validator: widget.validator ??
                      (value) {
                        switch (widget.isRequired) {
                          case true: //is required
                            if (value.isEmpty || !validateText(value)) {
                              return 'Campo Obligatorio';
                            } else {
                              formGeneral[widget.keyName] = value;
                            }
                            return null;
                            break;
                          case false: // is not required
                            if (value.isEmpty || !validateText(value)) {
                              formGeneral.remove(widget.keyName);
                            } else {
                              formGeneral[widget.keyName] = value;
                            }
                            return null;
                            break;
                        }
                      },
                  onChanged: (value) {
                    formGeneral[widget.keyName] = value;

                    _handleChanged();
                  },
                )
              ])
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Expanded(
                        flex: 2,
                        child: Padding(
                            padding: EdgeInsets.only(
                              left: 10,
                            ),
                            child: Text(widget.label,
                                textAlign: TextAlign.left,
                                style: new TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16.0)))),
                    Expanded(
                        flex: 3,
                        child: Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: TextFormField(
                              maxLength: widget.maxLength,
                              enabled: widget.editable,
                              controller: controller,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 15),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30.0)))),
                              validator: (value) {
                                switch (widget.isRequired) {
                                  case true: //is required
                                    if (value.isEmpty || !validateText(value)) {
                                      return 'Campo Obligatorio';
                                    } else {
                                      formGeneral[widget.keyName] = value;
                                    }
                                    return null;
                                    break;
                                  case false: // is not required
                                    if (value.isEmpty || !validateText(value)) {
                                      formGeneral.remove(widget.keyName);
                                    } else {
                                      formGeneral[widget.keyName] = value;
                                    }
                                    return null;
                                    break;
                                }
                              },
                              onChanged: (value) {
                                formGeneral[widget.keyName] = value;
                                _handleChanged();
                              },
                            ))),
                  ]);

        break;
        
      case "checkboxGroup":
        List<Widget> listWidget = [];
        List<Widget> checkboxes = [];
        int i = 0;

        listWidget.add(
          Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(widget.label,
                  textAlign: TextAlign.left,
                  style: new TextStyle(
                      fontWeight: FontWeight.normal, fontSize: 16.0))),
        );
        widget.items.forEach((element) {
          i++;
          checkboxes.add(
            new Row(
              children: <Widget>[
                new Expanded(
                    child: new Text(element['nombre'],
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 16.0))),
/*new Checkbox(
                  value: element['value'] ?? false,
                  onChanged: (bool value) {
                    this.setState(
                      () {
                        element['value'] = value;
                      },
                    );
                  },
                ),*/
                RaisedButton(
                  child: Text(element['estado'] ? 'Sí' : 'No'),
                  textColor: element['estado']
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide(color: Theme.of(context).primaryColor)),
                  color: element['estado']
                      ? Theme.of(context).primaryColor
                      : Colors.white,
                  onPressed: () => widget.editable
                      ? setState(() => element['estado'] = !element['estado'])
                      : '',
                ),
              ],
            ),
          );
        });

        listWidget.add(new Container(
          margin: new EdgeInsets.only(top: 5.0),
          child: Padding(
            padding: EdgeInsets.only(right: 50, left: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: checkboxes,
            ),
          ),
        ));
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: listWidget,
        );
        break;
      case "checkbox":
        _checked = widget.value != null ? widget.value : false;
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: <Widget>[
              Expanded(
                  child: Text(
                widget.label,
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16.0),
              )),
              RaisedButton(
                child: Text(
                  _checked ? 'Sí' : 'No',
                ),
                textColor:
                    _checked ? Colors.white : Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(color: Theme.of(context).primaryColor)),
                color: _checked ? Theme.of(context).primaryColor : Colors.white,
                onPressed: () => widget.editable
                    ? setState(() {
                        _checked = !_checked;
                      })
                    : '',
              ),
            ],
          )
        ]);

        break;
      case 'select':
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (widget.label != '')
            Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                child: Text(widget.label,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 16.0))),
          SelectFormField(
            initialValue: widget.value,
            enabled: widget.editable,
            style: TextStyle(fontSize: 13),
            decoration: InputDecoration(
                suffixIcon: Icon(Icons.keyboard_arrow_down),
                contentPadding: EdgeInsets.only(left: 10, right: 0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)))),
            items: widget.items,
            onChanged: (value) {
              formGeneral[widget.keyName] = value;
              _handleChanged();
            },
            validator: (value) {
              switch (widget.isRequired) {
                case true: //is required
                  if (value.isEmpty) {
                    return 'Campo Obligatorio';
                  } else {
                    formGeneral[widget.keyName] = value;
                  }
                  return null;
                  break;
              }
            },
          )
        ]);
        break;
      case 'number':
        widget.value != null ? controller.text = widget.value : '';

        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
              child: Text(widget.label,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.normal, fontSize: 16.0))),
          TextFormField(
            maxLength: widget.maxLength,
            enabled: widget.editable,
            keyboardType: TextInputType.number,
            controller: controller,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 15),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)))),
            validator: widget.validator ??
                (value) {
                  return null;
                },
            onChanged: (value) {
              formGeneral[widget.keyName] = value;
              _handleChanged();
            },
          )
        ]);

        break;
      case 'phone':
        widget.value != null ? controller.text = widget.value : '';

        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
              child: Text(widget.label,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.normal, fontSize: 16.0))),
          TextFormField(
            maxLength: 10,
            enabled: widget.editable,
            keyboardType: TextInputType.number,
            controller: controller,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 15),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)))),
            validator: (value) {
              if (widget.isRequired) {
                if (value.isEmpty || !validateText(value)) {
                  return 'Campo Obligatorio';
                }
              } else {
                if (value.isEmpty || !validateText(value)) {
                  if (formGeneral.containsKey(widget.keyName)) {
                    formGeneral.remove(widget.keyName);
                  }
                  return null;
                }
              }
              if (value.length != 10) {
                return "Número telefónico a 10 digitos";
              }
              widget.validator(value);
              return null;
            },
            onChanged: (value) {
              formGeneral[widget.keyName] = value;
              _handleChanged();
            },
          )
        ]);

        break;
      case 'email':
        widget.value != null ? controller.text = widget.value : '';

        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
              child: Text(widget.label,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.normal, fontSize: 16.0))),
          TextFormField(
            maxLength: widget.maxLength,
            enabled: widget.editable,
            controller: controller,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 15),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)))),
            validator: (value) {
              if (widget.isRequired) {
                if (!validateEmail(value)) return 'Correo no valido';
              }
              if (value.isNotEmpty) {
                if (!validateEmail(value)) return 'Correo no valido';
              }
              widget.validator(value);
              return null;
            },
            onChanged: (value) {
              formGeneral[widget.keyName] = value;
              _handleChanged();
            },
          )
        ]);
        break;
      case 'date':
        widget.value != null ? controller.text = widget.value : '';

        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
              child: Text(widget.label,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.normal, fontSize: 16.0))),
          TextFormField(
              validator: (value) {
                if (value.isEmpty || !validateText(value)) {
                  return 'Campo Obligatorio';
                } else {
                  formGeneral[widget.keyName] = value.toString();
                }
                return null;
              },
              readOnly: true,
              controller: controller,
              enabled: true,
              decoration: InputDecoration(
                  suffixIcon: Icon(Icons.calendar_today),
                  contentPadding: EdgeInsets.only(left: 15),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)))),
              onTap: () {
                DatePicker.showDatePicker(context,
                    showTitleActions: true,
                    minTime: DateTime(1900, 1, 1),
                    maxTime: DateTime(DateTime.now().year - 18,
                        DateTime.now().month, DateTime.now().day),
                    theme: DatePickerTheme(
                        headerColor: Theme.of(context).primaryColor,
                        backgroundColor: Colors.white,
                        itemStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 18),
                        doneStyle:
                            TextStyle(color: Colors.white, fontSize: 16)),
                    onChanged: (value) {
                  formGeneral[widget.keyName] = value;
                  //_handleChanged();
                }, onConfirm: (value) {
                  controller.text =
                      DateFormat("dd / MM / yyyy").format(value).toString();
                  formGeneral[widget.keyName] = controller.text;
                  _handleChanged();
                }, currentTime: DateTime.now(), locale: LocaleType.es);
              }),
        ]);
        break;
    }
  }

  void _handleChanged() {
    widget.onChanged(formGeneral);
  }

  void _handleValidate() {
    widget.validator(formGeneral);
  }

  @override
  Widget build(BuildContext context) {
    return getField();
  }
}

class MeasuresField extends StatefulWidget {
  const MeasuresField(
      {@required this.editable,
      this.onChanged,
      this.validator,
      this.label,
      this.keyName,
      this.controller,
      this.isRequired,
      this.subLabel,
      this.value});
  final bool isRequired;
  final bool editable;
  final value;
  final String keyName;
  final ValueChanged<dynamic> validator;
  final String label;
  final ValueChanged<dynamic> onChanged;
  final controller;
  final String subLabel;

  @override
  _MeasuresFieldState createState() => _MeasuresFieldState();
}

class _MeasuresFieldState extends State<MeasuresField> {
  var controller = TextEditingController();
  String isRequired(value) {
    if (value.isEmpty) {
      return 'Campo obligatorio';
    }
    return null;
  }

  initData() {
    controller = widget.controller ?? TextEditingController();
  }

  Widget getField() {
    initData();
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Expanded(
          flex: 3,
          child: Padding(
              padding: EdgeInsets.only(left: 10, bottom: 20),
              child: Text(widget.label,
                  textAlign: TextAlign.left,
                  style: new TextStyle(
                      fontWeight: FontWeight.normal, fontSize: 16.0)))),
      Expanded(
          flex: 4,
          child: Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: TextFormField(
                keyboardType: TextInputType.number,
                enabled: widget.editable,
                controller: controller,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 15),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(30.0),
                      bottomLeft: const Radius.circular(30.0),
                    ))),
                validator: widget.validator ?? (value) {},
                onChanged: widget.onChanged ?? (value) {},
              ))),
      Expanded(
          flex: 1,
          child: Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: new BorderRadius.only(
                      topRight: const Radius.circular(30.0),
                      bottomRight: const Radius.circular(30.0),
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Padding(
                      padding: EdgeInsets.only(left: 5, top: 12),
                      child: Text(widget.subLabel,
                          textAlign: TextAlign.left,
                          style: new TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 13.0))))))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return getField();
  }
}
