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
  final String bag = 'bed_room/bag.png';
  final String blanketDo = 'bed_room/blanket_do.png';
  final String blanketUndo = 'bed_room/blanket_undo.png';
  final String books = 'bed_room/books.png';
  final String hairIron = 'bed_room/hair_iron.png';
  final String mirror = 'bed_room/mirror.png';
  final String painting = 'bed_room/painting.png';
  final String paperBall = 'bed_room/paper_ball.png';
  final String phone = 'bed_room/phone.png';

  final String enterWay = 'enter_way/bg.png';
  final String boots = 'enter_way/boots.png';
  final String doorClose = 'enter_way/door_close.png';
  final String doorOpen = 'enter_way/door_open.png';
  final String idCard = 'enter_way/id_card.png';
  final String maryJanes = 'enter_way/mary_janes.png';
  final String shoppingList = 'enter_way/shopping_list.png';
  final String sneakers = 'enter_way/sneakers.png';
  final String umbrella = 'enter_way/umbrella.png';

  final String loading = 'loading.png';

  String getFullPath(String image) {
    return 'assets/images/$image';
  }
}

final images = Images();
