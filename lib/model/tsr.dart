class TextToSpeech{

  String audio;
  String status;


  TextToSpeech({
    required this.audio,
    required this.status,

  });

  factory TextToSpeech.fromJson(Map<String, dynamic> json) {
    return TextToSpeech(

      audio: json['audio'] as String,
      status: json['status'] as String,

    );

  }
}