import 'package:flutter/material.dart';
import 'package:work_on_time_game/config/images.dart';
import 'traffic_status_bar.dart';
import 'traffic_board.dart';
import 'traffic_controller.dart';
import 'package:work_on_time_game/config/colors.dart';
import 'animated_dice.dart';
import 'double_dice_widget.dart';
import 'dice_overlay.dart';

class TrafficScreen extends StatefulWidget {
  const TrafficScreen({Key? key}) : super(key: key);

  @override
  State<TrafficScreen> createState() => _TrafficScreenState();
}

class _TrafficScreenState extends State<TrafficScreen> {
  late TrafficController controller;
  final List<String> pointIcons = [
    images.trafficPointCardLucky,
    images.trafficPointCard,
    images.trafficPointCardCoffee,
    images.trafficPointCardQuestion,
    images.trafficPointCardHome,
    images.trafficPointCardPark,
    images.trafficPointCard,
  ];
  bool showDice = false;
  bool showDiceOverlay = false;
  TrafficBoard? _trafficBoard;

  @override
  void initState() {
    super.initState();
    controller = TrafficController(totalPoints: pointIcons.length);
  }

  void _triggerDice() {
    if (!showDiceOverlay && controller.steps > 0) {
      setState(() {
        showDiceOverlay = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          // 背景
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              width: screenWidth > 430 ? 430 : screenWidth,
              height: screenHeight * 0.6,
              child: Center(
                child: Image.asset(
                  images.getFullPath(images.trafficMRTSceneBackground),
                  width: screenWidth > 430 ? 430 : screenWidth,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          // 狀態列
          Positioned(
            top: 32,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Center(
                child: SizedBox(
                  width: screenWidth > 430 ? 430 : screenWidth,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: TrafficStatusBar(
                      steps: controller.steps,
                      maxSteps: controller.maxSteps,
                      heart: controller.heart,
                      money: controller.money,
                      energy: controller.energy,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // 格子地圖上方人物
          Positioned(
            top: screenHeight * 0.6 - 300,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                images.getFullPath(images.walk),
                width: 200,
                fit: BoxFit.contain,
              ),
            ),
          ),
          // 格子地圖
          Positioned(
            top: screenHeight * 0.6 - 90,
            left: 0,
            right: 0,
            child: SizedBox(
              width: screenWidth > 430 ? 430 : screenWidth,
              child: Center(
                child: Builder(
                  builder: (context) {
                    _trafficBoard = TrafficBoard(
                      currentIndex: controller.currentIndex,
                      totalPoints: 20,
                      iconSize: 36,
                      maxWidth: screenWidth > 430 ? 430 : screenWidth,
                    );
                    return _trafficBoard!;
                  },
                ),
              ),
            ),
          ),
          // 格子地圖上方骰子動畫（預設隱藏）
          if (showDiceOverlay)
            Positioned.fill(
              top: -150,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black.withOpacity(0.08),
                child: DiceOverlay(
                  onFinish: (total) {
                    setState(() {
                      controller.currentIndex =
                          (controller.currentIndex + total)
                              .clamp(0, controller.totalPoints - 1);
                      controller.steps =
                          (controller.steps - 1).clamp(0, controller.maxSteps);
                      showDiceOverlay = false;
                    });
                    final type =
                        _trafficBoard?.getPointType(controller.currentIndex);
                    // 這邊我先測試用，如果移動到 card 時切換雨天場景
                    if (type == TrafficPointType.card) {
                      // 雨天GOGO
                    }
                  },
                ),
              ),
            ),
          // 骰子前進提示區塊（可點擊觸發骰子動畫）
          Positioned(
            top: screenHeight * 0.6 + 10,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _triggerDice,
                child: Container(
                  width: screenWidth > 430 ? 430 : screenWidth,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: TrafficColors.tipBg.withOpacity(0.97),
                    borderRadius: BorderRadius.circular(8),
                    border:
                        Border.all(color: TrafficColors.tipBorder, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '骰子前進',
                        style: TextStyle(
                          fontSize: 17,
                          color: TrafficColors.tipText,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.casino,
                          color: TrafficColors.tipIcon, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // 提示區塊
          Positioned(
            top: screenHeight * 0.6 + 80,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: screenWidth > 430 ? 430 : screenWidth,
                padding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                decoration: BoxDecoration(
                  color: TrafficColors.tipBg.withOpacity(0.97),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: TrafficColors.tipBorder, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '骰子前進',
                      style: TextStyle(
                        fontSize: 17,
                        color: TrafficColors.tipText,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '還有${controller.steps}次前進機會，出發吧！',
                      style: TextStyle(
                        fontSize: 15,
                        color: TrafficColors.tipText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.casino,
                            color: TrafficColors.tipIcon, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          '點擊上方骰子前進',
                          style: TextStyle(
                            fontSize: 14,
                            color: TrafficColors.tipText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 最底部 logo
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: TrafficColors.bottomBar,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Image.asset(
                  images.getFullPath(images.logo),
                  width: 120,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
