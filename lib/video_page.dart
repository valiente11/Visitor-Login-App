import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart'; //flutter uygulamasında youtube videosu açmaya yarar 

class VideoPage extends StatefulWidget { //dinamik sayfa video role göre açılır 
  final String videoId; //videoların idsi alındı 
  const VideoPage({Key? key, required this.videoId}) : super(key: key);

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController( //sayfa açılınca çalışır 
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true, //oynatma sayfa açılınca başlar 
        mute: false,  //Ses açık  .
      ),
    );
  }

  @override
  void dispose() {
    _controller.close(); //video bitince sayfa kapansın 
    super.dispose();
  }
  //arayüz 
  @override 
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder( //videonun sayfa yapısına entegresi
      player: YoutubePlayer(controller: _controller), //video
      builder: (context, player) => Scaffold( 
        appBar: AppBar(title: const Text('Watch Video')),//başlık
        body: Center(child: player), //video ekranın ortasında olsun 
      ),
    );
  }
}
