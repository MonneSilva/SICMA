library json_to_form;

import 'dart:convert';
import 'dart:ffi';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:meta/meta.dart';
import 'package:select_form_field/select_form_field.dart';

class FormulaField extends StatefulWidget {
  const FormulaField(
      {@required this.editable,
      this.onChanged,
      this.validator,
      this.label,
      this.keyName,
      this.controller,
      this.isRequired,
      this.items,
      this.value});
  final bool isRequired;
  final bool editable;
  final value;
  final String keyName;
  final ValueChanged<dynamic> validator;
  final String label;
  final ValueChanged<dynamic> onChanged;
  final controller;
  final List<dynamic> items;

  @override
  _FormulaFieldState createState() => _FormulaFieldState();
}

class _FormulaFieldState extends State<FormulaField> {
  var controller = TextEditingController();

  initData() {
    controller = widget.controller ?? TextEditingController();
    controller.text = widget.value ?? '';
  }

  functions(formula) {
    switch (formula) {
      case '':
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: EdgeInsets.only(left: 10, bottom: 20),
              child: Text(widget.label,
                  textAlign: TextAlign.left,
                  style: new TextStyle(
                      fontWeight: FontWeight.normal, fontSize: 16.0))),
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Expanded(
                flex: 4,
                child: Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(30.0),
                            bottomLeft: const Radius.circular(30.0),
                          ),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Padding(
                            padding: EdgeInsets.only(left: 20, top: 0),
                            child: DropdownButtonFormField<dynamic>(
                              decoration: InputDecoration(
                                filled: true,
                              ),
                              icon: const Icon(Icons.keyboard_arrow_down),
                              iconSize: 30,
                              elevation: 16,
                              style: const TextStyle(color: Colors.white),
                              onChanged: (dynamic newValue) {},
                              items: widget.items
                                  .map<DropdownMenuItem<dynamic>>(
                                      (dynamic value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                );
                              }).toList(),
                            ))))),
            Expanded(
                flex: 2,
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
                            topRight: const Radius.circular(30.0),
                            bottomRight: const Radius.circular(30.0),
                          ))),
                      validator: widget.validator ?? (value) {},
                      onChanged: widget.onChanged ?? (value) {},
                    ))),
          ])
        ]);
  }
}
