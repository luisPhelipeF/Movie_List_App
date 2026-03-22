import 'package:flutter/material.dart';
import 'package:movie_app/data/movie_api.dart';
import 'package:movie_app/service_locator.dart';
import 'package:movie_app/data/models/movie.dart';
import 'package:movie_app/pages/movie_detail/movie_detail_page.dart';

class MovieSearchPage extends StatefulWidget {
  const MovieSearchPage({super.key});

  @override
  State<MovieSearchPage> createState() => _MovieSearchPageState();
}

class _MovieSearchPageState extends State<MovieSearchPage> {
  final MovieApi api = getIt<MovieApi>();
  final TextEditingController _controller = TextEditingController();

  List<Movie> _movies = [];
  bool isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) return;

    setState(() => isLoading = true);

    try {
      final result = await api.getMovies(query);

      final moviesWithDirector = await Future.wait(
        result.map((movie) async {
          final director = await api.getDirector(movie.id);
          return movie.copyWith(director: director);
        }),
      );

      setState(() {
        _movies = moviesWithDirector;
      });
    } catch (e) {
      debugPrint('Erro na busca: $e');
      setState(() {
        _movies = [];
      });
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Filme'),
      ),
      body: Column(
        children: [
          
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _controller,
              onSubmitted: search,
              decoration: InputDecoration(
                hintText: 'Procurar filme',
                prefixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => search(_controller.text),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

         
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(10),
              child: CircularProgressIndicator(),
            ),

          
          Expanded(
            child: _movies.isEmpty && !isLoading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 48),
                        SizedBox(height: 8),
                        Text('Nenhum resultado'),
                      ],
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: _movies.length,
                    itemBuilder: (context, index) {
                      final movie = _movies[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MovieDetailPage(
                                  title: movie.title,
                                  movie: movie,
                                ),
                              ),
                            );
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: SizedBox(
                                  width: 120,
                                  height: 180,
                                  child: movie.poster.isNotEmpty
                                      ? Image.network(
                                          movie.poster,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              const Icon(Icons.broken_image),
                                        )
                                      : const Icon(Icons.image_not_supported),
                                ),
                              ),

                              const SizedBox(width: 16),

                              
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      movie.title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    Text(
                                      movie.year,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    Text(
                                      'Diretor: ${movie.director ?? 'Desconhecido'}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}