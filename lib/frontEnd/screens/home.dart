import 'package:flutter/material.dart';
import 'package:sicma/backEnd/data/history/history.dart';
import 'package:sicma/backEnd/data/history/history_dao.dart';
import 'package:sicma/backEnd/data/pacient/pacient.dart';
import 'package:sicma/backEnd/data/pacient/pacient_dao.dart';
import 'package:sicma/frontEnd/components/appBar/appBar.dart';
//import 'package:sicma/frontEnd/components/button/iconButton.dart';
import 'package:sicma/frontEnd/components/card/homeMenuItem.dart';
import 'package:sicma/frontEnd/components/appBar/options.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    var hD = new HistoryDao();
    print(hD.getAll().toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(80.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: <
                    Widget>[
              AppBar(
                automaticallyImplyLeading: false,
                bottomOpacity: 0.0,
                elevation: 0.0,
                iconTheme:
                    IconThemeData(color: Theme.of(context).primaryColorLight),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20))),
                backgroundColor: Colors.transparent,
                actions: <Widget>[
                  PopupMenuButton<String>(
                      color: Color.fromARGB(255, 92, 105, 99),
                      onSelected: (value) {
                        switch (value) {
                          case '1':
                            Navigator.of(context).pushNamed("/Configures");
                            break;
                          case '2':
                            Navigator.of(context)
                                .pushNamed("/Historial/Search");
                            break;
                          case '3':
                            Navigator.of(context).pushNamed("/Backup");
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                            PopupMenuItem(
                                value: '1',
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(2, 2, 8, 2),
                                      child: Icon(Icons.settings,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      'Configuraciones',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                )),
                            PopupMenuItem(
                                value: '2',
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(2, 2, 8, 2),
                                      child: Icon(Icons.settings,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      'Historiales',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                )),
                            PopupMenuItem(
                                value: '3',
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(2, 2, 8, 2),
                                      child: Icon(Icons.settings,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      'Respaldo',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ))
                          ]),
                ],
              )
            ])),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.40,
                  child: Image.asset(
                    'lib/frontEnd/assets/image/logo.png',
                    height: 250,
                    width: 250,
                  )),
              Stack(alignment: Alignment.bottomRight, children: <Widget>[
                HomeMenuItem(
                    backGroundColor: Theme.of(context).primaryColor,
                    icon: Icons.people,
                    title: "Pacientes",
                    route: "/Paciente/Search",
                    optionRoute: 1,
                    heigth: 0.45),
                HomeMenuItem(
                    backGroundColor: Theme.of(context).primaryColorDark,
                    icon: Icons.description,
                    title: "Consulta",
                    route: "/Paciente/Search",
                    optionRoute: 2,
                    heigth: 0.30),
                HomeMenuItem(
                    backGroundColor: Theme.of(context).primaryColorLight,
                    icon: Icons.assessment,
                    title: "Reporte",
                    optionRoute: 3,
                    route: "/Paciente/Search",
                    heigth: 0.15)
              ])
            ]));
  }
}
