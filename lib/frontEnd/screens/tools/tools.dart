import 'package:intl/intl.dart';

class Tools {
  //all information is save here

  static int getAge(date) {
    int years = 0;
    var d = DateFormat('d/M/yyyy').parse(date);
    if (d != null) {
      final now = DateTime.now();
      years = now.year - d.year;
      if (d.month > now.month) {
        years--;
      } else if (d.month == now.month) {
        if (d.day > now.day) {
          years--;
        }
      }
      return years;
    }
  }
}
