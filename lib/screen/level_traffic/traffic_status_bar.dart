import 'package:flutter/material.dart';
import 'package:work_on_time_game/config/images.dart';

class TrafficStatusBar extends StatelessWidget {
  final int steps;
  final int maxSteps;
  final int heart;
  final int money;
  final int energy;
  final int maxHeart;
  final int maxMoney;
  final int maxEnergy;

  const TrafficStatusBar({
    Key? key,
    required this.steps,
    required this.maxSteps,
    required this.heart,
    required this.money,
    required this.energy,
    this.maxHeart = 3,
    this.maxMoney = 10,
    this.maxEnergy = 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.brown.shade200, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                images.getFullPath(images.walk),
                width: 32,
                height: 32,
              ),
              const SizedBox(width: 8),
              Text(
                '前進次數',
                style: TextStyle(fontSize: 16, color: Colors.brown.shade700),
              ),
              const SizedBox(width: 4),
              Text(
                '$steps/$maxSteps',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.brown.shade700,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            children: [
              _buildStatusIcon(
                iconPath: images.getFullPath(images.statusMindIcon),
                color: const Color(0xFFFFAC9C),
                percent: heart / maxHeart,
              ),
              const SizedBox(width: 8),
              _buildStatusIcon(
                iconPath: images.getFullPath(images.statusSavingIcon),
                color: const Color(0xFF93D9BF),
                percent: money / maxMoney,
              ),
              const SizedBox(width: 8),
              _buildStatusIcon(
                iconPath: images.getFullPath(images.statusEnergyIcon),
                color: const Color(0xFFFFE77A),
                percent: energy / maxEnergy,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon({
    required String iconPath,
    required Color color,
    required double percent,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: const Color(0xFFAE866B),
          width: 2,
        ),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // 進度條
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(4),
              bottomRight: Radius.circular(4),
            ),
            child: Container(
              width: 40,
              height: 20 * percent.clamp(0.0, 1.0),
              color: color,
            ),
          ),
          Container(
            width: 40,
            height: 40,
            child: Image.asset(iconPath),
          ),
        ],
      ),
    );
  }
}
