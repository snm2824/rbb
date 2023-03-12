import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/public/flutter_sound_player.dart';
import 'package:rbb/model/tsr.dart';
import 'package:rbb/remote_services.dart';
import 'package:rbb/listen.dart';

import 'chat.dart';
import 'chat_bot.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
TextToSpeech? getValue;
late Uint8List decodedbytes;
class _MyHomePageState extends State<MyHomePage> {
  final player=AudioPlayer();
  bool isVisible= false;
@override
void initState(){
  super.initState();
  getData();

  player.init();
}
getData()async{
  getValue=await RemoteServices().fetchSpeech();
  if(getValue!=null){
    setState(() {
isVisible = true;
String me = getValue?.audio ?? "";
decodedbytes = base64.decode(me);
//print(getValue?.audio);
    });
  }
}
@override
void dispose(){
  player.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Visibility(
      visible:isVisible,
      child:Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(onPressed: (){
              send();}, child: const Text('RBAPi')),
          ElevatedButton(onPressed: (){Navigator.push(context,MaterialPageRoute(builder:(context) => Bot() ));}, child: const Text('Bot')),
            ElevatedButton(onPressed: (){Navigator.push(context,MaterialPageRoute(builder:(context) => const ListenPage()));}, child: const Text('Record')),
            ElevatedButton(onPressed: (){
             stt();}, child: const Text('stt')),
            ElevatedButton(onPressed: (){
              stt();}, child: const Text('stt')),
              //Text('${getValue?.audio}'),
            ElevatedButton.icon(
              onPressed: () async {
                await player._play();
              },
              label: const Text('y'),
              icon: const Icon(Icons.access_alarm),),
          ],
        ),
      ),
      )
    );
  }
}


class AudioPlayer{

  FlutterSoundPlayer? _audioPlayer;
  bool get isPlaying=>_audioPlayer!.isPlaying;

  Future init() async{
    _audioPlayer= FlutterSoundPlayer();

    await _audioPlayer!.openAudioSession();
    //_isRecorderInitialized=true;

  }
  void dispose(){
    _audioPlayer!.closeAudioSession();
    _audioPlayer=null;
    //_isRecorderInitialized=false;
  }


  Future _play () async{
    await _audioPlayer!.startPlayer(

        fromDataBuffer: decodedbytes,
    );
  }

}


