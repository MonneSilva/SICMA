//import 'dart:convert';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sicma/backEnd/data/history/history.dart';
import 'package:sicma/backEnd/data/history/history_dao.dart';
import 'package:sicma/frontEnd/components/form/json_schema.dart';

class ViewScreenHistorial extends StatefulWidget {
  ViewScreenHistorial({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ViewScreenHistorialState createState() => _ViewScreenHistorialState();
}

class _ViewScreenHistorialState extends State<ViewScreenHistorial> {
  dynamic response;
  String form;
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  var isLoading = false;
  _fetchData() async {
    setState(() {
      isLoading = true;
    });
    String response = json.encode(json.decode(
        await rootBundle.loadString("lib/backEnd/data/json/pacient.json")));
    if (response != null) {
      form = response;
      print(form);
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load form');
    }
  }

  @override
  Widget build(BuildContext context) {
    final History p = ModalRoute.of(context).settings.arguments as History;
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
                      "Nuevo paciente",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  )
                ])),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
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
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: ListView(children: <Widget>[Text(p.data.toString())]),
                )));
  }
  /*  return Scaffold(
        appBar: AppBar(
            title: Text("Historial Clínico", textAlign: TextAlign.center),
            backgroundColor: Colors.transparent),
        body: Container(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: <Widget>[
                  Expanded(
                    child: FutureBuilder<List<History>>(
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none &&
                            snapshot.hasData == null) {
                          print("asdff ${snapshot.data}");
                          return Container(color: Colors.red);
                        }
                        return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              History student = snapshot.data[index];
                              return snapshot.data.length == null
                                  ? CircularProgressIndicator()
                                  : Container(
                                      child: Text(student.data.toString()),
                                    );
                            });
                      },
                      future: h.getHistoryByKey(id, "paciente_id"),
                    ),
                  ),
                ]))));
  }*/
}
