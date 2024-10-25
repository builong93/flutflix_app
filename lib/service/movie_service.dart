import 'dart:convert';
import 'package:flutflix_app/model/movie.dart';
import 'package:http/http.dart' as http;

class MovieService {
  static const String apiKey = '6b896872d449869ce9971de3e40fc2cd';
  static const String baseUrl = 'https://api.themoviedb.org/3';

  // phương thức lấy trending movies
  Future<MovieResponse?> getTrendingMovies() async {
    final url = Uri.parse('$baseUrl/trending/movie/day?api_key=$apiKey');
    try {
      final respone = await http.get(url);
      if (respone.statusCode == 200) {
        // giải mã phản hồi
        final Map<String, dynamic> json = jsonDecode(respone.body);
        // convert json thành đối tượng MovieRespone
        return MovieResponse.fromJson(json);
      } else {
        print("Không load được dữ liệu Status Code: ${respone.statusCode}");
        return null;
      }
    } catch (error) {
      print("Lỗi không load được dữ liệu $error");
      return null;
    }
  }

  Future<List<String>> fetchTrendingMoviePosters() async {
    final url = Uri.parse('$baseUrl/trending/movie/day?api_key=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List movies = data['results'];
      // Lấy danh sách poster_path cho các phim
      return movies.map<String>((movie) => movie['poster_path']).toList();
    } else {
      throw Exception('Failed to load trending movies');
    }
  }

  Future<List<String>> fetchTopRatedMoviePosters() async {
    final url = Uri.parse('$baseUrl/movie/top_rated?api_key=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Kiểm tra nếu data['results'] null hoặc không phải là List
      if (data['results'] == null || data['results'] is! List) {
        print('Error: results is null or not a list');
        return []; // Trả về danh sách rỗng để tránh lỗi tiếp theo
      }

      final List movies = data['results'];
      return movies
          .map<String>((movie) => movie['poster_path'] as String)
          .toList();
    } else {
      print(
          'Failed to fetch top rated movies with status code: ${response.statusCode}');
      throw Exception('Failed to load top-rated movies');
    }
  }
}
