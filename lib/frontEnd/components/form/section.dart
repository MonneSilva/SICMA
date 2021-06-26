import 'package:flutter/material.dart';

class CustomSection extends StatefulWidget {
  const CustomSection({this.children, this.label, this.type});
  final List<Widget> children;

  final String label;
  final String type;

  @override
  _CustomSectionState createState() => new _CustomSectionState();
}

class _CustomSectionState extends State<CustomSection> {
  bool visible = false;
  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case 'dropDown':
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: EdgeInsets.only(top: 20),
              child: Container(
                height: 1,
                color: Theme.of(context).primaryColor,
              )),
          Row(children: [
            Expanded(
                flex: 8,
                child: Text(widget.label,
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
                        visible = !visible;
                      });
                    })),
          ]),
          Visibility(visible: visible, child: Column(children: widget.children))
        ]);
        break;
      default:
        return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Padding(
              padding: EdgeInsets.only(top: 20),
              child: Container(
                height: 1,
                color: Theme.of(context).primaryColor,
              )),
          Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: Text(widget.label,
                textAlign: TextAlign.center,
                style: new TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.normal,
                    fontSize: 18.0)),
          ),
          Column(children: widget.children)
        ]);
        break;
    }
  }
}
