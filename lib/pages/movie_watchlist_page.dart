import 'package:flutter/material.dart';
import 'package:movie_app/service_locator.dart';
import 'package:movie_app/data/models/movie.dart';
import 'package:movie_app/services/movie_storage_service.dart';
import 'package:movie_app/services/movie_update_notifier.dart';
import 'package:movie_app/pages/movie_list/movie_list_controller.dart';
import 'package:movie_app/pages/movie_list/widgets/movie_item_widget.dart';

class MovieWatchlistPage extends StatelessWidget {
  const MovieWatchlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = getIt<MovieListController>();

    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: MovieUpdateNotifier.notifier,
        builder: (context, value, child) {
          return FutureBuilder<List<Movie>>(
            future: MovieStorageService()
                .getWatchlist()
                .then((ids) => controller.getMoviesByIds(ids)),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final movies = snapshot.data!;

              if (movies.isEmpty) {
                return const Center(
                  child: Text('Sua lista está vazia'),
                );
              }

              return ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
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