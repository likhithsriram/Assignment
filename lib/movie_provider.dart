import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'movie.dart';

class MovieProvider with ChangeNotifier {
  List<Movie> _movies = [];
  List<Movie> _filteredMovies = [];
  bool _isLoading = true;

  List<Movie> get movies => _filteredMovies;
  bool get isLoading => _isLoading;

  MovieProvider() {
    fetchPopularMovies();
  }

  Future<void> fetchPopularMovies() async {
    const String url = 'https://imdb188.p.rapidapi.com/api/v1/getPopularMovies';
    const String hostKey = 'imdb188.p.rapidapi.com';
    const String apiKey = '044d44bd14msh50a6a9905078c07p1b3b7fjsnd9a91de93de8';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'X-RapidAPI-Host': hostKey,
          'X-RapidAPI-Key': apiKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({}),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        _movies = (data['data']['list'] as List)
            .map((movieJson) => Movie.fromJson(movieJson))
            .toList();
        _filteredMovies = _movies;
        _isLoading = false;
        notifyListeners();
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  void filterMovies(String query) {
    _filteredMovies = _movies.where((movie) {
      final title = movie.title.toLowerCase();
      final searchQuery = query.toLowerCase();
      return title.contains(searchQuery);
    }).toList();
    notifyListeners();
  }
}
