import 'package:sembast/sembast.dart';
import 'package:sicma/backEnd/data/history/history.dart';
import 'package:sicma/backEnd/database.dart';

class HistoryDao {
  static const String STORE_NAME = "HistorialesClinicos";

  final _store = intMapStoreFactory.store(STORE_NAME);

  Future<Database> get _db async => await DBController.instance.database;

  //insert _todo to store
  Future insert(History h) async {
    h.data['fecha'] = DateTime.now().toString();
    var key = await _store.add(await _db, h.data);
    if (key != null) {
      h.id = key;
      h.data['_id'] = h.id.toString();
      update(h);
    } else {
      print('Error');
    }
  }

  Future<History> exist(String key, int id) async {
    final finder = Finder(filter: Filter.equals(key, id));
    print('Info');
    final record = await _store.find(await _db, finder: finder);
    final list = record.map((snapshot) {
      final todo = History.fromMap(snapshot.key, snapshot.value);
      return todo;
    }).toList();
    if (list.length > 0)
      return list.first;
    else
      return null;
  }

  //update _todo item in db
  Future update(History h) async {
    // finder is used to filter the object out for update
    final finder = Finder(filter: Filter.byKey(h.id));
    await _store.update(await _db, h.data, finder: finder);
  }

  //delete _todo item
  Future delete(int id) async {
    //get refence to object to be deleted using the finder method of sembast,
    //specifying it's id
    final finder = Finder(filter: Filter.byKey(id));
    await _store.delete(await _db, finder: finder);
  }
  //get all listem from the db

  Future<History> getHistory(int id) async {
    var map = await _store.record(id).get(await _db);
    return map == null ? null : History.fromJson(id, map);
  }

  Future<History> getHistoryByKey(int id, String key) async {
    var finder = Finder(filter: Filter.equals(key, id));
    final record = await _store.findFirst(await _db, finder: finder);

    return History.fromJson(record.key, record.value);
  }

  //get all listem from the db
  Future<List<History>> getAll() async {
    //sort the _todo item in order of their timestamp
    //that is entry time
    final finder = Finder();

    //get the data
    final snapshot = await _store.find(
      await _db,
      finder: finder,
    );

    //call the map operator on the data
    //this is so we can assign the correct value to the id from the store
    //After we return it as a list
    return snapshot.map((snapshot) {
      final todo = History.fromMap(snapshot.key, snapshot.value);
      print("id:" + todo.id.toString() + ", data:" + todo.data.toString());
      return todo;
    }).toList();
  }
}
