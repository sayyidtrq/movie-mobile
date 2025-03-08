class Movie {
  final String title;
  final String overview;
  final String backdropPath;
  final String posterPath;
  final int id;
  final String releaseDate;
  final int voteCount;
  final double voteAverage;

  Movie({
    required this.title,
    required this.overview,
    required this.backdropPath,
    required this.posterPath,
    required this.id,
    required this.releaseDate,
    required this.voteCount,
    required this.voteAverage,
  });

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      title: map['title'],
      overview: map['overview'],
      backdropPath: map['backdrop_path'],
      posterPath: map['poster_path'],
      id: map['id'],
      releaseDate: map['release_date'],
      voteCount: map['vote_count'],
      voteAverage: map['vote_average'].toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'overview': overview,
      'backdrop_path': backdropPath,
      'poster_path': posterPath,
      'id': id,
      'release_date': releaseDate,
      'vote_count': voteCount,
      'vote_average': voteAverage,
    };
  }
}
