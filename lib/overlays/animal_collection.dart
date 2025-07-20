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

  final List<AnimalData> animals = [
    AnimalData(id: "001", name: "Hamster", icon: "🐹", collected: 0, total: 2),
    AnimalData(id: "002", name: "Pikachu", icon: "⚡", collected: 0, total: 2),
    AnimalData(id: "003", name: "Bear", icon: "🐻", collected: 0, total: 2),
    AnimalData(id: "004", name: "Elephant", icon: "🐘", collected: 0, total: 2),
    AnimalData(
        id: "001", name: "Squirrel", icon: "🐿️", collected: 0, total: 2),
    AnimalData(id: "001", name: "Penguin", icon: "🐧", collected: 0, total: 2),
    AnimalData(id: "001", name: "Cat", icon: "🐱", collected: 0, total: 2),
    AnimalData(
        id: "001", name: "Elephant2", icon: "🐘", collected: 0, total: 2),
    AnimalData(id: "001", name: "Giraffe", icon: "🦒", collected: 0, total: 2),
    AnimalData(id: "001", name: "Chick", icon: "🐥", collected: 0, total: 2),
    AnimalData(id: "001", name: "Hamster2", icon: "🐹", collected: 0, total: 2),
    AnimalData(id: "001", name: "Hippo", icon: "🦛", collected: 0, total: 2),
    AnimalData(id: "001", name: "Pig", icon: "🐷", collected: 0, total: 2),
    AnimalData(id: "001", name: "Rabbit", icon: "🐰", collected: 0, total: 2),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeaderWithTabs(),
            _buildTitle(),
            const SizedBox(height: 1),
            Expanded(
              child: _buildAnimalGrid(),
            ),
          ],
        ),
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
      padding: const EdgeInsets.all(13),
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

  Widget _buildAnimalCard(AnimalData animal) {
    return Container(
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
              child: Text(
                animal.icon,
                style: typography.tp36,
                textAlign: TextAlign.center,
              ),
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
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      height: 87 + MediaQuery.of(context).padding.bottom,
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
              widget.game.overlays.remove('animalCollection');
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
            height: 36,
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
  final String icon;
  final int collected;
  final int total;

  AnimalData({
    required this.id,
    required this.name,
    required this.icon,
    required this.collected,
    required this.total,
  });
}
