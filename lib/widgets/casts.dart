import 'package:flutter/material.dart';
import 'package:movie_app/bloc/get_casts_bloc.dart';
import 'package:movie_app/model/cast.dart';
import 'package:movie_app/model/cast_response.dart';
import 'package:movie_app/style/theme.dart' as Style;

import 'buildErrorWidget.dart';
import 'buildLoadingWidget.dart';

class Casts extends StatefulWidget {
  final int id;

  Casts({Key key, @required this.id}) : super(key: key);

  @override
  _CastsState createState() => _CastsState(id);
}

class _CastsState extends State<Casts> {
  final int id;

  _CastsState(this.id);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    castsBloc..getCasts(id);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    castsBloc..drainStream();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 10, top: 20),
          child: Text(
            "CASTS",
            style: TextStyle(
              color: Style.Colors.titleColor,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        StreamBuilder<CastResponse>(
          stream: castsBloc.subject.stream,
          builder: (context, AsyncSnapshot<CastResponse> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.error != null &&
                  snapshot.data.error.length > 0) {
                return buildErrorWidget(snapshot.data.error);
              }
              return _buildCastWidget(snapshot.data);
            } else if (snapshot.hasError) {
              return buildErrorWidget(snapshot.error);
            } else {
              return buildLoadingWidget();
            }
          },
        ),
      ],
    );
  }

  Widget _buildCastWidget(CastResponse data) {
    List<Cast> cast = data.casts;

    return Container(
      height: 140,
      padding: EdgeInsets.only(left: 10),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: cast.length,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.only(top: 10, right: 8),
              width: 100,
              child: GestureDetector(
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              "https://image.tmdb.org/t/p/w300/"+
                                  cast[index].img),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      cast[index].name,
                      maxLines: 2,
                      style: TextStyle(
                          height: 1.4,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 9),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      cast[index].character,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          height: 1.4,
                          color: Style.Colors.titleColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 7),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
