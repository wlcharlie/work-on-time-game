import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_on_time_game/wot_game.dart';
import 'package:work_on_time_game/config/colors.dart';
import 'package:work_on_time_game/config/typography.dart';
import 'package:work_on_time_game/config/images.dart';

class AnimalCollectionOverlay extends ConsumerStatefulWidget {
  const AnimalCollectionOverlay({super.key, required this.game});

  final WOTGame game;

  @override
  ConsumerState<AnimalCollectionOverlay> createState() =>
      _AnimalCollectionOverlayState();
}

class _AnimalCollectionOverlayState
    extends ConsumerState<AnimalCollectionOverlay> {
  int selectedTab = 0;
  bool isDetailView = false;
  String? selectedAnimalId;

  final List<AnimalData> animals = [
    AnimalData(
        id: "001",
        name: "Bear",
        headImagePath: images.bearHead,
        fullImagePath: images.bearFull,
        collected: 1,
        total: 2,
        seen: true),
    AnimalData(
        id: "002",
        name: "Capybara",
        headImagePath: images.capybaraHead,
        fullImagePath: images.capybaraFull,
        collected: 0,
        total: 2,
        seen: true),
    AnimalData(
        id: "003",
        name: "Collie",
        headImagePath: images.collieHead,
        fullImagePath: images.collieFull,
        collected: 0,
        total: 2,
        seen: false),
    AnimalData(
        id: "004",
        name: "Deer",
        headImagePath: images.deerHead,
        fullImagePath: images.deerFull,
        collected: 2,
        total: 2,
        seen: true),
    AnimalData(
        id: "005",
        name: "Elephant",
        headImagePath: images.elephantHead,
        fullImagePath: images.elephantFull,
        collected: 0,
        total: 2,
        seen: true),
    AnimalData(
        id: "006",
        name: "Giraffe",
        headImagePath: images.giraffeHead,
        fullImagePath: images.giraffeFull,
        collected: 0,
        total: 2,
        seen: false),
    AnimalData(
        id: "007",
        name: "Golden",
        headImagePath: images.goldenHead,
        fullImagePath: images.goldenFull,
        collected: 1,
        total: 2,
        seen: true),
    AnimalData(
        id: "008",
        name: "Hamster",
        headImagePath: images.hamustaHead,
        fullImagePath: images.hamustaFull,
        collected: 0,
        total: 2,
        seen: false),
    AnimalData(
        id: "009",
        name: "Hippo",
        headImagePath: images.hippoHead,
        fullImagePath: images.hippoFull,
        collected: 0,
        total: 2,
        seen: true),
    AnimalData(
        id: "010",
        name: "企鵝走走",
        headImagePath: images.penguinHead,
        fullImagePath: images.penguinFull,
        collected: 1,
        total: 2,
        seen: true),
    AnimalData(
        id: "011",
        name: "Pig",
        headImagePath: images.pigHead,
        fullImagePath: images.pigFull,
        collected: 1,
        total: 2,
        seen: true),
    AnimalData(
        id: "012",
        name: "Rabbit",
        headImagePath: images.rabbitHead,
        fullImagePath: images.rabbitFull,
        collected: 0,
        total: 2,
        seen: false),
    // 未知動物
    AnimalData(
        id: "013",
        name: "???",
        headImagePath: images.notFoundHead,
        fullImagePath: images.notFoundFull,
        collected: 0,
        total: 2,
        seen: false),
    AnimalData(
        id: "014",
        name: "???",
        headImagePath: images.notFoundHead,
        fullImagePath: images.notFoundFull,
        collected: 0,
        total: 2,
        seen: false),
    AnimalData(
        id: "015",
        name: "???",
        headImagePath: images.notFoundHead,
        fullImagePath: images.notFoundFull,
        collected: 0,
        total: 2,
        seen: false),
    AnimalData(
        id: "016",
        name: "???",
        headImagePath: images.notFoundHead,
        fullImagePath: images.notFoundFull,
        collected: 0,
        total: 2,
        seen: false),
    AnimalData(
        id: "017",
        name: "???",
        headImagePath: images.notFoundHead,
        fullImagePath: images.notFoundFull,
        collected: 0,
        total: 2,
        seen: false),
    AnimalData(
        id: "018",
        name: "???",
        headImagePath: images.notFoundHead,
        fullImagePath: images.notFoundFull,
        collected: 0,
        total: 2,
        seen: false),
    AnimalData(
        id: "019",
        name: "???",
        headImagePath: images.notFoundHead,
        fullImagePath: images.notFoundFull,
        collected: 0,
        total: 2,
        seen: false),
    AnimalData(
        id: "020",
        name: "???",
        headImagePath: images.notFoundHead,
        fullImagePath: images.notFoundFull,
        collected: 0,
        total: 2,
        seen: false),
    AnimalData(
        id: "021",
        name: "???",
        headImagePath: images.notFoundHead,
        fullImagePath: images.notFoundFull,
        collected: 0,
        total: 2,
        seen: false),
    AnimalData(
        id: "022",
        name: "???",
        headImagePath: images.notFoundHead,
        fullImagePath: images.notFoundFull,
        collected: 0,
        total: 2,
        seen: false),
    AnimalData(
        id: "023",
        name: "???",
        headImagePath: images.notFoundHead,
        fullImagePath: images.notFoundFull,
        collected: 0,
        total: 2,
        seen: false),
    AnimalData(
        id: "024",
        name: "???",
        headImagePath: images.notFoundHead,
        fullImagePath: images.notFoundFull,
        collected: 0,
        total: 2,
        seen: false),
  ];

  AnimalData? _getSelectedAnimal() {
    if (selectedAnimalId == null) return null;
    try {
      return animals.firstWhere((animal) => animal.id == selectedAnimalId);
    } catch (e) {
      return null;
    }
  }

  String _getAnimalStatusText(AnimalData animal) {
    if (animal.collected > 0) {
      return animal.collected == animal.total ? '已完全收集！' : '已收集，還可以收集更多';
    } else if (animal.seen) {
      return '曾經見過，但還沒有收集到';
    } else {
      return '尚未發現';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isDetailView ? _buildAnimalDetailView() : _buildAnimalGridView(),
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildHeaderWithTabs() {
    return Container(
      height: 78.5,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '收藏與圖鑑',
            style: typography.tp24.m.withColor(const Color(0xFF3B3B3B)),
          ),
          _buildButtonGroup(),
        ],
      ),
    );
  }

  Widget _buildButtonGroup() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(23),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildGroupButton('小日獸', 0, isFirst: true),
          Container(
            width: 1,
            color: AppColors.white,
          ),
          _buildGroupButton('事件', 1, isLast: true),
        ],
      ),
    );
  }

  Widget _buildGroupButton(String title, int index,
      {bool isFirst = false, bool isLast = false}) {
    final isSelected = selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = index;
        });
      },
      child: Container(
        width: 88,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brown500 : AppColors.pale400,
          borderRadius: BorderRadius.only(
            topLeft: isFirst ? const Radius.elliptical(11.5, 11) : Radius.zero,
            bottomLeft:
                isFirst ? const Radius.elliptical(11.5, 11) : Radius.zero,
            topRight: isLast ? const Radius.elliptical(11.5, 11) : Radius.zero,
            bottomRight:
                isLast ? const Radius.elliptical(11.5, 11) : Radius.zero,
          ),
        ),
        child: Text(
          title,
          style: typography.tp16m.withColor(
            isSelected ? Colors.white : AppColors.pale500,
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      width: double.infinity,
      color: AppColors.pale400,
      padding: const EdgeInsets.symmetric(vertical: 21),
      child: Column(
        children: [
          Text(
            '小日獸圖鑑',
            style: typography.tp20.m.withColor(AppColors.textColor500),
          ),
          const SizedBox(height: 12),
          Text(
            '可以查看相遇到的小日獸',
            style: typography.tp16.m.withColor(AppColors.textColor500),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimalGrid() {
    return Container(
      color: AppColors.white2,
      padding: const EdgeInsets.fromLTRB(13, 13, 13, 0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 90 / 152.5,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
        ),
        itemCount: animals.length,
        itemBuilder: (context, index) {
          return _buildAnimalCard(animals[index]);
        },
      ),
    );
  }

  Widget _buildAnimalGridView() {
    return Column(
      children: [
        _buildHeaderWithTabs(),
        _buildTitle(),
        Expanded(
          child: _buildAnimalGrid(),
        ),
      ],
    );
  }

  Widget _buildAnimalDetailView() {
    final selectedAnimal = _getSelectedAnimal();
    if (selectedAnimal == null) return const SizedBox();

    final isSeen = selectedAnimal.seen || selectedAnimal.collected > 0;

    return Container(
      color: AppColors.white2,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 89.5,
            color: AppColors.white,
          ),

          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                height: 79,
                color: AppColors.pale400,
                padding: const EdgeInsets.only(bottom: 21.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      isSeen ? selectedAnimal.name : '???',
                      style:
                          typography.tp18.m.withColor(AppColors.textColor500),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -55,
                left: 0,
                right: 0,
                child: SizedBox(
                  width: 75,
                  height: 75,
                  child: _buildAnimalImage(selectedAnimal),
                ),
              ),
            ],
          ),

          // 動物圖片區域

          const SizedBox(height: 24),

          // 根據 seen 狀態決定顯示內容
          isSeen
              ? _buildPolaroidView(selectedAnimal)
              : _buildUnseenMessageView(),
          const SizedBox(height: 15),
          if (isSeen)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Color(0xFF8B7158),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD9D9D9),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD9D9D9),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            )
          // indicator to scroll
        ],
      ),
    );
  }

  Widget _buildPolaroidView(AnimalData selectedAnimal) {
    return Container(
      width: 333,
      height: 449.5,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          SizedBox(height: 15.5),
          Stack(
            children: [
              Container(
                width: 306.5,
                height: 334.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: AppColors.modalContentColor,
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                right: 0,
                bottom: 0,
                child: Image.asset(
                  images.getFullPath(selectedAnimal.fullImagePath),
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          SizedBox(height: 35 / 2),
          Text(
            selectedAnimal.name,
            style: typography.tp24.m.withColor(AppColors.brown500),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                images.getFullPath(images.starFit),
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 8),
              Image.asset(
                images.getFullPath(images.starFit),
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 8),
              Image.asset(
                images.getFullPath(images.starFit),
                width: 24,
                height: 24,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUnseenMessageView() {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child: Text(
          '有遇見他，似乎來不及拍照',
          style: typography.tp18.m.withColor(AppColors.textColor400),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildAnimalCard(AnimalData animal) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAnimalId = animal.id;
          isDetailView = true;
        });
      },
      child: Container(
        width: 90,
        height: 152.5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('no.',
                    style: typography.tp12.m.withColor(AppColors.textColor500)),
                Text(
                  animal.id,
                  style: typography.tp18.m.withColor(AppColors.textColor500),
                ),
              ],
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8),
                child: _buildAnimalImage(animal),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: const Icon(
                      Icons.camera_alt,
                      size: 18,
                      color: AppColors.brown400,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    '${animal.collected}/${animal.total}',
                    style: typography.tp16.m.withColor(AppColors.textColor500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ), // 關閉 GestureDetector
    );
  }

  Widget _buildAnimalImage(AnimalData animal) {
    // 根據收集狀態決定顯示效果
    if (animal.collected > 0 || animal.name == '???') {
      // 已收集：正常顯示
      return Image.asset(
        images.getFullPath(animal.headImagePath),
        fit: BoxFit.contain,
      );
    } else if (animal.seen) {
      // 看過但未收集：覆蓋半透明棕色
      return ColorFiltered(
        colorFilter: const ColorFilter.mode(
          Color.fromRGBO(139, 113, 88, 0.5), // 50% opacity 的棕色
          BlendMode.srcATop,
        ),
        child: Opacity(
          opacity: 0.3,
          child: Image.asset(
            images.getFullPath(animal.headImagePath),
            fit: BoxFit.contain,
          ),
        ),
      );
    } else {
      // 從未見過：顯示剪影
      return ColorFiltered(
        colorFilter: const ColorFilter.mode(
          Color(0xFF8B7158),
          BlendMode.srcIn,
        ),
        child: Image.asset(
          images.getFullPath(animal.headImagePath),
          fit: BoxFit.contain,
        ),
      );
    }
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      height: 75 + MediaQuery.of(context).padding.bottom,
      padding: EdgeInsets.fromLTRB(
          12, 12, 12, MediaQuery.of(context).padding.bottom),
      decoration: const BoxDecoration(
        color: AppColors.brown500,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              if (isDetailView) {
                setState(() {
                  isDetailView = false;
                  selectedAnimalId = null;
                });
              } else {
                widget.game.overlays.remove('animalCollection');
              }
            },
            child: ClipPath(
              clipper: BackButtonClipper(),
              child: Container(
                width: 83,
                height: 38,
                padding: const EdgeInsets.only(left: 8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                alignment: Alignment.center,
                child: Text(
                  '返回',
                  style: typography.tp16.sb.withColor(AppColors.textColor500),
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 24,
            child: Image.asset(
              images.getFullPath(images.logo),
              width: 97.22,
              height: 28,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

class BackButtonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // 左中 三角形尖點偏上的位置
    // path.moveTo(0, size.height / 2);
    path.moveTo(2, size.height / 2 - 3.5);

    // 往右上走（左上點）
    path.lineTo(9.5, 2);
    // 左上圓弧
    path.quadraticBezierTo(10.5, 0, 12.5, 0);

    // 左上圓弧接直線到右底（右上點）
    path.lineTo(size.width - 8, 0);
    // 右上圓弧
    path.quadraticBezierTo(size.width, 0, size.width, 8);

    // 右上圓弧接直線到左底（左下點）
    path.lineTo(size.width, size.height - 8);
    // 左下圓弧
    path.quadraticBezierTo(
        size.width, size.height, size.width - 8, size.height);

    // 左下圓弧直線到左下（左下點）
    path.lineTo(12.5, size.height);
    // 左下圓弧接直線到左中（左中點）
    path.quadraticBezierTo(10.5, size.height, 9.5, size.height - 2);

    // 回到左中
    path.lineTo(2, size.height / 2 + 3.5);
    path.quadraticBezierTo(0, size.height / 2, 2, size.height / 2 - 3.5);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class AnimalData {
  final String id;
  final String name;
  final String headImagePath;
  final String fullImagePath;
  final int collected;
  final int total;
  final bool seen;

  AnimalData({
    required this.id,
    required this.name,
    required this.headImagePath,
    required this.fullImagePath,
    required this.collected,
    required this.total,
    this.seen = false,
  });
}
