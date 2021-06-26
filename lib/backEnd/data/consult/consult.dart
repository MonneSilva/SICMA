import 'package:flutter/cupertino.dart';

class Consult {
  //all information is save here
  int id;
  Map<String, dynamic> data;

  Consult({@required this.id, @required this.data});

  static Consult fromMap(int id, Map<String, dynamic> map) {
    return Consult(id: id, data: map);
  }

//FROM JSON FORM TO OBJECT
  Consult.fromJson(int id, Map<String, dynamic> json) {
    this.id = id;
    this.data = json;
  }
  Consult.fromForm(int id, Map<String, dynamic> json) {
    data = new Map<String, dynamic>();
    List<dynamic> fields = json['fields'];
    fields.forEach((element) {
      if (element['value'] != null)
        data.putIfAbsent(element['title'], () => element['value']);
    });
    print(data.toString());
  }

  getData() {
    return data;
  }

  getElement(String key) {
    if (data.isNotEmpty && (data.containsKey(key))) //Is not null and key exist
      return data.values.toList();
    else
      return null;
  }

  setData(Map<String, dynamic> data) {
    this.data = data;
  }

  setElement(String key, dynamic value) {
    return data.putIfAbsent(key, () => value);
  }

  dbCreator() {}
}
