import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_app/data/models/movie.dart';

class MovieApi {
  static const String _apiKey = 'YOUR_API_KEY';
  static const String _baseUrl = 'https://api.themoviedb.org/3/';

  static const _search = 'search/movie';
  static const _trending = 'trending/movie/day';

  final Dio _dio = Dio(
    BaseOptions(baseUrl: _baseUrl),
  )..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.queryParameters['api_key'] = _apiKey;
          return handler.next(options);
        },
      ),
    );

  Future<List<Movie>> getMovies(String query) async {
    try {
      final response = await _dio.get(
        _search,
        queryParameters: {
          'query': query,
          'language': 'pt-BR',
        },
      );

      final data = response.data['results'] as List? ?? [];

      return data
          .map((item) => Movie.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Erro getMovies: $e');
      throw Exception('Erro ao buscar filmes');
    }
  }

  Future<Movie> getMovieDetails(int movieId) async {
    try {
      final response = await _dio.get(
        'movie/$movieId',
        queryParameters: {
          'language': 'pt-BR',
        },
      );

      return Movie.fromJson(response.data);
    } catch (e) {
      debugPrint('Erro getMovieDetails: $e');
      throw Exception('Erro ao buscar detalhes do filme');
    }
  }

  Future<String> getDirector(int movieId) async {
    try {
      final response = await _dio.get('movie/$movieId/credits');

      final crew = response.data['crew'] as List? ?? [];

      final director = crew.cast<Map<String, dynamic>?>().firstWhere(
        (person) => person?['job'] == 'Director',
        orElse: () => null,
      );

      return director?['name'] ?? 'Desconhecido';
    } catch (e) {
      debugPrint('Erro getDirector: $e');
      return 'Desconhecido';
    }
  }

  Future<List<Movie>> getTrendingMovies() async {
    try {
      final response = await _dio.get(
        _trending,
        queryParameters: {
          'language': 'pt-BR',
        },
      );

      final data = response.data['results'] as List? ?? [];

      return data
          .map((item) => Movie.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Erro getTrendingMovies: $e');
      throw Exception('Erro ao buscar tendências');
    }
  }
}