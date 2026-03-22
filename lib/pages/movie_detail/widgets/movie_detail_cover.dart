import 'package:flutter/material.dart';
import 'package:movie_app/data/models/movie.dart';

class MovieDetailPage extends StatefulWidget {
  final Movie movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  double userRating = 0;
  final TextEditingController _commentController = TextEditingController();
  String userComment = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 23, 15, 70),
      resizeToAvoidBottomInset: true,
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [

         
          SliverAppBar(
            backgroundColor: const Color.fromARGB(255, 23, 15, 70),
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                widget.movie.poster,
                fit: BoxFit.cover,
              ),
            ),
          ),

          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  
                  Text(
                    widget.movie.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 10),

                  
                  Text(
                    widget.movie.plot,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 20),

                  
                  Text(
                    'Ano: ${widget.movie.year}',
                    style: const TextStyle(color: Colors.white),
                  ),

                  const SizedBox(height: 10),

                 
                  Text(
                    'Direção: ${widget.movie.director ?? 'Desconhecido'}',
                    style: const TextStyle(color: Colors.white),
                  ),

                  const SizedBox(height: 20),

                  
                  const Text(
                    'Sua avaliação:',
                    style: TextStyle(color: Colors.white),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            userRating = index + 1;
                          });
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

                  
                  const Text(
                    'Seu comentário:',
                    style: TextStyle(color: Colors.white),
                  ),

                  const SizedBox(height: 6),

                  TextField(
                    controller: _commentController,
                    style: const TextStyle(color: Colors.white),
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Escreva algo sobre o filme...',
                      hintStyle:
                          const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () {
                      if (_commentController.text.trim().isEmpty) return;

                      setState(() {
                        userComment = _commentController.text;
                      });
                    },
                    child: const Text('Salvar'),
                  ),

                  if (userComment.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        userComment,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}