import 'package:flutter/material.dart';

Widget iconButtonBuild(
    BuildContext context, String route, String title, IconData icon) {
  return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(route);
      },
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 30.0),
            Text(title),
          ],
        ),
      ));
}
