import 'package:flutter/foundation.dart';
import 'package:movie_app/data/movie_api.dart';
import 'package:movie_app/service_locator.dart';
import 'package:movie_app/data/models/movie.dart';

class MovieListController {
  final api = getIt<MovieApi>();

  // 👇 guarda estado automaticamente
  final ValueNotifier<List<Movie>?> movies = ValueNotifier(null);

  void init() {
    if (movies.value == null) {
      getTrending();
    }
  }

  Future<void> getTrending() async {
    try {
      final list = (await api.getTrendingMovies()).take(10).toList();

      final withDirector = await Future.wait(
        list.map((movie) async {
          final director = await api.getDirector(movie.id);
          return movie.copyWith(director: director);
        }),
      );

      movies.value = withDirector;
    } catch (e) {
      debugPrint('Erro: $e');
      movies.value = [];
    }
  }
  Future<List<Movie>> getMoviesByIds(List<String> ids) async {
  final movies = await Future.wait(
    ids.map((id) async {
      final movie = await api.getMovieDetails(int.parse(id));
      final director = await api.getDirector(int.parse(id));

      return movie.copyWith(director: director);
    }),
  );

  return movies;
}
}