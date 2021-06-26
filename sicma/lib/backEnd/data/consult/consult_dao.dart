import 'package:sembast/sembast.dart';
import 'package:sicma/backEnd/data/consult/consult.dart';
import 'package:sicma/backEnd/database.dart';

class ConsultDao {
  static const String STORE_NAME = "HistorialesClinicos";

  final _store = intMapStoreFactory.store(STORE_NAME);

  Future<Database> get _db async => await DBController.instance.database;

  //insert _todo to store
  Future insert(Consult h) async {
    var key = await _store.add(await _db, h.data);
    if (key != null) {
      h.id = key;
    }
  }

  //update _todo item in db
  Future update(Consult h) async {
    // finder is used to filter the object out for update
    final finder = Finder(filter: Filter.byKey(h.data['_id']));
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

  Future<Consult> getConsult(int id) async {
    var map = await _store.record(id).get(await _db);
    return map == null ? null : Consult.fromJson(id, map);
  }

  Future<List<Consult>> getConsultByKey(int id, String key) async {
    var finder = Finder(filter: Filter.equals(key, id));
    final record = await _store.find(await _db, finder: finder);
    return record.map((snapshot) {
      final todo = Consult.fromMap(snapshot.key, snapshot.value);
      print("id:" + todo.id.toString() + ", data:" + todo.data.toString());
      return todo;
    }).toList();
  }

  //get all listem from the db
  Future<List<Consult>> getAll() async {
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
      final todo = Consult.fromMap(snapshot.key, snapshot.value);
      print("id:" + todo.id.toString() + ", data:" + todo.data.toString());
      return todo;
    }).toList();
  }
}
