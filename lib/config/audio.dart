class Audio {
  static final Audio _instance = Audio._internal();
  factory Audio() => _instance;
  Audio._internal();

  final String rain = 'rain.mp3';
}

final audio = Audio();
