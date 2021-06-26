import 'package:flutter/material.dart';

Widget searcherBuild(BuildContext context) {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
          child: TextField(
              style: new TextStyle(color: Colors.grey),
              cursorColor: Colors.blue,
              autofocus: true,
              decoration: InputDecoration(
                focusColor: Colors.grey,
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
              )),
        ),
        IconButton(
          icon: Icon(Icons.search),
          // tooltip: 'Increase volume by 10',
          onPressed: () {
            //buscar
          },
        ),
      ],
    ),
  );
}
