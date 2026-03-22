import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/data/movie_api.dart';
import 'package:movie_app/data/models/movie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:movie_app/services/movie_update_notifier.dart';
import 'package:movie_app/services/movie_storage_service.dart';
import 'package:movie_app/widgets/progress_indicator_widget.dart';
import 'package:movie_app/pages/movie_detail/movie_detail_controller.dart';

class MovieDetailPage extends StatefulWidget {
  final String title;
  final Movie movie;

  const MovieDetailPage({
    super.key,
    required this.title,
    required this.movie,
  });

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  late final MovieDetailController controller;

  bool isWatched = false;
  bool isInWatchlist = false;

  double userRating = 0;

  final TextEditingController _commentController = TextEditingController();
  List<String> userComments = [];

  @override
  void initState() {
    super.initState();

    controller = MovieDetailController(GetIt.I<MovieApi>());
    controller.init(widget.movie);

    loadData();
    loadStatus();
  }

  @override
  void dispose() {
    controller.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble('rating_${widget.movie.id}', userRating);
    await prefs.setString(
      'comments_${widget.movie.id}',
      jsonEncode(userComments),
    );
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    userRating = prefs.getDouble('rating_${widget.movie.id}') ?? 0;

    final commentString = prefs.getString('comments_${widget.movie.id}');
    if (commentString != null) {
      userComments = List<String>.from(jsonDecode(commentString));
    }

    if (mounted) setState(() {});
  }

  Future<void> loadStatus() async {
    final service = MovieStorageService();

    final watched = await service.getWatched();
    final watchlist = await service.getWatchlist();

    if (!mounted) return;

    setState(() {
      isWatched = watched.contains(widget.movie.id.toString());
      isInWatchlist = watchlist.contains(widget.movie.id.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<Movie>(
        initialData: widget.movie,
        stream: controller.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: ProgressIndicatorWidget());
          }

          final movie = snapshot.data!;

          return CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              
              SliverAppBar(
                expandedHeight: 500,
                pinned: true,
                backgroundColor: Colors.black,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    movie.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  background: Image.network(
                    movie.poster,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image),
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(movie.plot),

                      const SizedBox(height: 20),

                      Text('Ano: ${movie.year}'),
                      const SizedBox(height: 5),
                      Text('Direção: ${movie.director ?? 'Desconhecido'}'),

                      const SizedBox(height: 20),

                      const Text('Sua avaliação:'),
                      const SizedBox(height: 6),
                      Row(
                        children: List.generate(5, (index) {
                          return GestureDetector(
                            onTap: () async {
                              setState(() => userRating = index + 1);
                              await saveData();
                            },
                            child: Icon(
                              index < userRating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 30,
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 20),

                      const Text('Seu comentário:'),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _commentController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Escreva algo...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: const Icon(Icons.save),
                          onPressed: () async {
                            final text = _commentController.text.trim();
                            if (text.isEmpty) return;

                            setState(() {
                              userComments.add(text);
                              _commentController.clear();
                            });

                            await saveData();
                          },
                        ),
                      ),

                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: userComments.length,
                        itemBuilder: (context, index) {
                          final comment = userComments[index];

                          return Dismissible(
                            key: ValueKey(comment + index.toString()),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.centerRight,
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (_) async {
                              setState(() {
                                userComments.removeAt(index);
                              });
                              await saveData();
                            },
                            child: Card(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(title: Text(comment)),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              final service = MovieStorageService();

                              await service.toggleWatched(widget.movie.id);

                              setState(() {
                                isWatched = !isWatched;
                                isInWatchlist = false;
                              });

                              MovieUpdateNotifier.notify();
                            },
                            child: isWatched
                                ? const Icon(Icons.check)
                                : const Text('Assistido'),
                          ),

                          const SizedBox(width: 10),

                          ElevatedButton(
                            onPressed: () async {
                              final service = MovieStorageService();

                              await service.toggleWatchlist(widget.movie.id);

                              setState(() {
                                isInWatchlist = !isInWatchlist;
                                isWatched = false;
                              });

                              MovieUpdateNotifier.notify();
                            },
                            child: Text(
                              isInWatchlist ? 'Na sua lista' : 'Quero ver',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}