class Images {
  static final Images _instance = Images._internal();
  factory Images() => _instance;
  Images._internal();

  final String livingRoomBackground = 'living_room/bg.png';
  final String bill = 'living_room/bill.png';
  final String box = 'living_room/box.png';
  final String calendar = 'living_room/calendar.png';
  final String clock = 'living_room/clock.png';
  final String coat = 'living_room/coat.png';
  final String picFrame = 'living_room/pic_frame.png';
  final String scarf = 'living_room/scarf.png';
  final String tv = 'living_room/tv.png';
  final String vase = 'living_room/vase.png';

  final String bedRoomBackground = 'bed_room/bg.png';
  final String mirror = 'bed_room/mirror.png';
  final String paperBall = 'bed_room/paper_ball.png';
}

final images = Images();
