import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/providers/game_event_provider.dart';
import 'traffic_status_bar.dart';
import 'traffic_board.dart';
import 'traffic_controller.dart';
import 'package:work_on_time_game/config/colors.dart';
import 'dice_overlay.dart';
import 'package:rive/rive.dart' as rive;

class TrafficScreen extends ConsumerStatefulWidget {
  const TrafficScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<TrafficScreen> createState() => _TrafficScreenState();
}

class _TrafficScreenState extends ConsumerState<TrafficScreen>
    with TickerProviderStateMixin {
  late TrafficController controller;
  late AnimationController _moveAnimationController;
  late Animation<double> _moveAnimation;
  int _startIndex = 0;
  int _targetIndex = 0;
  double _startBgOffset = 0.0;
  double _endBgOffset = 0.0;
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
        final currentOffset = _startBgOffset +
            (_endBgOffset - _startBgOffset) * _moveAnimation.value;
        _bgScrollController.jumpTo(currentOffset);
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
    if (_isMoving || _trafficBoard == null) return; // 防止重複觸發移動或盤面未初始化

    _isWalkingInput?.value = true;

    setState(() {
      _isMoving = true;
      _startIndex = controller.currentIndex;
      // 使用 _trafficBoard!.points.length 確保目標索引在正確範圍內
      _targetIndex = (controller.currentIndex + totalSteps)
          .clamp(0, _trafficBoard!.points.length - 1);

      _startBgOffset = _getBgOffsetForIndex(_startIndex);
      _endBgOffset = _getBgOffsetForIndex(_targetIndex);
    });

    final int actualSteps = (_targetIndex - _startIndex).abs();
    if (actualSteps == 0) {
      setState(() {
        _isMoving = false;
        _isWalkingInput?.value = false;
      });
      return;
    }

    // 計算動畫時間：每步 200ms
    final int duration = (actualSteps * 200).clamp(300, 3000);

    _moveAnimationController.duration = Duration(milliseconds: duration);

    // 使用 controller 的 future 等待動畫結束，這比 Future.delayed 更精準
    await _moveAnimationController.forward(from: 0.0).orCancel;

    // 動畫完成後，才更新最終狀態並停止走路
    setState(() {
      log('主動畫與背景已同步完成，停止走路');
      controller.currentIndex = _targetIndex;
      controller.steps = (controller.steps - 1).clamp(0, controller.maxSteps);
      _isMoving = false;
      _isWalkingInput?.value = false;
    });

    final type = _trafficBoard?.getPointType(controller.currentIndex);
    if (type != null) {
      _handlePointEvent(type);
    }
  }

  void _handlePointEvent(TrafficPointType type) {
    log('觸發事件: $type');

    switch (type) {
      case TrafficPointType.card:
        log('觸發卡片事件');
        ref.read(gameEventProvider.notifier).setEvent(GameEventType.rain);
        Navigator.of(context).pop();
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
    if (!showDiceOverlay && controller.steps > 0 && _trafficBoard != null) {
      setState(() {
        showDiceOverlay = true;
      });
    }
  }

  double _getBgOffsetForIndex(int index) {
    if (_trafficBoard == null || _trafficBoard!.points.length <= 1) return 0.0;

    final double bgImgWidth = 1965.0; // 你的 mrt_bg.png 寬度
    final double screenWidth = MediaQuery.of(context).size.width;
    // 使用盤面的總格數來計算每一步的距離，確保同步
    final int totalBoardPoints = _trafficBoard!.points.length;
    final double singleStep =
        (bgImgWidth - screenWidth) / (totalBoardPoints - 1);
    final double targetOffset = index * singleStep;

    return targetOffset.clamp(0.0, bgImgWidth - screenWidth);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          /// 背景地圖
          Positioned(
            top: 10,
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

          /// 狀態列
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

          /// 主角動畫（這裡放在 Stack 最外層，永遠以螢幕中央為基準）
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

          /// 格子地圖
          Positioned(
            top: screenHeight * 0.6 - 70,
            left: 0,
            right: 0,
            child: SizedBox(
              width: screenWidth > 430 ? 430 : screenWidth,
              child: Center(
                child: _trafficBoard != null
                    ? AnimatedBuilder(
                        animation: _moveAnimation,
                        builder: (context, child) {
                          final currentAnimatedIndex = _isMoving
                              ? (_startIndex +
                                      (_moveAnimation.value *
                                          (_targetIndex - _startIndex)))
                                  .round()
                                  .clamp(0, _trafficBoard!.points.length - 1)
                              : controller.currentIndex;
                          return TrafficBoard(
                            currentIndex: currentAnimatedIndex,
                            totalPoints: _trafficBoard!.points.length,
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

          /// 格子地圖上方骰子動畫（預設隱藏）
          if (showDiceOverlay)
            Positioned.fill(
              top: -150,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black.withAlpha(8),
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

          /// 骰子前進提示區塊（可點擊觸發骰子動畫）
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

          /// 提示區塊
          Positioned(
            top: screenHeight * 0.6 + 90,
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

          /// 最底部 logo
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
