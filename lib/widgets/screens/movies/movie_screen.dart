import 'package:flutter/material.dart';
import 'package:movies/models/movie_model.dart';
import 'package:movies/services/movie_service.dart';
import 'package:movies/widgets/screens/movies/movies_detail.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({Key? key}) : super(key: key);

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Movie> _movies = [];
  List<String> _genres = [
    'All',
    'Action',
    'Adventure',
    'Animation',
    'Comedy',
    'Crime',
    'Documentary',
    'Drama',
    'Family',
    'Fantasy',
    'History',
    'Horror',
    'Music',
    'Mystery',
    'Romance',
    'Science Fiction',
    'TV Movie',
    'Thriller',
    'War',
    'Western'
  ];

  String _selectedGenre = 'All';
  bool _isLoading = false;
  int _page = 1;
  String _searchQuery = '';
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadMovies();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMore) {
      _loadMoreMovies();
    }
  }

  Future<void> _loadMovies({String? genre, String? query}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      if (genre != null || query != null) {
        _movies = [];
        _page = 1;
        _hasMore = true;
        if (genre != null) _selectedGenre = genre;
        if (query != null) _searchQuery = query;
      }
    });

    try {
      List<Movie> newMovies = [];

      if (_searchQuery.isNotEmpty) {
        // Search by query
        newMovies = await APIservices().searchMovies(_searchQuery, _page);
      } else if (_selectedGenre != 'All') {
        // Filter by genre
        // Assuming you have a method in APIservices to get movies by genre
        newMovies = await APIservices().getMoviesByGenre(_selectedGenre, _page);
      } else {
        // Default: get popular movies
        newMovies = await APIservices().getPopular(page: _page);
      }

      setState(() {
        if (newMovies.isEmpty || newMovies.length < 20) {
          _hasMore = false;
        }

        if (_page == 1) {
          _movies = newMovies;
        } else {
          _movies.addAll(newMovies);
        }

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading movies: $e')),
      );
    }
  }

  void _loadMoreMovies() {
    _page++;
    _loadMovies();
  }

  void _onSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      _loadMovies(query: query);
    }
  }

  void _onGenreSelected(String genre) {
    if (genre != _selectedGenre) {
      _loadMovies(genre: genre);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            title: const Text(
              'Movies',
              style: TextStyle(
                color: Colors.red,
                fontFamily: 'Poppins',
                fontSize: 18.0,
              ),
            ),
            centerTitle: true,
            floating: true,
            pinned: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _searchController,
                  onSubmitted: (_) => _onSearch(),
                  decoration: InputDecoration(
                    hintText: 'Search movies...',
                    hintStyle: const TextStyle(fontFamily: 'Poppins'),
                    prefixIcon: const Icon(Icons.search, color: Colors.red),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        _searchController.clear();
                        if (_searchQuery.isNotEmpty) {
                          setState(() {
                            _searchQuery = '';
                          });
                          _loadMovies();
                        }
                      },
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
        body: Column(
          children: [
            // Genre filters
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _genres.length,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemBuilder: (context, index) {
                  final genre = _genres[index];
                  final isSelected = genre == _selectedGenre;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: FilterChip(
                      label: Text(
                        genre,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: isSelected ? Colors.white : Colors.black,
                          fontSize: 12,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: Colors.red,
                      backgroundColor: Colors.grey[200],
                      onSelected: (_) => _onGenreSelected(genre),
                      checkmarkColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Movies grid
            Expanded(
              child: _movies.isEmpty && !_isLoading
                  ? const Center(
                      child: Text(
                        'No movies found',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                        ),
                      ),
                    )
                  : GridView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(8),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: _isLoading && _movies.isEmpty
                          ? 0
                          : _isLoading
                              ? _movies.length + 2 // Show 2 loading indicators
                              : _movies.length,
                      itemBuilder: (context, index) {
                        if (index >= _movies.length) {
                          return _buildLoadingCard();
                        }

                        final movie = _movies[index];
                        return _buildMovieCard(movie);
                      },
                    ),
            ),

            // Bottom loading indicator
            if (_isLoading && _movies.isNotEmpty)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: CircularProgressIndicator(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieCard(Movie movie) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailScreen(movieId: movie.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(10.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Backdrop image as background
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                'https://image.tmdb.org/t/p/w500${movie.backdropPath}',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, size: 50),
                ),
              ),
            ),
            // Dark overlay for better text visibility
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
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
            // Small poster in bottom left
            Positioned(
              bottom: 60,
              left: 10,
              width: 70,
              height: 100,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[400],
                      child: const Icon(Icons.image, size: 30),
                    ),
                  ),
                ),
              ),
            ),
            // Movie title at bottom
            Positioned(
              bottom: 30,
              left: 10,
              right: 10,
              child: Text(
                movie.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Rating and vote count
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${movie.voteAverage.toStringAsFixed(1)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 12.0,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(${movie.voteCount})',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontFamily: 'Poppins',
                      fontSize: 10.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.red),
        ),
      ),
    );
  }
}
