import 'package:flutter/material.dart';

class AppBarCustome extends StatelessWidget {
  AppBarCustome(String s, Null Function() param1,
      {this.title, this.onSelected, this.options});
  final String title;
  final Function onSelected;
  final List<OptionAppBar> options;
  getChildren() {
    List<Widget> items = new List();
    options.forEach((element) {
      items.add(buildChild(element.value, element.title));
    });
  }

  Widget buildChild(String value, String title) {
    return PopupMenuItem(
        value: value,
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
              child: Icon(Icons.add_circle_outline, color: Colors.white),
            ),
            Text(
              title,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    getChildren();
    return PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AppBar(
                  automaticallyImplyLeading: false,
                  leading: Container(
                    margin: EdgeInsets.only(top: 8, bottom: 8),
                    color: Theme.of(context).primaryColorLight,
                    child: IconButton(
                      color: Theme.of(context).primaryColorLight,
                      icon: Icon(
                        Icons.keyboard_arrow_left,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  bottomOpacity: 0.0,
                  elevation: 0.0,
                  iconTheme:
                      IconThemeData(color: Theme.of(context).primaryColorLight),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20))),
                  backgroundColor: Colors.transparent,
                  centerTitle: true,
                  title: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 25),
                  ),
                  actions: <Widget>[
                    PopupMenuButton<String>(
                      color: Color.fromARGB(255, 92, 105, 99),
                      onSelected: onSelected,
                      itemBuilder: (BuildContext context) => [],
                    )
                  ])
            ]));
  }
}

class OptionAppBar {
  final String title;
  final String value;
  final String route;

  OptionAppBar(this.title, this.value, this.route);
}
