import 'dart:async';

import 'package:flutter/material.dart';
import 'package:picturesque/firebase/feed_store.dart';
import 'package:picturesque/model/feed.dart';
import 'package:picturesque/ui/feed_photos.dart';

class FeedListState extends State<FeedList>{
  bool _isLoading = true;
  List<Feed> _feed = List();
  final FeedStore _feedStore;

  StreamSubscription<List<Feed>> _updateSubscription;

  FeedListState(this._feedStore);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Picturesque", style: TextStyle(color: Colors.white),), backgroundColor: Colors.black,),
      body: ListView.builder(
            itemCount: _feed.length + (_isLoading ? 1 : 0),
            physics: AlwaysScrollableScrollPhysics(),
            itemBuilder: (BuildContext ctx, int index) {
              if (_isLoading && index == 0) {
                return LinearProgressIndicator(value: null,);
              }
              if (_isLoading) {
                index--;
              }
              return _buildItem(context, _feed[index]);
            },
          )
      );
  }

  Widget _buildItem(BuildContext context, Feed feed) {
    return GestureDetector(
      child: SizedBox(
        child: Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: <Widget>[
              Image.network(feed.images[0].image),
              Container(
                padding: EdgeInsets.all(10.0),
                color: Color.fromARGB(0x80, 0xFF, 0xFF, 0xFF),
                alignment: Alignment.bottomLeft,
                child: Text(
                    feed.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )
                ),
              ),
            ]),
      ),
      onTap: () {
        Navigator.push(
            context, 
            //MaterialPageRoute(builder: (context) => FeedSlideShow(feed))
            MaterialPageRoute(builder: (context) => FeedPhotos(feed))
        );
      },);
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