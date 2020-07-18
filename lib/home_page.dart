import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pinkvilla_social_app/spinner_animation.dart';
import 'package:pinkvilla_social_app/video_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List videoData = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() {
    Dio dio = new Dio();
    Response response;
    try {
      dio
          .get("https://www.pinkvilla.com/feed/video-test/video-feed.json")
          .then((value) {
        response = value;
        videoData = response.data;
        setState(() {});
        print(response);
      });
    } catch (e) {
      debugPrint(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: videoData.isNotEmpty
          ? Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: <Widget>[
                  PageView.builder(
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, position) {
                        return Container(
                          color: Colors.black,
                          child: Stack(
                            children: <Widget>[
                              VideoScreen(
                                url: videoData[position]["url"],
                              ),
                              Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 5,
                                      child: videoDesc(
                                          videoData[position]["user"]["name"],
                                          videoData[position]["title"],
                                          videoData[position]["user"]
                                              ["headshot"]),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            bottom: 60, right: 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            videoControlAction(
                                                icon: FontAwesomeIcons.heart,
                                                label: videoData[position]
                                                        ["like-count"]
                                                    .toString()),
                                            videoControlAction(
                                                icon: FontAwesomeIcons.comment,
                                                label: videoData[position]
                                                        ["comment-count"]
                                                    .toString()),
                                            videoControlAction(
                                                icon: FontAwesomeIcons.share,
                                                label: videoData[position]
                                                        ["share-count"]
                                                    .toString(),
                                                size: 27),
                                            SpinnerAnimation(
                                                body: audioSpinner(
                                                    videoData[position]["user"]
                                                        ["headshot"]))
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                      itemCount: videoData.length),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget videoDesc(userName, description, profile) {
    return Container(
      padding: EdgeInsets.only(left: 16, bottom: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              userProfile(profile),
              Padding(
                padding: EdgeInsets.only(top: 7, bottom: 7, left: 5),
                child: Card(
                  color: Colors.black12,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "@$userName",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 4, bottom: 7),
            child: Card(
              color: Colors.black12,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(description,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black,
                            offset: Offset(5.0, 5.0),
                          ),
                        ],
                        fontWeight: FontWeight.w300)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget userProfile(image) {
    print(image);
    return Column(
      children: <Widget>[
        Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  image: DecorationImage(image: NetworkImage(image)),
                  border: Border.all(
                      color: Colors.white,
                      width: 1.0,
                      style: BorderStyle.solid),
                  color: Colors.black,
                  shape: BoxShape.circle),
            ),
          ],
        )
      ],
    );
  }

  Widget videoControlAction({IconData icon, String label, double size = 35}) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: <Widget>[
          Icon(
            icon,
            color: Colors.white,
            size: size,
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: Text(
              label ?? "",
              style: TextStyle(shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.black,
                  offset: Offset(5.0, 5.0),
                ),
              ], fontSize: 10, color: Colors.white,fontWeight:FontWeight.bold)
            ),
          )
        ],
      ),
    );
  }

  Widget audioSpinner(image) {
    return Container(
        width: 50.0,
        height: 50.0,
        decoration: BoxDecoration(
            gradient: audioDiscGradient,
            shape: BoxShape.circle,
            image: DecorationImage(image: NetworkImage(image))));
  }

  LinearGradient get audioDiscGradient => LinearGradient(colors: [
        Colors.grey[800],
        Colors.grey[900],
        Colors.grey[900],
        Colors.grey[800]
      ], stops: [
        0.0,
        0.4,
        0.6,
        1.0
      ], begin: Alignment.bottomLeft, end: Alignment.topRight);
}
