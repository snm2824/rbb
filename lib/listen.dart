import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';


const pathToSaveAudio ='audio_example.aac';


class ListenPage extends StatefulWidget {
  const ListenPage({Key? key}) : super(key: key);

  @override
  State<ListenPage> createState() => _ListenPageState();
}

class _ListenPageState extends State<ListenPage> {
final recorder= SoundRecorder();
final player=SoundPlayer();
//late Future<String> finalPath;

@override
void initState(){
  super.initState();
  recorder.init();
  player.init();


}
@override
void dispose(){

  recorder.dispose();
  player.dispose();
  super.dispose();
}
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Center(
          child:buildStart()
        )
    );


  }

Widget buildStart() {
  final isPlaying = player.isPlaying;
  var isRecording = recorder.isRecording;
  final icon = isRecording ? Icons.stop : Icons.play_arrow;
  final text = isPlaying ? 'Stop' : 'Start';
  return Center(
      child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () async {
               isRecording!=await recorder.toggleRecording();

                setState(() {

                });
              },
              label: const Text('Record'),
              icon: Icon(icon),),
            ElevatedButton.icon(
              onPressed: () async {
                await player.togglePlaying(whenFinished: () =>
                    setState(() {
                      setState(() {});
                    }));
              },
              label: Text(text),
              icon: Icon(icon),),
           // ElevatedButton(onPressed: (){
             // stt();}, child: const Text('stt')),
          ])
  );
}}

class SoundRecorder{
  FlutterSoundRecorder? _audioRecorder;
 bool _isRecorderInitialized=false;
 bool get isRecording=>_audioRecorder!.isRecording;
  Future init() async{
    _audioRecorder= FlutterSoundRecorder();
    final status = await Permission.microphone.request();
    if(status !=PermissionStatus.granted){
      throw RecordingPermissionException('Microphone permission denied');
    }
    await _audioRecorder!.openAudioSession();
    _isRecorderInitialized=true;
  }
  void dispose(){
    _audioRecorder!.closeAudioSession();
    _audioRecorder=null;
    _isRecorderInitialized=false;
  }
  Future _record() async{
    if(!_isRecorderInitialized) return;
    await _audioRecorder!.startRecorder(toFile: pathToSaveAudio);
  }
  Future _stop() async{
    if(!_isRecorderInitialized) return;
    await _audioRecorder!.stopRecorder();
  }
  Future toggleRecording() async{
    if(_audioRecorder!.isStopped){
      await _record();
    }
    else{
      await _stop();
    }
  }
}


class SoundPlayer{
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
  Future _play (VoidCallback whenFinished) async{
    await _audioPlayer!.startPlayer(

        fromURI: pathToSaveAudio,

        whenFinished: whenFinished

    );
  }
  Future _stop () async{
    await _audioPlayer!.stopPlayer();
  }
  Future togglePlaying({required VoidCallback whenFinished}) async{
    if(_audioPlayer!.isStopped){
      await _play(whenFinished);
    }
    else{
      await _stop();
    }
  }
}


