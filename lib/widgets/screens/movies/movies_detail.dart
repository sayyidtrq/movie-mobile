import 'package:flutter/material.dart';
import 'package:movies/models/movie_detail_model.dart';
import 'package:movies/services/auth_services.dart';
import 'package:movies/services/movie_service.dart';
import 'package:intl/intl.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailScreen({Key? key, required this.movieId}) : super(key: key);

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late Future<MovieDetailModel> movieDetail;
  final AuthService _authService = AuthService();
  bool _isInFavorites = false;
  bool _isCheckingFavorite = true;

  @override
  void initState() {
    super.initState();
    movieDetail = APIservices().getMovieDetails(widget.movieId);
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    if (!_authService.isLoggedIn) {
      setState(() {
        _isCheckingFavorite = false;
      });
      return;
    }

    final isFavorite =
        await _authService.isMovieInFavorites(widget.movieId.toString());

    if (mounted) {
      setState(() {
        _isInFavorites = isFavorite;
        _isCheckingFavorite = false;
      });
    }
  }

  Future<void> _toggleFavorite(MovieDetailModel movie) async {
    if (!_authService.isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login to add favorites'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final movieId = movie.id.toString();
    bool success;

    if (_isInFavorites) {
      success = await _authService.removeMovieFromFavorites(movieId);
      if (success && mounted) {
        setState(() {
          _isInFavorites = false;
        });
      }
    } else {
      // Convert MovieDetailModel to map for Firestore
      final movieData = {
        'id': movie.id,
        'title': movie.title,
        'posterPath': movie.posterPath,
        'backdropPath': movie.backdropPath,
        'voteAverage': movie.voteAverage,
        'voteCount': movie.voteCount,
        'overview': movie.overview,
      };

      success = await _authService.addMovieToFavorites(movieData);
      if (success && mounted) {
        setState(() {
          _isInFavorites = true;
        });
      }
    }

    // Show feedback
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isInFavorites ? 'Added to favorites' : 'Removed from favorites',
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  String formatCurrency(int amount) {
    final formatter = NumberFormat.currency(symbol: '\$');
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FutureBuilder<MovieDetailModel>(
          future: movieDetail,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                !snapshot.hasData ||
                _isCheckingFavorite) {
              return const FloatingActionButton(
                onPressed: null,
                backgroundColor: Colors.grey,
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              );
            }

            final movie = snapshot.data!;

            return FloatingActionButton(
              onPressed: () => _toggleFavorite(movie),
              backgroundColor: _isInFavorites ? Colors.white : Colors.red,
              child: Icon(
                _isInFavorites ? Icons.favorite : Icons.favorite_border,
                color: _isInFavorites ? Colors.red : Colors.white,
              ),
            );
          }),
      body: FutureBuilder<MovieDetailModel>(
        future: movieDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.red),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text('No movie data found'),
            );
          }

          final movie = snapshot.data!;

          return CustomScrollView(
            slivers: [
              // App Bar with backdrop image
              SliverAppBar(
                expandedHeight: 200.0,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Backdrop image
                      Image.network(
                        'https://image.tmdb.org/t/p/original${movie.backdropPath}',
                        fit: BoxFit.cover,
                      ),
                      // Gradient overlay for better visibility
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              // Movie content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Movie poster and basic info
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Poster
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              'https://image.tmdb.org/t/p/w300${movie.posterPath}',
                              height: 180,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Basic info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie.title,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  DateFormat('MMMM d, y')
                                      .format(movie.releaseDate),
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      movie.voteAverage.toStringAsFixed(1),
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '(${movie.voteCount})',
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Genres
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: movie.genres.map((genre) {
                          return Chip(
                            label: Text(
                              genre.name,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                            backgroundColor: Colors.red,
                          );
                        }).toList(),
                      ),

                      // Tagline if available
                      if (movie.tagline.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text(
                          '"${movie.tagline}"',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        ),
                      ],

                      // Overview
                      const SizedBox(height: 16),
                      const Text(
                        'Overview',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        movie.overview,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.justify,
                      ),

                      // Additional Information
                      const SizedBox(height: 24),
                      const Text(
                        'Movie Information',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow('Status', movie.status),
                      _buildInfoRow('Budget', formatCurrency(movie.budget)),
                      _buildInfoRow('Revenue', formatCurrency(movie.revenue)),
                      _buildInfoRow(
                          'Popularity', movie.popularity.toStringAsFixed(1)),
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
