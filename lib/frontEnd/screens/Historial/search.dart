import 'package:flutter/material.dart';
import 'package:sicma/backEnd/data/history/history.dart';
import 'package:sicma/backEnd/data/history/history_dao.dart';

class SearchScreenHistory extends StatefulWidget {
  SearchScreenHistory({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SearchScreenHistoryState createState() => _SearchScreenHistoryState();
}

class _SearchScreenHistoryState extends State<SearchScreenHistory> {
  TextEditingController editingController = TextEditingController();
  HistoryDao p = HistoryDao();
  List<History> pacients;
  String searchString;
  Future _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = p.getAll();
  }

  List<History> filterSearch(List<History> originals) {
    List<History> results = new List();
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
          Navigator.of(context).pushNamed('/Historial/New');
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
                      "Historyes",
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
                                          'Nuevo Historye',
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
                padding: const EdgeInsets.all(15.0),
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
                    child: FutureBuilder<List<History>>(
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
                              History pacient = pacients[index];
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
                                            color: Colors.white,
                                          ),
                                          width: 100,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  pacient.id.toString(),
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                              ])),
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            '/Historial/View',
                                            arguments: pacient);
                                      },
                                      onLongPress: () {
                                        var hD = new HistoryDao();
                                        hD.delete(pacient.id);
                                        Navigator.of(context).popAndPushNamed(
                                            '/Historial/Search');
                                      },
                                    );
                            });
                      },
                      future: _futureData,
                    ),
                  ),
                ]))));
  }
}
