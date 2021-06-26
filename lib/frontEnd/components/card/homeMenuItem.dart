import 'package:flutter/material.dart';

class HomeMenuItem extends StatelessWidget {
  const HomeMenuItem({
    @required this.title,
    @required this.icon,
    @required this.route,
    this.optionRoute,
    @required this.backGroundColor,
    @required this.heigth,
  });

  final Color backGroundColor;
  final String title;
  final IconData icon;
  final String route;
  final double heigth;
  final int optionRoute;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (optionRoute != null)
            Navigator.of(context).pushNamed(route, arguments: optionRoute);
        },
        child: Container(
            padding: EdgeInsets.only(top: 20),
            alignment: Alignment.topCenter,
            height: MediaQuery.of(context).size.height * heigth,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  icon,
                  size: 70.0,
                  color: Colors.white,
                ),
                Text(
                  title,
                  style: TextStyle(fontSize: 40, color: Colors.white),
                ),
              ],
            ),
            decoration: BoxDecoration(
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(30.0),
                topRight: const Radius.circular(30.0),
              ),
              color: backGroundColor,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.16),
                    spreadRadius: 3,
                    blurRadius: 3,
                    offset: Offset(7, 0)),
              ],
            )));
  }
}
