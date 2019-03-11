import 'dart:async';

import 'package:picturesque/firebase/firebase_list.dart';
import 'package:picturesque/model/feed.dart';

class ListAggregator {
  List<FirebaseList> _lists = List();
  List<StreamSubscription<ListUpdate>> _subscriptions = List();
  List<Feed> _feed = List();

  StreamController<List<Feed>> _onUpdated = StreamController.broadcast();

  Stream<List<Feed>> get onUpdated => _onUpdated.stream;

  void addList(FirebaseList list) {
    this._lists.add(list);
    StreamSubscription<ListUpdate> subscription = list.onChanged.listen((update) {
      _buildFeed();
    });
    _subscriptions.add(subscription);
    _buildFeed();
  }

  void _buildFeed() {
    List<Feed> feed = List();

    _lists.forEach((list) {
      feed.addAll(list.feed);
    });

    feed.sort((f1, f2) => f2.updated.compareTo(f1.updated));

    _onUpdated.add(feed);
  }

  void update() {
    _buildFeed();
  }

  List<Feed> get feed => _feed;

  void finalize() {
    this._subscriptions.forEach((s) => s.cancel());
    this._lists.forEach((l) => l.finalize());
    _onUpdated.close();
  }
}