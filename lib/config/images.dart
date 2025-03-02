class Images {
  static final Images _instance = Images._internal();
  factory Images() => _instance;
  Images._internal();

  final String livingRoomBackground = 'living_room/bg.png';
  final String vase = 'living_room/vase.png';

  final String bedRoomBackground = 'bed_room/bg.png';
  final String mirror = 'bed_room/mirror.png';
  final String paperBall = 'bed_room/paper_ball.png';
}

final images = Images();
