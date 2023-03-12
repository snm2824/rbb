class RB{

  String audio;
  String status;


  RB({
    required this.audio,
    required this.status,

  });

  factory RB.fromJson(Map<String, dynamic> json) {
    return RB(

      audio: json['audio'] as String,
      status: json['status'] as String,

    );

  }
}