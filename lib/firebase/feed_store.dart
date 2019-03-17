import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:picturesque/firebase/firebase_list.dart';
import 'package:picturesque/firebase/list_aggregator.dart';
import 'package:picturesque/model/feed.dart';

class FeedStore {

  FeedList _feedList;
  final FirebaseApp _app;
  final ListAggregator _listAggregator = ListAggregator();

  FirebaseDatabase _db;

  FeedStore(this._app);

  Future<void> initialize() async {
    _db = FirebaseDatabase(app: this._app);

    await _db.setPersistenceEnabled(true);
    await _db.setPersistenceCacheSizeBytes(10000000);
    
    var _listSnapshot = await _db.reference().child("feed:list").once();
    _feedList = FeedList.fromMap(_listSnapshot.value);

    _feedList.allPaths.forEach((path) {
      var list = FirebaseList(this._db, path);
      _listAggregator.addList(list);
      list.initialize();
    });
    _listAggregator.update();
  }

  String feedIcon(String feedType) => _feedList.feed[feedType].icon;
  Color feedIconBackground(String feedType) => _feedList.feed[feedType].background;

  ListAggregator get aggregated => _listAggregator;
}