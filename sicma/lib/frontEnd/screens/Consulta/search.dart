import 'package:flutter/material.dart';
//import 'package:sicma/frontEnd/components/appBar/appBar.dart';

class SearchScreenConsulta extends StatefulWidget {
  SearchScreenConsulta({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SearchScreenConsultaState createState() => _SearchScreenConsultaState();
}

class _SearchScreenConsultaState extends State<SearchScreenConsulta> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: appBarbuild(context, 'Consultas'),*/
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/Consulta/New');
                },
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Nueva Cosulta'),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
