import 'package:movie_app/data/models/movie_comments.dart';

class Movie {
  static const _baseImageUrl = 'https://image.tmdb.org/t/p/w500';

  final int id;
  final String title;
  final String year;
  final String plot;
  final String poster;
  final double rating;

  final String? genre;
  final String? runtime;
  final String? director;

  final List<MovieComments> comments;

  Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.plot,
    required this.poster,
    required this.rating,
    this.genre,
    this.runtime,
    this.director,
    this.comments = const [],
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    final posterPath = json['poster_path'] as String?;
    final releaseDate = json['release_date']?.toString() ?? '';

    return Movie(
      id: (json['id'] as int?) ?? 0,
      title: (json['title'] as String?) ?? '',
      year: releaseDate.isNotEmpty ? releaseDate.split('-').first : '',
      plot: (json['overview'] as String?) ?? '',
      rating: (json['vote_average'] as num?)?.toDouble() ?? 0,
      poster: (posterPath != null && posterPath.isNotEmpty)
          ? '$_baseImageUrl$posterPath'
          : '',
      comments: (json['comments'] as List?)
              ?.map((item) => MovieComments.fromJson(item))
              .toList() ??
          [],
    );
  }

  Movie copyWith({
    String? director,
    String? genre,
    String? runtime,
    List<MovieComments>? comments,
  }) {
    return Movie(
      id: id,
      title: title,
      year: year,
      plot: plot,
      poster: poster,
      rating: rating,
      director: director ?? this.director,
      genre: genre ?? this.genre,
      runtime: runtime ?? this.runtime,
      comments: comments ?? this.comments,
    );
  }

  @override
  String toString() {
    return 'Movie(title: $title, year: $year)';
  }
}