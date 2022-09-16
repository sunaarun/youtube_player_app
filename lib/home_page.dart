import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String title ,author ;
  late bool isPlaying, isMute;
  final String url = "https://www.youtube.com/watch?v=MdWTb-I8-jo";
  late YoutubePlayer youtubePlayer;
  late YoutubePlayerController _controller;
  late String id;

  @override
  void initState() {
    super.initState();
    isMute = false;
    id = YoutubePlayer.convertUrlToId(url)!;
    _controller= YoutubePlayerController(initialVideoId: id,
    flags: YoutubePlayerFlags(autoPlay: false),);
    youtubePlayer= YoutubePlayer(controller: _controller,);
    isPlaying =_controller.value.isPlaying;
    title = _controller.metadata.title;
    author= _controller.metadata.author;
  }

 Widget setTitle(){
    if(_controller.metadata.title!=null) {
      setState(() {
        title = _controller.metadata.title;
      });
      return textBuilder(title);
    }
    else {
     return setTitle();
    }

 }
  Widget setAuthor(){
    if(_controller.metadata.author!=null) {
      setState(() {
        author = _controller.metadata.author;
      });
      return textBuilder(author, color: Colors.pink, fontSize: 25, weight: FontWeight.bold, );
    }
    else {
      return setAuthor();
    }

  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Youtube Player App'),
      ),
      body: Column(
        children: [
          Container(height: 250, width: 400, color: Colors.pink, child: youtubePlayer,),
        title==null?  setTitle():
        textBuilder(_controller.metadata.title),
          author==null? setAuthor():
          textBuilder(_controller.metadata.author, color: Colors.pink, weight: FontWeight.bold, fontSize: 25),
          buttonRowBuilder()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if(isMute)
            {_controller.unMute();}
          else{
            _controller.mute();
          }
          setState(() {
            isMute= !isMute;
          });
        },
        child: isMute?Icon(Icons.volume_off):Icon(Icons.volume_up),
      ),
    );
  }

  textBuilder(String string, {double fontSize = 17, FontWeight weight = FontWeight.normal, Color color = Colors.black})
  {
    return Container(
        margin: const EdgeInsets.all(16),
        alignment: Alignment.center,
        child: Text(string, style: TextStyle(fontSize: fontSize, fontWeight: weight, color: color),));
  }

  buttonRowBuilder(){
    double size = 35;
    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            if(_controller.value.position<= Duration(seconds: 10)){
              _controller.seekTo(Duration(seconds: 0));
            }
            else{
              var p = _controller.value.position - Duration(seconds: 10);
              _controller.seekTo(p);
            }

          }, icon: const Icon(Icons.first_page,),iconSize: size,),
        IconButton(
          onPressed: () {
             if(_controller.value.isPlaying)
               {
                 _controller.pause();
               }
             else{
               _controller.play();
             }
             setState(() {
               isPlaying= !isPlaying;
             });
              }
          , icon: isPlaying? const Icon(Icons.pause):Icon(Icons.play_arrow),iconSize: size,),
        IconButton(
          onPressed: () {
            var newPostion= _controller.value.position + Duration(seconds: 10);
            _controller.seekTo(newPostion);
          }, icon: const  Icon(Icons.last_page),iconSize: size,),
      ],
    );
  }
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
  }
