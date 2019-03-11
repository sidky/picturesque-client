import 'package:flutter/material.dart';
import 'package:picturesque/model/feed.dart';

class FeedSlideShowState extends State<FeedSlideShow> {
  final Feed _feed;
  int _index;

  FeedSlideShowState(this._feed, this._index);
  FeedSlideShowState.fromStart(this._feed) : this._index = 0;

  int get _imageCount => _feed.images.length;

  @override
  Widget build(BuildContext context) {
    var feedImage = this._feed.images[this._index];
    return GestureDetector(
      child: Container(child: Image.network(feedImage.image)),
      onHorizontalDragEnd: (DragEndDetails details) {
        if (details.velocity.pixelsPerSecond.dx < 0.0) {
          next();
        } else if (details.velocity.pixelsPerSecond.dx > 0.0) {
          prev();
        }
      },
      onVerticalDragEnd: (DragEndDetails details) {
        _showDescription();
      },
    );
  }

  void next() {
    if (_index + 1 < _imageCount) {
      setState(() {
        _index++;
      });
    }
  }

  void prev() {
    if (_index > 0) {
      setState(() {
        _index--;
      });
    }
  }

  void _showDescription() {
    showModalBottomSheet(context: context, builder: (BuildContext context) {
      return Container(
          color: Color.fromARGB(0x20, 0xFF, 0xFF, 0xFF),
          child: FractionallySizedBox(
        widthFactor: 1.0,
        heightFactor: 0.5,
        child: SingleChildScrollView(
          child: Text(
            _feed.images[_index].caption,
            style: TextStyle(color: Color.fromARGB(0xFF, 0xFF, 0xFF, 0xFF), background: Paint()..color = Colors.transparent),
          )
        ),
      ));
    });
  }
}

class FeedSlideShow extends StatefulWidget {

  final Feed _feed;
  final int _index;

  const FeedSlideShow(this._feed, this._index);

  @override
  State<StatefulWidget> createState() => FeedSlideShowState(this._feed, this._index);
}