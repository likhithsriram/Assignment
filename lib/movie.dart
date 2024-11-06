class Movie {
  final String id;
  final String title;
  final String imageUrl;
  final double rating;

  Movie({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.rating,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['title']['id'],
      title: json['title']['titleText']['text'],
      imageUrl: json['title']['primaryImage']['imageUrl'],
      rating: json['title']['ratingsSummary']['aggregateRating'].toDouble(),
    );
  }
}
