library json_to_form;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:select_form_field/select_form_field.dart';

class CustomRow extends StatefulWidget {
  const CustomRow({@required this.children, @required this.columns});
  final List<Widget> children;
  final int columns;

  @override
  _CustomRowState createState() => new _CustomRowState();
}

class _CustomRowState extends State<CustomRow> {
  @override
  Widget build(BuildContext context) {
    int flex;
    List<Widget> widgets = new List();
    switch (widget.columns) {
      case 2:
        flex = 2;
        break;
    }
    int i = 0;
    if (widget.children.length > 0) {
      widget.children.forEach((element) {
        i++;
        widgets.add(Expanded(
            flex: flex,
            child: Padding(
              padding: (i > 0 && i < widget.children.length)
                  ? EdgeInsets.only(right: 10)
                  : EdgeInsets.only(right: 0),
              child: element,
            )));
      });
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }
}
