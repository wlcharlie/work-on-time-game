import 'dart:async';
import 'package:flutter/material.dart';
import 'package:work_on_time_game/config/images.dart';
import 'double_dice_widget.dart';
import 'package:work_on_time_game/config/colors.dart';

class DiceOverlay extends StatefulWidget {
  final void Function(int total) onFinish;
  const DiceOverlay({required this.onFinish, Key? key}) : super(key: key);

  @override
  State<DiceOverlay> createState() => _DiceOverlayState();
}

class _DiceOverlayState extends State<DiceOverlay> {
  int? _total;
  bool _showMove = false;
  int? _left;
  int? _right;

  void _onRollEnd(int left, int right) async {
    setState(() {
      _left = left;
      _right = right;
      _total = left + right;
      _showMove = false;
    });
    await Future.delayed(const Duration(milliseconds: 2000));
    setState(() {
      _showMove = true;
    });
    await Future.delayed(const Duration(milliseconds: 1000));
    widget.onFinish(_total!);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final width = screenWidth > 430 ? 430.0 : screenWidth.toDouble();
    final height = 120.0;
    return Center(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: const Color(0xFFAE866B), width: 2),
            bottom: BorderSide(color: const Color(0xFFAE866B), width: 2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: CustomPaint(
          painter: _DiceBgPainter(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (_total == null) DoubleDiceWidget(onRollEnd: _onRollEnd),
              if (_total != null && !_showMove)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _DiceFaceWidget(point: _left),
                    const SizedBox(width: 12),
                    _DiceFaceWidget(point: _right),
                  ],
                ),
              if (_total != null && _showMove)
                AnimatedOpacity(
                  opacity: _showMove ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    width: width,
                    height: height,
                    alignment: Alignment.center,
                    color: Colors.white.withOpacity(0.92),
                    child: Text(
                      '移動$_total格!',
                      style: const TextStyle(
                        fontSize: 28,
                        color: Color(0xFF8B7158),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DiceBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()..color = const Color(0xFFEADFCB);
    const spacing = 20.0;
    for (double y = spacing / 2; y < size.height; y += spacing) {
      for (double x = spacing / 2; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), 2.2, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
  const _DiceDotPainter(this.point);

  @override
  void paint(Canvas canvas, Size size) {
    final double s = size.width / 5.2;
    final double r = size.width / 12;
    final centers = [
      Offset(s * 1.3, s * 1.3),
      Offset(s * 2.6, s * 1.3),
      Offset(s * 3.9, s * 1.3),
      Offset(s * 1.3, s * 2.6),
      Offset(s * 2.6, s * 2.6),
      Offset(s * 3.9, s * 2.6),
      Offset(s * 1.3, s * 3.9),
      Offset(s * 2.6, s * 3.9),
      Offset(s * 3.9, s * 3.9),
    ];
    List<int> idx = [];
    switch (point) {
      case 1:
        idx = [4];
        break;
      case 2:
        idx = [0, 8];
        break;
      case 3:
        idx = [0, 4, 8];
        break;
      case 4:
        idx = [0, 2, 6, 8];
        break;
      case 5:
        idx = [0, 2, 4, 6, 8];
        break;
      case 6:
        idx = [0, 2, 3, 5, 6, 8];
        break;
    }
    for (final i in idx) {
      final color =
          (point == 1) ? TrafficColors.diceDotMain : TrafficColors.diceDotSub;
      canvas.drawCircle(centers[i], r, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
