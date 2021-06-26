import 'package:flutter/material.dart';

class EditScreenHistorial extends StatefulWidget {
  EditScreenHistorial({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _EditScreenHistorialState createState() => _EditScreenHistorialState();
}

class _EditScreenHistorialState extends State<EditScreenHistorial> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Historial Clínico", textAlign: TextAlign.center),
          backgroundColor: Colors.transparent),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Historial Clínico EDIT'),
            GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/Consulta/Search');
                },
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Guardar'),
                    ],
                  ),
                )),
            GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Cancelar'),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
