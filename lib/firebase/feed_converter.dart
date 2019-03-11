import 'package:picturesque/model/feed.dart';

class FeedConverter {

  static FeedConverter _instance;

  FeedConverter._internal();

  factory FeedConverter() {
    if (_instance == null) {
      _instance = FeedConverter._internal();
    }
    return _instance;
  }

  Feed convert(String type, String id, dynamic values) {
    Map map = values;

    var title = map['title'];
    var subHeader = map['subheader'];
    var updated = DateTime.fromMillisecondsSinceEpoch(map['updated']);
    var url = map['url'];
    print(map['images']);
    var images = convertImageList(map['images']);

    return Feed(type, id, title, subHeader, updated, url, images);
  }

  List<FeedImage> convertImageList(List<dynamic> images) {
    return images.map((k) {
      Map imageMap = k;
      return convertImage(imageMap);
    }).toList();
  }

  FeedImage convertImage(Map map) {
    var caption = map['caption'];
    String image = map['image'];
    if (image.startsWith("//")) {
      image = "https:" + image;
    }
    print("******************* URL: " + image);
    return FeedImage(caption, image);
  }
}