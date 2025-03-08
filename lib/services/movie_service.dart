import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movies/models/movie_detail_model.dart';
import 'package:movies/models/movie_model.dart';

const apiKey = "62d6eb7df7866f5763b77d83912d1a7d";

class APIservices {
  final topRatedApi =
      "https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey";
  final upComingApi =
      "https://api.themoviedb.org/3/movie/upcoming?api_key=$apiKey";
  final popularApi =
      "https://api.themoviedb.org/3/movie/popular?api_key=$apiKey";
  final detailsApi = "https://api.themoviedb.org/3/movie/";
  final searchApi =
      "https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=";
  final allMoviesApi = "https://api.themoviedb.org/3/movie/";
  // for nowShowing moveis
  Future<List<Movie>> getTopRated() async {
    Uri url = Uri.parse(topRatedApi);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception("Failed to load data");
    }
  }

  // for up coming moveis
  Future<List<Movie>> getUpComing() async {
    Uri url = Uri.parse(upComingApi);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception("Failed to load data");
    }
  }

  Future<MovieDetailModel> getMovieDetails(int movieId) async {
    Uri url = Uri.parse("$detailsApi$movieId?api_key=$apiKey");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return MovieDetailModel.fromMap(data);
    } else {
      throw Exception("Failed to load movie details");
    }
  }

  // Add these methods to your APIservices class:

  Future<List<Movie>> getPopular({int page = 1}) async {
    Uri url = Uri.parse("$popularApi&page=$page");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception("Failed to load data");
    }
  }

  Future<List<Movie>> searchMovies(String query, int page) async {
    Uri url = Uri.parse("$searchApi$query&page=$page");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception("Failed to search movies");
    }
  }

  Future<List<Movie>> getMoviesByGenre(String genreName, int page) async {
    // First, get the genre ID from the name
    final genreId = await _getGenreIdByName(genreName);

    // Then get movies by genre ID
    Uri url = Uri.parse(
        "https://api.themoviedb.org/3/discover/movie?api_key=$apiKey&with_genres=$genreId&page=$page");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception("Failed to load movies by genre");
    }
  }

// Helper method to get genre ID by name
  Future<int> _getGenreIdByName(String name) async {
    // Map of genre names to IDs
    final Map<String, int> genreMap = {
      'Action': 28,
      'Adventure': 12,
      'Animation': 16,
      'Comedy': 35,
      'Crime': 80,
      'Documentary': 99,
      'Drama': 18,
      'Family': 10751,
      'Fantasy': 14,
      'History': 36,
      'Horror': 27,
      'Music': 10402,
      'Mystery': 9648,
      'Romance': 10749,
      'Science Fiction': 878,
      'TV Movie': 10770,
      'Thriller': 53,
      'War': 10752,
      'Western': 37,
    };

    return genreMap[name] ?? 28; // Default to Action if not found
  }
}
