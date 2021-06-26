import 'package:flutter/cupertino.dart';

class History {
  //all information is save here
  int id;
  Map<String, dynamic> data;

  History({@required this.id, @required this.data});

  static History fromMap(int id, Map<String, dynamic> map) {
    return History(id: id, data: map);
  }

//FROM JSON FORM TO OBJECT
  History.fromJson(int id, Map<String, dynamic> json) {
    this.id = id;
    this.data = json;
  }
  History.fromForm(int id, Map<String, dynamic> json) {
    data = new Map<String, dynamic>();
    List<dynamic> fields = json['fields'];
    fields.forEach((element) {
      if (element['value'] != null)
        data.putIfAbsent(element['key'], () => element['value']);
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
