import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:picturesque/firebase/firebase_list.dart';
import 'package:picturesque/firebase/list_aggregator.dart';

class FeedStore {

  final List<String> _paths = ["bigpicture", "infocus"];
  final FirebaseApp _app;
  final ListAggregator _listAggregator = ListAggregator();

  FirebaseDatabase _db;

  FeedStore(this._app);

  Future<void> initialize() async {
    _db = FirebaseDatabase(app: this._app);

    await _db.setPersistenceEnabled(true);
    await _db.setPersistenceCacheSizeBytes(10000000);

    _paths.forEach((path) {
      var list = FirebaseList(this._db, path);
      _listAggregator.addList(list);
      list.initialize();
    });
  }

  ListAggregator get aggregated => _listAggregator;
}