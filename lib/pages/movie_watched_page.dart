import 'package:flutter/material.dart';
import 'package:movie_app/service_locator.dart';
import 'package:movie_app/data/models/movie.dart';
import 'package:movie_app/services/movie_storage_service.dart';
import 'package:movie_app/services/movie_update_notifier.dart';
import 'package:movie_app/pages/movie_list/movie_list_controller.dart';
import 'package:movie_app/pages/movie_list/widgets/movie_item_widget.dart';

class MovieWatchedPage extends StatefulWidget {
  const MovieWatchedPage({super.key});

  @override
  State<MovieWatchedPage> createState() => _MovieWatchedPageState();
}

class _MovieWatchedPageState extends State<MovieWatchedPage> {
  late Future<List<Movie>> future;

  @override
  void initState() {
    super.initState();
    loadMovies();
  }

  void loadMovies() {
    final controller = getIt<MovieListController>();

    future = MovieStorageService()
        .getWatched()
        .then((ids) => controller.getMoviesByIds(ids));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: MovieUpdateNotifier.notifier,
        builder: (context, value, child) {
          loadMovies(); // 🔥 RECARREGA AUTOMATICAMENTE

          return FutureBuilder<List<Movie>>(
            future: future,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final movies = snapshot.data!;

              if (movies.isEmpty) {
                return const Center(
                    child: Text('Nenhum filme assistido'));
              }

              return ListView.builder(
                itemCount: movies.length,
                itemBuilder: (_, index) {
                  return MovieItemWidget(movie: movies[index]);
                },
              );
            },
          );
        },
      ),
    );
  }
}