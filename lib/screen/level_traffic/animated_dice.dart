import 'dart:math';
import 'package:flutter/material.dart';
import 'package:work_on_time_game/config/images.dart';

class AnimatedDiceWidget extends StatefulWidget {
  final void Function(int point) onRollEnd;
  const AnimatedDiceWidget({required this.onRollEnd, Key? key})
      : super(key: key);

  @override
  State<AnimatedDiceWidget> createState() => _AnimatedDiceWidgetState();
}

class _AnimatedDiceWidgetState extends State<AnimatedDiceWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotation;
  int? _point;
  bool _rolling = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 900), vsync: this);
    _rotation = Tween<double>(begin: 0, end: 2 * pi)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _rolling = false);
        widget.onRollEnd(_point!);
      }
    });
  }

  void _rollDice() {
    if (_rolling) return;
    setState(() {
      _rolling = true;
      _point = Random().nextInt(6) + 1;
    });
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _rollDice,
      child: AnimatedBuilder(
        animation: _rotation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotation.value,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  images.getFullPath(images.dice),
                  width: 64,
                  height: 64,
                ),
                if (!_rolling && _point != null)
                  Positioned(
                    child: Text(
                      '$_point',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8B7158),
                        shadows: [
                          Shadow(
                            color: Colors.white,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
