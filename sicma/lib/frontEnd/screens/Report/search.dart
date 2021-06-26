import 'package:flutter/material.dart';
import 'package:sicma/backEnd/data/consult/consult.dart';
import 'package:sicma/backEnd/data/pacient/pacient.dart';
import 'package:sicma/backEnd/data/pacient/pacient_dao.dart';
import 'package:sicma/frontEnd/components/form/datepicker.dart';
import 'package:sicma/frontEnd/screens/Report/generator.dart';
//import 'package:sicma/frontEnd/components/appBar/appBar.dart';

class SearchScreenReporte extends StatefulWidget {
  SearchScreenReporte({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _SearchScreenReporteState createState() => _SearchScreenReporteState();
}

class _SearchScreenReporteState extends State<SearchScreenReporte> {
  PacientDao p = PacientDao();
  List<Consult> c = new List();
  List<bool> _selected = new List();
  Consult consult;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Pacient p = ModalRoute.of(context).settings.arguments as Pacient;
    bool hasData = p.history != null ? true : false;

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
                      "Reporte",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  )
                ])),
        body: Container(
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
            child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(children: <Widget>[
                  Row(
                    children: [
                      Text('Proyección'),
                      new DropdownButton<String>(
                        items:
                            <String>['Evolutivo', 'Único'].map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        onChanged: (_) {},
                      ),
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: !hasData
                          ? Container(
                              child: Text('No hay consultas'),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: p.history.data['Consultas'].length,
                              itemBuilder: (context, index) {
                                _selected.add(false);
                                c.add(new Consult(
                                    id: null,
                                    data: p.history.data['Consultas'][index]));
                                return p.history.data['Consultas'] == null
                                    ? Container(
                                        child: Text('No hay consultas'),
                                      )
                                    : GestureDetector(
                                        child: Container(
                                            padding: EdgeInsets.all(10),
                                            height: 80,
                                            decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                width: 1.0,
                                                color: Theme.of(context)
                                                    .primaryColorDark,
                                              )),
                                              color: _selected.elementAt(index)
                                                  ? Theme.of(context)
                                                      .primaryColorLight
                                                  : Colors.white,
                                            ),
                                            width: 100,
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    c
                                                        .elementAt(index)
                                                        .data['fecha']
                                                        .toString(),
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                  ),
                                                ])),
                                        onTap: () {
                                          setState(() {
                                            consult = c.elementAt(index);
                                            _selected[index] =
                                                !_selected.elementAt(index);

                                            _selected.elementAt(index)
                                                ? consult = c.elementAt(index)
                                                : consult = null;
                                          });
                                        },
                                      );
                              })),
                  RaisedButton(
                      child: Text('Generar reporte'),
                      onPressed: () async {
                        Generator g = new Generator();
                        await g.generateExampleDocument(p, consult);
                      })
                ]))));
  }
}
