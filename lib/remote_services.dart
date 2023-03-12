import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:rbb/model/tsr.dart';

import 'listen.dart';
//var headers = {
  //'Content-Type': 'application/json'
//};
//final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
//var request = http.Request('POST', Uri.parse('http://events.respark.iitm.ac.in:5000/rp_bank_api'));
var body = json.encode({
"action": "balance",
"nick_name": "irfan"
});
//request.headers.addAll(headers);

//http.StreamedResponse
//response = await request.send();
void send() async {
  var response = await http.post(
      Uri.parse("http://events.respark.iitm.ac.in:5000/rp_bank_api"),
      headers:  {"Content-type": "application/json"}
      , body: body);

  if (response.statusCode == 200) {
    print(response.body);
  }
  else {
    print(response.reasonPhrase);
  }
}





void stt() async{

var request = http.MultipartRequest('POST', Uri.parse('https://asr.iitm.ac.in/asr/v2/decode'));
Directory tempDir = await getTemporaryDirectory();
var tempPath = tempDir.path;
print('$tempPath/$pathToSaveAudio');

if (pathToSaveAudio.isNotEmpty) {
  request.files.add(await http.MultipartFile.fromPath('file','$tempPath/$pathToSaveAudio'));
}
http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
print(await response.stream.bytesToString());
}
else {
print(response.reasonPhrase);
}
}

class RemoteServices {
  Future<TextToSpeech?> fetchSpeech() async {
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST', Uri.parse('https://asr.iitm.ac.in/ttsv2/tts'));
    request.body = json.encode({
      "input": "text as good",
      "gender": "female",
      "lang": "english"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
     // print(await response.stream.bytesToString());
      var res=await response.stream.bytesToString();
      return TextToSpeech.fromJson(jsonDecode(res));

    }
    else {
      print(response.reasonPhrase);
    }

  }
}