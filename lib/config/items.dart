import 'package:collection/collection.dart';
import 'package:flame/components.dart';

import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/models/item.dart';

final List<Item> items = [
  // 臥室物品
  // 紙球跟棉被另外獨立刻了
  Item(
    name: 'bag',
    imagePath: images.bag,
    imagePathLg: images.bagLg,
    title: '草綠色托特包',
    description: '成為社會新鮮人後，朋友送的禮物，\n容量很大可以裝很多東西。',
    position: Vector2(1030, 677),
    sceneName: 'bed_room',
  ),
  Item(
    name: 'books',
    imagePath: images.books,
    imagePathLg: images.bookLg,
    title: '書',
    description: '最近常看的書',
    position: Vector2(589, 691),
    sceneName: 'bed_room',
  ),
  Item(
    name: 'hair_iron',
    imagePath: images.hairIron,
    imagePathLg: images.hairIronLg,
    title: '離子夾',
    description: '要換個造型嗎？',
    position: Vector2(7, 659),
    sceneName: 'bed_room',
  ),
  Item(
    name: 'mirror',
    imagePath: images.mirror,
    imagePathLg: null,
    title: null,
    description: null,
    position: Vector2(29, 271),
    sceneName: 'bed_room',
  ),
  Item(
    name: 'painting',
    imagePath: images.painting,
    imagePathLg: null,
    title: null,
    description: null,
    position: Vector2(589, 150),
    sceneName: 'bed_room',
  ),
  Item(
    name: 'phone',
    imagePath: images.phone,
    imagePathLg: images.phoneLg,
    title: '手機',
    description: '',
    position: Vector2(703, 636),
    sceneName: 'bed_room',
  ),

  // 玄關物品
  Item(
    name: 'boots',
    imagePath: images.boots,
    imagePathLg: images.bootLg,
    title: '黑色長筒靴',
    description: '還蠻耐走的！很適合搭配可愛的 衣服穿去逛街。',
    position: Vector2(279, 461),
    sceneName: 'enter_way',
  ),
  Item(
    name: 'id_card',
    imagePath: images.idCard,
    imagePathLg: images.idCardLg,
    title: '公司識別證',
    description: '進公司大門和打卡的時候\n會用到，千萬不能忘記帶了！',
    position: Vector2(48, 373),
    sceneName: 'enter_way',
  ),
  Item(
    name: 'mary_janes',
    imagePath: images.maryJanes,
    imagePathLg: images.maryJanesLg,
    title: '棕色瑪莉珍鞋',
    description: '唯一的一雙比較正式的鞋子。',
    position: Vector2(318, 475),
    sceneName: 'enter_way',
  ),
  Item(
    name: 'shopping_list',
    imagePath: images.shoppingList,
    imagePathLg: images.shoppingListLg,
    title: '超市購物清單',
    description: '回家的時候再順便去買個菜吧！',
    position: Vector2(3, 379),
    sceneName: 'enter_way',
  ),
  Item(
    name: 'sneakers',
    imagePath: images.sneakers,
    imagePathLg: images.sneakerLg,
    title: '白色帆布鞋',
    description: '偶爾運動會穿出門，不過\n已經好久沒有出門運動了。',
    position: Vector2(280, 537),
    sceneName: 'enter_way',
  ),
  Item(
    name: 'umbrella',
    imagePath: images.umbrella,
    imagePathLg: images.umbrellaLg,
    title: '折傘',
    description: '今天會下雨嗎？',
    position: Vector2(263, 408),
    sceneName: 'enter_way',
  ),

  // 客廳物品
  Item(
    name: 'bill',
    imagePath: images.bill,
    imagePathLg: images.billLg,
    title: '信用卡帳單',
    description: '……繳費期限好像過了',
    position: Vector2(1001, 594),
    sceneName: 'living_room',
  ),
  Item(
    name: 'box',
    imagePath: images.box,
    imagePathLg: images.boxLg,
    title: '金屬吊飾',
    description: '看起來有些老舊的盒子，裡面\n放著一個寫著英文的金屬吊飾。',
    position: Vector2(67, 541),
    sceneName: 'living_room',
  ),
  Item(
    name: 'calendar',
    imagePath: images.calendar,
    imagePathLg: images.calendarLg,
    title: '月曆',
    description: '這個星期六…有什麼計劃嗎？',
    position: Vector2(704, 548),
    sceneName: 'living_room',
  ),
  Item(
    name: 'clock',
    imagePath: images.clock,
    imagePathLg: images.clockLg,
    title: '時鐘',
    description: '現在 9 點。必須在 9點半前出門',
    position: Vector2(161, 159),
    sceneName: 'living_room',
  ),
  Item(
    name: 'coat',
    imagePath: images.coat,
    imagePathLg: images.coatLg,
    title: '日系長大衣',
    description: '穿了好幾年所以有些舊舊的 ，但穿起來還是非常舒服。',
    position: Vector2(791, 283),
    sceneName: 'living_room',
    priority: 1,
  ),
  Item(
    name: 'picFrame',
    imagePath: images.picFrame,
    imagePathLg: images.phoneLg,
    title: '小時候的照片',
    description: '某一次全家旅行得時候，\n爸爸用相機拍的。',
    position: Vector2(797, 542),
    sceneName: 'living_room',
  ),
  Item(
    name: 'scarf',
    imagePath: images.scarf,
    imagePathLg: images.scarfLg,
    title: '大地色圍巾',
    description: '羊毛織的圍巾，適合天氣特 別冷的時候戴上它。',
    position: Vector2(964, 327),
    sceneName: 'living_room',
  ),
  Item(
    name: 'tv',
    imagePath: images.tv,
    imagePathLg: null,
    title: null,
    description: null,
    position: Vector2(356, 416),
    sceneName: 'living_room',
  ),
  Item(
    name: 'vase',
    imagePath: images.vase,
    imagePathLg: null,
    title: null,
    description: null,
    position: Vector2(0, 416),
    sceneName: 'living_room',
  ),
];

Item? getItem(String? name) {
  if (name == null) {
    return null;
  }
  final item = items.firstWhereOrNull((element) => element.name == name);
  return item;
}
