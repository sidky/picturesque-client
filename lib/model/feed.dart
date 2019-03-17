import 'dart:ui';

class FeedImage {
  final String caption;
  final String image;

  const FeedImage(this.caption, this.image);
}

class Feed {
  final String type;
  final String id;
  final String title;
  final String subHeader;
  final DateTime updated;
  final String url;
  final List<FeedImage> images;

  Feed(this.type, this.id, this.title, this.subHeader, this.updated, this.url, this.images);
}

class FeedInfo {
  final String type;
  final Color background;
  final String icon;
  final String name;
  final String rss;
  final String url;

  FeedInfo(this.type, this.background, this.icon, this.name, this.rss, this.url);

  factory FeedInfo.fromMap(String feedType, Map value) {
    String colorString = value['background'];
    var background = Color(0xFF000000 | int.parse(colorString.substring(1), radix: 16));
    var icon = value['icon'];
    var name = value['name'];
    var rss = value['rss'];
    var url = value['url'];

    return FeedInfo(feedType, background, icon, name, rss, url);
  }
}

class FeedList {
  final Map<String, FeedInfo> feed;

  List<String> get allPaths => feed.keys.toList(growable: false);

  FeedList(this.feed);

  factory FeedList.fromMap(Map values) {
    Map<String, FeedInfo> feed = Map();

    values.forEach((key, value) {
      feed[key] = FeedInfo.fromMap(key, value);
    });

    return FeedList(feed);
  }
}