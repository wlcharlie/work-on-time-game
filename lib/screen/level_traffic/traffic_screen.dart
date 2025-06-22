import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:work_on_time_game/config/images.dart';
import 'traffic_status_bar.dart';
import 'traffic_board.dart';
import 'traffic_controller.dart';
import 'package:work_on_time_game/config/colors.dart';
import 'animated_dice.dart';
import 'double_dice_widget.dart';
import 'dice_overlay.dart';
import 'package:rive/rive.dart' as rive;

class TrafficScreen extends StatefulWidget {
  const TrafficScreen({Key? key}) : super(key: key);

  @override
  State<TrafficScreen> createState() => _TrafficScreenState();
}

class _TrafficScreenState extends State<TrafficScreen>
    with TickerProviderStateMixin {
  late TrafficController controller;
  late AnimationController _moveAnimationController;
  late Animation<double> _moveAnimation;
  int _startIndex = 0;
  int _targetIndex = 0;
  bool _isMoving = false;
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
  late ScrollController _bgScrollController;
  rive.StateMachineController? _stateMachineController;
  rive.SMIInput<bool>? _isWalkingInput;
  bool _hasPlayedEntry = false;

  @override
  void initState() {
    super.initState();
    controller = TrafficController(totalPoints: 100);
    _bgScrollController = ScrollController();

    _moveAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _moveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _moveAnimationController, curve: Curves.easeInOut),
    );

    _moveAnimation.addListener(() {
      if (_isMoving) {
        int currentAnimatedIndex = (_startIndex +
                (_moveAnimation.value * (_targetIndex - _startIndex)))
            .round()
            .clamp(0, (_trafficBoard?.points.length ?? 1) - 1);
        int steps = (_targetIndex - _startIndex).abs();
        _scrollBgToIndex(currentAnimatedIndex, steps: steps);
        setState(() {});
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _trafficBoard = TrafficBoard(
          currentIndex: controller.currentIndex,
          totalPoints: 60,
          iconSize: 36,
          maxWidth: MediaQuery.of(context).size.width > 430
              ? 430
              : MediaQuery.of(context).size.width,
        );
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isWalkingInput?.value = _isMoving;
    });
  }

  @override
  void dispose() {
    _moveAnimationController.dispose();
    _bgScrollController.dispose();
    super.dispose();
  }

  void _startSmoothMove(int totalSteps) async {
    _isWalkingInput?.value = true;

    setState(() {
      _isMoving = true;
      _startIndex = controller.currentIndex;
      _targetIndex = (controller.currentIndex + totalSteps)
          .clamp(0, controller.totalPoints - 1);
    });

    // 計算動畫時間：每步 200ms
    final int duration =
        ((_targetIndex - _startIndex).abs() * 200).clamp(300, 3000);

    _moveAnimationController.duration = Duration(milliseconds: duration);
    _moveAnimationController.reset();
    _moveAnimationController.forward();

    await Future.delayed(Duration(milliseconds: duration));

    setState(() {
      controller.currentIndex = _targetIndex;
      controller.steps = (controller.steps - 1).clamp(0, controller.maxSteps);
    });

    // 等背景滾動到位
    await _scrollBgToIndex(_targetIndex,
        steps: (_targetIndex - _startIndex).abs());

    setState(() {
      _isMoving = false;
      _isWalkingInput?.value = false;
    });

    final type = _trafficBoard?.getPointType(controller.currentIndex);
    _handlePointEvent(type);
  }

  void _handlePointEvent(TrafficPointType? type) {
    switch (type) {
      case TrafficPointType.card:
        // 雨天GOGO
        log('觸發卡片事件');
        break;
      case TrafficPointType.lucky:
        log('觸發幸運事件');
        break;
      case TrafficPointType.coffee:
        log('觸發咖啡事件');
        break;
      case TrafficPointType.question:
        log('觸發問題事件');
        break;
      case TrafficPointType.home:
        log('觸發回家事件');
        break;
      default:
        log('觸發一般事件');
        break;
    }
  }

  void _triggerDice() {
    if (!showDiceOverlay && controller.steps > 0) {
      setState(() {
        showDiceOverlay = true;
      });
    }
  }

  Future<void> _scrollBgToIndex(int index, {int steps = 1}) {
    final double bgImgWidth = 1965.0; // 你的 mrt_bg.png 寬度
    final double screenWidth = MediaQuery.of(context).size.width;
    final double singleStep = (bgImgWidth - screenWidth) / (20 - 1);
    final double targetOffset = index * singleStep;

    final int duration = (steps * 150).clamp(300, 1500);

    return _bgScrollController.animateTo(
      targetOffset.clamp(0.0, bgImgWidth - screenWidth),
      duration: Duration(milliseconds: duration),
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    int currentAnimatedIndex = _isMoving
        ? (_startIndex + (_moveAnimation.value * (_targetIndex - _startIndex)))
            .round()
            .clamp(0, (_trafficBoard?.points.length ?? 1) - 1)
        : controller.currentIndex;

    // 計算背景偏移量
    double bgWidth = 393.0 * 5; // 5張圖，每張393px
    double singleStep = (bgWidth - screenWidth) / (20 - 1); // 20格
    double bgOffset = -currentAnimatedIndex * singleStep;

    // 假設 screenWidth, screenHeight, bgOffset 都已經有
    // 5 張圖，每張 393px
    final int bgCount = 5;
    final double bgImgWidth = 393.0;
    final double bgTotalWidth = bgImgWidth * bgCount;

    return Scaffold(
      body: Stack(
        children: [
          // 背景地圖
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              width: screenWidth,
              height: screenHeight * 0.6,
              child: SingleChildScrollView(
                controller: _bgScrollController,
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                child: Image.asset(
                  'assets/images/traffic_scene/mrt_bg.png',
                  width: 1965,
                  height: screenHeight * 0.6,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // 狀態列
          Positioned(
            top: 0,
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
          // 主角動畫（這裡放在 Stack 最外層，永遠以螢幕中央為基準）
          if (_trafficBoard != null)
            Positioned(
              // 直接用螢幕中央，不要跟背景寬度綁定
              top: screenHeight * 0.6 - 300,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Center(
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: rive.RiveAnimation.asset(
                      'assets/rive/walk.riv',
                      key: const ValueKey('main-character-rive'),
                      fit: BoxFit.contain,
                      stateMachines: const ['walkState'],
                      onInit: (artboard) {
                        _stateMachineController =
                            rive.StateMachineController.fromArtboard(
                          artboard,
                          'walkState',
                        );
                        if (_stateMachineController != null) {
                          artboard.addController(_stateMachineController!);
                          _isWalkingInput =
                              _stateMachineController!.findInput('isWalking');
                          _isWalkingInput?.value = _isMoving;
                        }
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ),
            ),
          // 格子地圖
          Positioned(
            top: screenHeight * 0.6 - 80,
            left: 0,
            right: 0,
            child: SizedBox(
              width: screenWidth > 430 ? 430 : screenWidth,
              child: Center(
                child: _trafficBoard != null
                    ? AnimatedBuilder(
                        animation: _moveAnimation,
                        builder: (context, child) {
                          return TrafficBoard(
                            currentIndex: currentAnimatedIndex,
                            totalPoints: 20,
                            iconSize: 36,
                            maxWidth: screenWidth > 430 ? 430 : screenWidth,
                            points: _trafficBoard!.points,
                          );
                        },
                      )
                    : const SizedBox(), // 載入中顯示空白
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
                      showDiceOverlay = false;
                    });
                    _startSmoothMove(total);
                  },
                ),
              ),
            ),
          // 骰子前進提示區塊（可點擊觸發骰子動畫）
          Positioned(
            top: screenHeight * 0.6 + 30,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _triggerDice,
                child: Container(
                  width: screenWidth > 430 ? 430 : screenWidth,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  margin: const EdgeInsets.only(left: 20, right: 20),
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
            top: screenHeight * 0.6 + 100,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: screenWidth > 430 ? 430 : screenWidth,
                padding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                margin: const EdgeInsets.only(left: 20, right: 20),
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
