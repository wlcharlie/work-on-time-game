class Images {
  static final Images _instance = Images._internal();
  factory Images() => _instance;
  Images._internal();

  final String loading = 'loading.png';
  final String lobbyBackground = 'home_bg.png';

  final String statusMindIcon = 'status/mind.png';
  final String statusSavingIcon = 'status/saving.png';
  final String statusEnergyIcon = 'status/energy.png';

  final String tabbarBookIcon = 'tabbar_icon_book.png';
  final String tabbar2Icon = 'tabbar_icon_2.png';
  final String tabbarHomeIcon = 'tabbar_icon_home.png';
  final String tabbarMenuIcon = 'tabbar_icon_menu.png';
  final String tabbarSettingsIcon = 'tabbar_icon_settings.png';

  final String character = 'character.png';

  // 房間找東西關卡
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
  // 房間找東西關卡
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
  // 房間找東西關卡
  final String enterWay = 'enter_way/bg.png';
  final String boots = 'enter_way/boots.png';
  final String doorClose = 'enter_way/door_close.png';
  final String doorOpen = 'enter_way/door_open.png';
  final String idCard = 'enter_way/id_card.png';
  final String maryJanes = 'enter_way/mary_janes.png';
  final String shoppingList = 'enter_way/shopping_list.png';
  final String sneakers = 'enter_way/sneakers.png';
  final String umbrella = 'enter_way/umbrella.png';

  // 房間找東西關卡 對話大窗窗
  final String itemDialogBg = 'item/dialog_bg.png';
  final String bagLg = 'item/bag.png';
  final String billLg = 'item/bill.png';
  final String bookLg = 'item/book.png';
  final String bootLg = 'item/boot.png';
  final String boxLg = 'item/box.png';
  final String calendarLg = 'item/calendar.png';
  final String clockLg = 'item/clock.png';
  final String coatLg = 'item/coat.png';
  final String hairIronLg = 'item/hair_iron.png';
  final String idCardLg = 'item/id_card.png';
  final String maryJanesLg = 'item/mary_janes.png';
  final String phoneLg = 'item/phone.png';
  final String photoClear = 'item/photo_clear.png';
  final String photoUnclear = 'item/photo_unclear.png';
  final String photo = 'item/photo.png';
  final String scarfLg = 'item/scarf.png';
  final String shoppingListLg = 'item/shopping_list.png';
  final String sneakerLg = 'item/sneakers.png';
  final String umbrellaLg = 'item/umbrella.png';
  final String greenDotBackground = 'bg_green_dot.png';

  final String weatherForecastHost = 'tv/host.png';
  final String weatherForecastSunny = 'tv/weather_sunny.png';
  final String weatherForecastRain = 'tv/weather_rain.png';
  final String weatherForecastCloudy = 'tv/weather_cloudy.png';

  // rain-scene
  final String rainSceneBackground = 'rain_scene/bg_city.png';
  final String rainSceneEventLeft = 'rain_scene/event_left.png';
  final String rainSceneEventRight = 'rain_scene/event_right.png';
  final String rainSceneCharacter = 'rain_scene/rain_character.png';
  final String rainSceneRainDrop01 = 'rain_scene/rain_drop_01.png';
  final String rainSceneRainDrop02 = 'rain_scene/rain_drop_02.png';
  final String rainSceneRainDrop03 = 'rain_scene/rain_drop_03.png';
  final String rainSceneRainDrop04 = 'rain_scene/rain_drop_04.png';
  final String rainSceneResultWithUmbrella =
      'rain_scene/rain_result_with_umbrella.png';
  final String rainSceneResultWithoutUmbrella =
      'rain_scene/rain_result_without_umbrella.png';

  String getFullPath(String image) {
    return 'assets/images/$image';
  }

  List<String> allHomeLevelImages() {
    return [
      character,
      livingRoomBackground,
      bill,
      box,
      calendar,
      clock,
      coat,
      picFrame,
      scarf,
      tv,
      vase,
      bedRoomBackground,
      bag,
      blanketDo,
      blanketUndo,
      books,
      hairIron,
      mirror,
      painting,
      paperBall,
      phone,
      enterWay,
      boots,
      doorClose,
      doorOpen,
      idCard,
      maryJanes,
      shoppingList,
      sneakers,
      umbrella,
      loading,
      itemDialogBg,
      bagLg,
      billLg,
      bookLg,
      bootLg,
      boxLg,
      calendarLg,
      clockLg,
      coatLg,
      hairIronLg,
      idCardLg,
      maryJanesLg,
      phoneLg,
      photoClear,
      photoUnclear,
      photo,
      scarfLg,
      shoppingListLg,
      sneakerLg,
      umbrellaLg,
      greenDotBackground,
      weatherForecastHost,
      weatherForecastSunny,
      weatherForecastRain,
      weatherForecastCloudy,
    ];
  }
}

final images = Images();
