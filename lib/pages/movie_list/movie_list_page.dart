import 'package:flutter/material.dart';
import 'package:movie_app/service_locator.dart';
import 'package:movie_app/data/models/movie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movie_app/pages/movie_search_page.dart';
import 'package:movie_app/pages/movie_watched_page.dart';
import 'package:movie_app/pages/movie_watchlist_page.dart';
import 'package:movie_app/widgets/progress_indicator_widget.dart';
import 'package:movie_app/pages/movie_list/movie_list_controller.dart';
import 'package:movie_app/pages/movie_list/widgets/movie_item_widget.dart';

class MovieListPage extends StatefulWidget {
  final String title;

  const MovieListPage({super.key, required this.title});

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  late final MovieListController controller;

  @override
  void initState() {
    super.initState();
    controller = getIt<MovieListController>();
    controller.init();
  }

  @override
  void dispose() {
    controller.movies.dispose();
    super.dispose();
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MovieSearchPage(),
                  ),
                );
              },
            ),

            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await logout();
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: "Recomendados"),
              Tab(text: "Assistidos"),
              Tab(text: "Quero ver"),
            ],
          ),
        ),

        body: TabBarView(
          children: [
            ValueListenableBuilder<List<Movie>?>(
              valueListenable: controller.movies,
              builder: (context, movies, _) {
                if (movies == null) {
                  return const Center(
                    child: ProgressIndicatorWidget(),
                  );
                }

                if (movies.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.movie_outlined, size: 48),
                        SizedBox(height: 8),
                        Text('Nenhum filme encontrado'),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    return MovieItemWidget(movie: movies[index]);
                  },
                );
              },
            ),

         
            const MovieWatchedPage(),

       
            const MovieWatchlistPage(),
          ],
        ),
      ),
    );
  }
}