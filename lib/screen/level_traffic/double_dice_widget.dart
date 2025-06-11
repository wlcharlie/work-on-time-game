import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:work_on_time_game/config/images.dart';

class DoubleDiceWidget extends StatefulWidget {
  final void Function(int, int) onRollEnd;
  const DoubleDiceWidget({required this.onRollEnd, Key? key}) : super(key: key);

  @override
  State<DoubleDiceWidget> createState() => _DoubleDiceWidgetState();
}

class _DoubleDiceWidgetState extends State<DoubleDiceWidget> {
  int _frame = 1;
  bool _rolling = false;
  int? _left;
  int? _right;

  @override
  void initState() {
    super.initState();
    // 進入時自動啟動動畫
    WidgetsBinding.instance.addPostFrameCallback((_) => _startRoll());
  }

  void _startRoll() async {
    if (_rolling) return;
    setState(() {
      _rolling = true;
      _left = null;
      _right = null;
    });
    // 播放動畫（dice_1~dice_9）
    for (int i = 1; i <= 9; i++) {
      await Future.delayed(const Duration(milliseconds: 60));
      setState(() => _frame = i);
    }
    // 決定點數
    final rand = Random();
    final left = rand.nextInt(6) + 1;
    final right = rand.nextInt(6) + 1;
    setState(() {
      _left = left;
      _right = right;
      _rolling = false;
    });
    widget.onRollEnd(left, right);
  }

  @override
  Widget build(BuildContext context) {
    final diceSize = 64.0;
    return SizedBox(
      width: diceSize * 2.5,
      height: diceSize * 1.2,
      child: Center(
        child: _rolling
            ? Image.asset(
                images.getFullPath('traffic_scene/dice_$_frame.png'),
                width: diceSize * 2.1,
                fit: BoxFit.contain,
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _DiceFaceWidget(point: _left),
                  const SizedBox(width: 12),
                  _DiceFaceWidget(point: _right),
                ],
              ),
      ),
    );
  }
}

class _DiceFaceWidget extends StatelessWidget {
  final int? point;
  const _DiceFaceWidget({this.point});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          images.getFullPath(images.dice),
          width: 64,
          height: 64,
        ),
        if (point != null)
          CustomPaint(
            size: const Size(64, 64),
            painter: _DiceDotPainter(point!),
          ),
      ],
    );
  }
}

class _DiceDotPainter extends CustomPainter {
  final int point;
  _DiceDotPainter(this.point);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF8B7158);
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width / 6;
    // 點座標
    final dots = <Offset>[];
    switch (point) {
      case 1:
        dots.add(center);
        break;
      case 2:
        dots.add(Offset(r * 1.5, r * 1.5));
        dots.add(Offset(r * 4.5, r * 4.5));
        break;
      case 3:
        dots.add(center);
        dots.add(Offset(r * 1.5, r * 1.5));
        dots.add(Offset(r * 4.5, r * 4.5));
        break;
      case 4:
        dots.add(Offset(r * 1.5, r * 1.5));
        dots.add(Offset(r * 4.5, r * 1.5));
        dots.add(Offset(r * 1.5, r * 4.5));
        dots.add(Offset(r * 4.5, r * 4.5));
        break;
      case 5:
        dots.add(center);
        dots.add(Offset(r * 1.5, r * 1.5));
        dots.add(Offset(r * 4.5, r * 1.5));
        dots.add(Offset(r * 1.5, r * 4.5));
        dots.add(Offset(r * 4.5, r * 4.5));
        break;
      case 6:
        dots.add(Offset(r * 1.5, r * 1.5));
        dots.add(Offset(r * 4.5, r * 1.5));
        dots.add(Offset(r * 1.5, r * 3));
        dots.add(Offset(r * 4.5, r * 3));
        dots.add(Offset(r * 1.5, r * 4.5));
        dots.add(Offset(r * 4.5, r * 4.5));
        break;
    }
    for (final dot in dots) {
      canvas.drawCircle(dot, r * 0.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
