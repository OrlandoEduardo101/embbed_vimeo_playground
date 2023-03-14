import 'package:embbed_vimeo_playground/vimeo/vimeo_error.dart';
import 'package:flutter/material.dart';
import 'package:uno/uno.dart';
import 'video_player.dart';
import 'vimeo_video.dart';

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

  VimeoVideo? vimeoVideo;

  Future<dynamic> initVimeo() async {
    try {
      // var res = await Vimeo.fromUrl(
      //   Uri.parse('https://vimeo.com/video/$videoId'),
      //   accessKey: perssonalAccesToken,
      // ).load;

      final url = '/me/videos/$videoId';
      final headers = {'authorization': 'bearer $perssonalAccesToken'};
      final response = await Uno(baseURL: 'https://api.vimeo.com').get(url, headers: headers);

      final video = VimeoVideo.fromJson(response.data);

      if (video is VimeoError) {
        return video;
      }

      // ignore: unnecessary_type_check
      if (video is VimeoVideo) {
        vimeoVideo = video;
      }

      return vimeoVideo;
    } catch (e) {
      return VimeoError(error: e.toString());
    }
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
    return Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        body: Stack(alignment: Alignment.topCenter, children: [
          FutureBuilder<dynamic>(
            future: initVimeo(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade700)),
                    child: const AspectRatio(aspectRatio: 16 / 9, child: Center(child: CircularProgressIndicator())));
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
                videoUrl: (snapshot.data as VimeoVideo).files?.last.link.toString(),
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
  }
}
