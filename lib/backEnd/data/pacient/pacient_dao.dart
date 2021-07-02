import 'package:sembast/sembast.dart';
import 'package:sicma/backEnd/data/history/history_dao.dart';
import 'package:sicma/backEnd/data/pacient/pacient.dart';
import 'package:sicma/backEnd/database.dart';

class PacientDao {
  static const String STORE_NAME = "Pacientes";

  final _store = intMapStoreFactory.store(STORE_NAME);

  Future<Database> get _db async => await DBController.instance.database;

  //insert _todo to store
  Future insert(Pacient p) async {
    p.data['fechaRegistro'] = DateTime.now().toString();
    var key = await _store.add(await _db, p.data);
    if (key != null) {
      p.id = key;
      p.data['_id'] = p.id.toString();
      update(p);
    } else {
      print('Error');
    }
  }

  //update _todo item in db
  Future update(Pacient p) async {
    // finder is used to filter the object out for update
    final finder = Finder(filter: Filter.byKey(p.id));
    print("P.data: " + p.data.toString());
    await _store.update(await _db, p.data, finder: finder);
  }

  //delete _todo item
  Future delete(int id) async {
    //get refence to object to be deleted using the finder method of sembast,
    //specifying it's id
    final finder = Finder(filter: Filter.byKey(id));
    await _store.delete(await _db, finder: finder);
  }

  Future inactive(Pacient p) async {
    final finder = Finder(filter: Filter.byKey(p.id));
    print("P.data: " + p.data.toString());
    await _store.update(await _db, {'estado': false}, finder: finder);
  }

  //get all listem from the db
  Future<List<Pacient>> getAll() async {
    final finder = Finder();
    final snapshot = await _store.find(
      await _db,
      finder: finder,
    );

    List all = snapshot.map((snapshot) {
      final todo = Pacient.fromMap(snapshot.key, snapshot.value);
      //todo.data.putIfAbsent('_id', () => snapshot.value);
      // print("id:" + todo.id.toString() + ", data:" + todo.data.toString());
      return todo;
    }).toList();

    return all;
  }
}
