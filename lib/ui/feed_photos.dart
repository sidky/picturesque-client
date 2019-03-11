import 'package:flutter/material.dart';
import 'package:picturesque/model/feed.dart';
import 'package:picturesque/ui/feed_slideshow.dart';

class FeedPhotos extends StatelessWidget {

  final Feed _feed;

  const FeedPhotos(this._feed);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 2 + this._feed.images.length,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(_feed.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white, fontFamily: "roboto", decoration: TextDecoration.none)));
          } else if (index == 1) {
            return Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(_feed.subHeader, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12, color: Colors.white, fontFamily: "roboto", decoration: TextDecoration.none)),
            );
          } else {
            var imageIndex = index - 2;
            var image = _feed.images[imageIndex];
            return GestureDetector(
              child: Image.network(image.image),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FeedSlideShow(this._feed, imageIndex)));
              },
            );
          }
        });
  }
}