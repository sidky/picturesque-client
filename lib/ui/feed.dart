import 'dart:async';

import 'package:flutter/material.dart';
import 'package:picturesque/firebase/feed_store.dart';
import 'package:picturesque/model/feed.dart';

class FeedListState extends State<FeedList>{
  bool _isLoading = true;
  List<Feed> _feed = List();
  final FeedStore _feedStore;

  StreamSubscription<List<Feed>> _updateSubscription;

  FeedListState(this._feedStore);

  @override
  Widget build(BuildContext context) {
    print("feed size: " + _feed.length.toString());
    return Scaffold(
      appBar: AppBar(title: Text("Feed")),
      body:     ListView.builder(
        itemCount: _feed.length,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (BuildContext ctx, int index) {
          return _buildItem(_feed[index]);
        },
      )
    );
  }

  Widget _buildItem(Feed feed) {
    return SizedBox(
      child: Stack(
        children: <Widget>[
          Image.network(feed.images[0].image),
          Container(
            alignment: Alignment.bottomLeft,
            child: Text(feed.title),
          )
        ],
      ),
    );
  }

  void initialize() {
    _feedStore.initialize().then((value) {
      _setFeed(_feedStore.aggregated.feed);
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_updateSubscription != null) {
      _updateSubscription.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    if (_updateSubscription != null) {
      _updateSubscription.cancel();
      _updateSubscription = null;
    }
    _updateSubscription = _feedStore.aggregated.onUpdated.listen((feed) {
      _setFeed(feed);
    });
  }

  void _setFeed(List<Feed> feed) {
    setState(() {
      this._feed = feed;
      this._isLoading = false;
    });
  }
}

class FeedList extends StatefulWidget {

  final FeedStore _store;

  FeedList(this._store);

  @override
  State<StatefulWidget> createState() => FeedListState(this._store);
}