import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../service/movie_service.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({super.key});

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  final MovieService _movieService = MovieService();
  List<String> _trendingPosters = [];
  List<String> _topRatedPosters = [];
  bool _isLoadingTrending = true;
  bool _isLoadingTopRated = true;

  @override
  void initState() {
    super.initState();
    _fetchTrendingMovies();
    _fetchTopRatedMovies();
  }

  Future<void> _fetchTrendingMovies() async {
    try {
      final posters = await _movieService.fetchTrendingMoviePosters();
      setState(() {
        _trendingPosters = posters;
        _isLoadingTrending = false;
      });
    } catch (e) {
      print('Error fetching trending movies: $e');
    }
  }

  Future<void> _fetchTopRatedMovies() async {
    try {
      final posters = await _movieService.fetchTopRatedMoviePosters();
      setState(() {
        _topRatedPosters = posters;
        _isLoadingTopRated = false;
      });
    } catch (e) {
      print('Error fetching top-rated movies: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "FLUTFLIX",
          style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 36,
              color: Color.fromRGBO(230, 30, 37, 1)),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color.fromRGBO(35, 39, 46, 1),
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Trending Movies",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 24),
            ),
          ),
          _isLoadingTrending
              ? const Center(child: CircularProgressIndicator())
              : CarouselSlider(
                  options: CarouselOptions(
                    height: 400,
                    autoPlay: true,
                    enlargeCenterPage: true,
                  ),
                  items: _trendingPosters.map((posterPath) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              'https://image.tmdb.org/t/p/w500/$posterPath',
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Top Rated Movies",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 24),
            ),
          ),
          _isLoadingTopRated
              ? const Center(child: CircularProgressIndicator())
              : SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _topRatedPosters.length,
                    itemBuilder: (context, index) {
                      final posterPath = _topRatedPosters[index];
                      return Container(
                        width: 120,
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w500/$posterPath',
                            fit: BoxFit.cover,
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
