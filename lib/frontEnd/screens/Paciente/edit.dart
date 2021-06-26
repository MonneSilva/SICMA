import 'package:flutter/material.dart';
//import 'package:sicma/frontEnd/components/appBar/appBar.dart';

class EditScreenPaciente extends StatefulWidget {
  EditScreenPaciente({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _EditScreenPacienteState createState() => _EditScreenPacienteState();
}

class _EditScreenPacienteState extends State<EditScreenPaciente> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: appBarbuild(context, 'Editar Paciente'),*/
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
    );
  }
}
