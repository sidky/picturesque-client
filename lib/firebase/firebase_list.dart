import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:picturesque/firebase/feed_converter.dart';
import 'package:picturesque/model/feed.dart';

enum ListUpdate {
  INIT, ADD, REMOVE, CHANGE
}

class FirebaseList {
  final FirebaseDatabase _db;
  final String _path;
  final List<Feed> _feed;

  final StreamController<ListUpdate> _onChanged = StreamController.broadcast();

  final FeedConverter _converter = FeedConverter();

  Stream<ListUpdate> get onChanged => _onChanged.stream;

  FirebaseList(this._db, this._path) : this._feed = List();

  List<Feed> get feed => this._feed;

  Future<void> initialize() async {
    var ref = this._db.reference().child(this._path);


    ref.onChildAdded.listen((e) {
      var snapshot = e.snapshot;

      Feed feed = _converter.convert(this._path, snapshot.key, snapshot.value);
      _feed.add(feed);
      this._onChanged.add(ListUpdate.ADD);
    });

    ref.onChildRemoved.listen((e) {
      var snapshot = e.snapshot;
      var key = snapshot.key;

      this._feed.removeWhere((feed) => feed.id == key);
      this._onChanged.add(ListUpdate.REMOVE);
    });

    ref.onChildChanged.listen((e) {
      var snapshot = e.snapshot;
      var updated = this._converter.convert(this._path, snapshot.key, snapshot.value);
      var index = this._feed.indexWhere((feed) => feed.id == snapshot.key);

      if (index >= 0) {
        this._feed[index] = updated;
      } else {
        this._feed.add(updated);
      }
      this._onChanged.add(ListUpdate.CHANGE);
    });
  }

  void finalize() {
    _onChanged.close();
  }
}