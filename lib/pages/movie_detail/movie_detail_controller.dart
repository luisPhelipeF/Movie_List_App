import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:movie_app/data/movie_api.dart';
import 'package:movie_app/data/models/movie.dart';

class MovieDetailController {
  final MovieApi api;

  MovieDetailController(this.api);

  final _controller = StreamController<Movie>();
  Stream<Movie> get stream => _controller.stream;

  void init(Movie movie) {
    getMovie(movie);
  }

  Future<void> getMovie(Movie movie) async {
    try {
      final results = await Future.wait([
        api.getMovieDetails(movie.id),
        api.getDirector(movie.id),
      ]);

      final movieDetails = results[0] as Movie;
      final director = results[1] as String;

      final updatedMovie = movieDetails.copyWith(
        director: director,
      );

      _controller.add(updatedMovie);
    } catch (e) {
      debugPrint('Erro ao carregar detalhes: $e');
    }
  }

  void dispose() {
    if (!_controller.isClosed) {
      _controller.close();
    }
  }
}