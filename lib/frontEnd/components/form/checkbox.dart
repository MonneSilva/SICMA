library json_to_form;

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class CheckBoxButton extends StatefulWidget {
  const CheckBoxButton(
      {@required this.editable, this.state, @required this.label});
  final bool state;
  final bool editable;
  final String label;

  @override
  _CheckBoxButtonState createState() => new _CheckBoxButtonState();
}

class _CheckBoxButtonState extends State<CheckBoxButton> {
  @override
  void initState() {
    _value = widget.state != null ? widget.state : false;
    super.initState();
  }

  bool _value;
  void _valueChanged(bool value) => setState(() => _value = !value);
  @override
  Widget build(BuildContext context) {
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
              _value ? 'Sí' : 'No',
            ),
            textColor: _value ? Colors.white : Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
                side: BorderSide(color: Theme.of(context).primaryColor)),
            color: _value ? Theme.of(context).primaryColor : Colors.white,
            onPressed: () => widget.editable ? _valueChanged(_value) : '',
          ),
        ],
      )
    ]);
  }
}
