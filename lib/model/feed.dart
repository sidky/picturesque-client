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