import 'package:flutter/material.dart';
import 'package:sicma/backEnd/data/pacient/pacient.dart';
//import 'package:sicma/backEnd/data/pacient.dart';
import 'package:sicma/backEnd/data/pacient/pacient_dao.dart';
//import 'package:sicma/backEnd/data/pacient_dao.dart';
//import 'package:sembast/sembast.dart';
//import 'package:sicma/backEnd/Database.dart';
//import 'package:sicma/backEnd/data/pacient_dao.dart';

class SearchScreenPaciente extends StatefulWidget {
  SearchScreenPaciente({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SearchScreenPacienteState createState() => _SearchScreenPacienteState();
}

class _SearchScreenPacienteState extends State<SearchScreenPaciente> {
  TextEditingController editingController = TextEditingController();
  PacientDao p = PacientDao();
  List<Pacient> pacients;
  String searchString;
  Future _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = p.getAll();
  }

  List<Pacient> filterSearch(List<Pacient> originals) {
    List<Pacient> results = new List();
    if (originals != null && searchString != null) {
      originals.forEach((e) {
        String title = e.data['nombre']['nombre'].toString() +
            e.data['nombre']['apellidoPat'].toString() +
            e.data['nombre']['apellidoMat'].toString();
        if (title.contains(searchString)) results.add(e);
      });
      return results;
    }
    return originals;
  }

  @override
  Widget build(BuildContext context) {
    final int option = ModalRoute.of(context).settings.arguments as int;
    void handleClick(String value) {
      switch (value) {
        case '1':
          Navigator.of(context).pushNamed('/Paciente/New');
          break;
      }
    }

    return Scaffold(
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
                      "Pacientes",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 25),
                    ),
                    actions: <Widget>[
                      PopupMenuButton<String>(
                          color: Color.fromARGB(255, 92, 105, 99),
                          onSelected: handleClick,
                          itemBuilder: (BuildContext context) => [
                                PopupMenuItem(
                                    value: '1',
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              2, 2, 8, 2),
                                          child: Icon(Icons.add_circle_outline,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          'Nuevo Paciente',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ))
                              ]),
                    ],
                  )
                ])),
        body: Container(
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(children: <Widget>[
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        searchString = value;
                        _futureData = p.getAll();
                      });
                    },
                    cursorColor: Color.fromARGB(255, 162, 180, 172),
                    controller: editingController,
                    decoration: InputDecoration(
                        hintText: "Buscar",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)))),
                  ),
                  Expanded(
                    child: FutureBuilder<List<Pacient>>(
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.none &&
                            snapshot.hasData == null) {
                          print("asdff ${snapshot.data}");
                          return Container(color: Colors.red);
                        }
                        pacients = filterSearch(snapshot.data);

                        return ListView.builder(
                            itemCount: pacients.length,
                            itemBuilder: (context, index) {
                              Pacient pacient = pacients[index];
                              return pacients.length == null
                                  ? CircularProgressIndicator()
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
                                          ),
                                          width: 100,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                IconButton(
                                                    icon: Icon(Icons.person),
                                                    onPressed: null),
                                                Text(
                                                  pacient.name,
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                              ])),
                                      onTap: () {
                                        switch (option) {
                                          case 1: //pacient detail
                                            Navigator.of(context).pushNamed(
                                                '/Paciente/View',
                                                arguments: pacient);
                                            break;
                                          case 2:
                                            Navigator.of(context).pushNamed(
                                                '/Consulta/New',
                                                arguments: pacient);
                                            break;
                                          case 3:
                                            Navigator.of(context).pushNamed(
                                                '/Reporte/Search',
                                                arguments: pacient);
                                            break;
                                          default:
                                        }
                                      },
                                      onLongPress: () {
                                        _showMaterialDialog(pacient);
                                      },
                                    );
                            });
                      },
                      future: _futureData,
                    ),
                  ),
                ]))));
  }

  _showMaterialDialog(Pacient p) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("Eliminar"),
              content: new Text("¿Desea eliminar a " + p.name + "?"),
              actions: <Widget>[
                FlatButton(
                  child: Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text('Aceptar'),
                  onPressed: () {
                    var pD = PacientDao();
                    pD.delete(p.id);
                    _futureData = pD.getAll();
                    Navigator.of(context).pop();

                    Navigator.of(context).pushNamedAndRemoveUntil(
                      "/Paciente/Search",
                      ModalRoute.withName('/Home'),
                    );
                  },
                )
              ],
            ));
  }
}
