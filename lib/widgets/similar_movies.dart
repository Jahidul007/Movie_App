import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_app/bloc/get_movie_similar_bloc.dart';
import 'package:movie_app/bloc/get_movies_bloc.dart';
import 'package:movie_app/model/movie.dart';
import 'package:movie_app/model/movie_response.dart';
import 'package:movie_app/style/theme.dart' as Style;

import 'buildErrorWidget.dart';
import 'buildLoadingWidget.dart';

class SimilarMovies extends StatefulWidget {
  final int id;

  SimilarMovies({Key key, @required this.id}) : super(key: key);

  @override
  _TopMoviesState createState() => _TopMoviesState(id);
}

class _TopMoviesState extends State<SimilarMovies> {
  final int id;

  _TopMoviesState(this.id);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    similarMovieBloc..getSimilarMovie(id);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    similarMovieBloc..drainStream();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 20, top: 20),
          child: Text(
            "SIMILAR MOVIES",
            style: TextStyle(
              color: Style.Colors.titleColor,
              fontWeight: FontWeight.w500,
              fontSize: 12.0,
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        StreamBuilder<MovieResponse>(
          stream: similarMovieBloc.subject.stream,
          builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.error != null &&
                  snapshot.data.error.length > 0) {
                return buildErrorWidget(snapshot.data.error);
              }
              return _buildTopMovieWidget(snapshot.data);
            } else if (snapshot.hasError) {
              return buildErrorWidget(snapshot.error);
            } else {
              return buildLoadingWidget();
            }
          },
        )
      ],
    );
  }
  Widget _buildTopMovieWidget(MovieResponse data) {
    List<Movie> movies = data.movies;

    if (movies.length == 0) {
      return Container(
        child: Text("No movies"),
      );
    } else {
      return Container(
        height: 270,
        padding: EdgeInsets.only(left: 10),
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: 5,
                  right: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    movies[index].poster == null
                        ? Container(
                      width: 120,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Style.Colors.secondColor,
                        borderRadius:
                        BorderRadius.all(Radius.circular(2.0)),
                        shape: BoxShape.rectangle,
                      ),
                      child: Column(
                        children: <Widget>[
                          Icon(
                            EvaIcons.fileOutline,
                            color: Colors.white,
                            size: 50,
                          )
                        ],
                      ),
                    )
                        : Container(
                      width: 120,
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.all(Radius.circular(2.0)),
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://image.tmdb.org/t/p/w200" +
                                    movies[index].poster),
                            fit: BoxFit.cover),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 100,
                      child: Text(
                        movies[index].title,
                        maxLines: 2,
                        style: TextStyle(
                          height: 1.4,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11.0,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          movies[index].rating.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        RatingBar.builder(
                          itemSize: 8.0,
                          initialRating: movies[index].rating / 2,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                          itemBuilder: (context, _) => Icon(
                            EvaIcons.star,
                            color: Style.Colors.secondColor,
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        )
                      ],
                    ),
                  ],
                ),
              );
            }),
      );
    }
  }

}