import 'package:flutter/material.dart';

class CustomTabView extends StatefulWidget {
  const CustomTabView({this.children, this.title, this.childrenFooter});
  final List<Widget> children;
  final List<Widget> childrenFooter;

  final String title;

  @override
  _CustomTabViewState createState() => new _CustomTabViewState();
}

class _CustomTabViewState extends State<CustomTabView> {
  bool visible = true;
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Padding(
          padding: EdgeInsets.all(20),
          child: Column(children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(widget.title,
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.normal,
                      fontSize: 22.0)),
            ),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.children),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                    width: double.infinity,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: widget.childrenFooter))),
          ])),
    ]);
  }
}
