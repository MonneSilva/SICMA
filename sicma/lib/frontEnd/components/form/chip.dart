import 'package:flutter/material.dart';

class CustomChip extends StatefulWidget {
  const CustomChip({
    this.label,
  });
  final String label;

  @override
  _CustomChipState createState() => _CustomChipState();
}

class _CustomChipState extends State<CustomChip> {
  TextEditingController _textEditingController = new TextEditingController();
  List<String> _values = new List();
  List<bool> _selected = new List();
  Widget buildChips() {
    List<Widget> chips = new List();

    for (int i = 0; i < _values.length; i++) {
      InputChip actionChip = InputChip(
        selected: _selected[i],
        label: Text(_values[i]),
        avatar: FlutterLogo(),
        elevation: 10,
        pressElevation: 5,
        shadowColor: Colors.teal,
        onPressed: () {
          setState(() {
            _selected[i] = !_selected[i];
          });
        },
        onDeleted: () {
          _values.removeAt(i);
          _selected.removeAt(i);

          setState(() {
            _values = _values;
            _selected = _selected;
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

  @override
  Widget build(BuildContext context) {
    return buildChips();
  }
}
