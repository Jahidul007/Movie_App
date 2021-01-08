import 'package:flutter/material.dart';
import 'package:movie_app/model/movie.dart';
import 'package:movie_app/style/theme.dart' as Style;

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  MovieDetailScreen({Key key, @required this.movie}) : super(key: key);

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState(movie);
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {

  final Movie movie;


  _MovieDetailScreenState(this.movie);

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
