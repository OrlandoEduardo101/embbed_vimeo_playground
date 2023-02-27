import 'package:embbed_vimeo_playground/video_player.dart';
import 'package:embbed_vimeo_playground/vimeo/vimeo.dart';
import 'package:embbed_vimeo_playground/vimeo/vimeo_error.dart';
import 'package:flutter/material.dart';
import 'package:uno/uno.dart';

import 'vimeo/vimeo_video.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        //
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final videoId = '';
  final clientID = '';
  final clientSecrets = '';
  final perssonalAccesToken = '';
  String urlVideo = '';

  // Future<void> _incrementCounter() async {
  //   final url = 'https://vimeo.com/$videoId';
  //   final headers = {'authorization': 'bearer $perssonalAccesToken'};
  //   final response = await Uno(baseURL: '').get(url, headers: headers);
  //   setState(() {
  //     urlVideo = response.toString();
  //   });
  // }

  VimeoVideo? vimeoVideo;

  Future<dynamic> initVimeo() async {
    var res = await Vimeo.fromUrl(
      Uri.parse('https://vimeo.com/video/$videoId'),
      accessKey: perssonalAccesToken,
    ).load;

    if (res is VimeoError) {
      return res;
    }

    bool autoPlay = false;
    if (res is VimeoVideo) {
      vimeoVideo = res;
    }

    return vimeoVideo;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //
    // _incrementCounter();

    // if (urlVideo.isEmpty) return Container();

    return Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        body: Stack(alignment: Alignment.topCenter, children: [
          FutureBuilder<dynamic>(
            future: initVimeo(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade700)),
                    child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(child: const Center(child: CircularProgressIndicator()))));
              }

              if (snapshot.data is VimeoError) {
                return Container(
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade700)),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Text(
                          "${(snapshot.data as VimeoError).developerMessage}\n${(snapshot.data as VimeoError).errorCode ?? ""}\n\n${(snapshot.data as VimeoError).error}",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                );
              }


              return VideoPlayerWidget.fromUrl(
                videoUrl: (snapshot.data as VimeoVideo).playerEmbedUrl.toString(),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 48,
              color: Colors.red.withOpacity(0.3),
              alignment: Alignment.center,
              child: const Text(
                'Vimeo Player Example',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ]));

    // return VideoPlayerWidget.fromUrl(
    //   videoUrl: urlVideo,
    // );

    // return WebviewScaffold(
    //   url: "https://player.vimeo.com/video/$videoId?title=0&byline=0&portrait=0",
    //   headers: headers,
    //   withZoom: false,
    //   withLocalStorage: true,
    //   hidden: true,
    //   debuggingEnabled: true,
    //   initialChild: Container(
    //     color: Colors.white,
    //     child: const Center(
    //       child: CircularProgressIndicator(),
    //     ),
    //   ),
    // );
  }
}
