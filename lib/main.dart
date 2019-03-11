import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:picturesque/firebase/feed_store.dart';
import 'package:picturesque/firebase/firebase_app.dart';
import 'package:picturesque/ui/feed.dart';

Future<void> main() async {
  var firebase = await FirebasePicturesqueApp.instance();
  runApp(PicturesqueApp(firebase));
}

class PicturesqueApp extends StatelessWidget {

  final FirebaseApp _app;

  PicturesqueApp(this._app);

  void initialize() async {
    FeedStore store = FeedStore(this._app);
    await store.initialize();
    var feed = store.aggregated.feed;
  }

  @override
  Widget build(BuildContext context) {

    FeedStore store = FeedStore(this._app);
    store.initialize().whenComplete(() {
      print("Initialized feed store");
    });

    return MaterialApp(
      title: 'Picturesque',
      theme: ThemeData(
        canvasColor: Colors.transparent
      ),
      home: FeedList(store),
    );
  }
}