import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_on_time_game/config/images.dart';
import 'package:work_on_time_game/config/typography.dart';
import 'package:work_on_time_game/wot_game.dart';

final tabBarIcons = [
  images.getFullPath(images.tabbarHomeIcon),
  images.getFullPath(images.tabbar2Icon),
  images.getFullPath(images.tabbarBookIcon),
  images.getFullPath(images.tabbarSettingsIcon),
  images.getFullPath(images.tabbarMenuIcon),
];

final statusIcons = [
  images.getFullPath(images.statusMindIcon),
  images.getFullPath(images.statusSavingIcon),
  images.getFullPath(images.statusEnergyIcon),
];

class LobbyTools extends ConsumerStatefulWidget {
  final WOTGame game;
  const LobbyTools({super.key, required this.game});

  @override
  ConsumerState<LobbyTools> createState() => _LobbyToolsState();
}

class _LobbyToolsState extends ConsumerState<LobbyTools> {
  @override
  void initState() {
    super.initState();
  }

  void _onStartButtonTap() {
    widget.game.router.pushNamed('level_home');
    widget.game.overlays.remove('lobbyTools');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 0,
      children: [
        SizedBox(height: MediaQuery.of(context).padding.top),
        _buildStatusBar(),
        const SizedBox(height: 8),
        _buildEventButton(),
        Expanded(
          child: IgnorePointer(
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        _buildStartButton(),
        const SizedBox(height: 12),
        _buildTabBar(context),
      ],
    );
  }

  Widget _buildStatusBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        height: 88,
        decoration: BoxDecoration(
          color: const Color(0xFFF4DBCB),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: const Color(0xFFAE866B),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 3,
                  children: [
                    Text(
                      'Shiro',
                      style: typography.tp24,
                    ),
                    Text(
                      '通勤小達人',
                      style: typography.tp14,
                    ),
                  ],
                ),
              ],
            ),
            Column(
              spacing: 7,
              children: [
                Row(
                  spacing: 3,
                  children: [
                    _buildStatusIcon(
                      icon: Image.asset(statusIcons[0]),
                      color: const Color(0xFFFFAC9C),
                    ),
                    _buildStatusIcon(
                      icon: Image.asset(statusIcons[1]),
                      color: const Color(0xFF93D9BF),
                    ),
                    _buildStatusIcon(
                      icon: Image.asset(statusIcons[2]),
                      color: const Color(0xFFFFE77A),
                    ),
                  ],
                ),
                _buildTicketBar(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon({required Image icon, required Color color}) {
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
          // meter like background
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(4),
              bottomRight: Radius.circular(4),
            ),
            child: Container(
              width: 40,
              height: 20,
              color: color,
            ),
          ),
          Container(
            width: 40,
            height: 40,
            child: icon,
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      height: 62 + MediaQuery.of(context).padding.bottom,
      padding: EdgeInsets.fromLTRB(
          26, 14, 26, MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: const Color(0xFFF7ECE0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: tabBarIcons
            .map(
              (icon) => Image.asset(
                icon,
                width: 48,
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildStartButton() {
    return GestureDetector(
      onTap: _onStartButtonTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Container(
          height: 87,
          decoration: BoxDecoration(
            color: const Color(0xFFF7ECE0),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFAE866B),
              width: 4,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: [
              Text('準備去上班！', style: typography.tp20m),
              Text(
                '（消耗 1 能量）',
                style: typography.tp16m.copyWith(
                  color: const Color(0xFF8A5E41).withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFFBF5F0),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: const Color(0xFFAE866B),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Text('活動資訊', style: typography.tp20m),
            const Spacer(),
            Text(
              'more',
              style: typography.tp16m.copyWith(
                color: const Color(0xFFC0AFA5),
              ),
            ),
            const SizedBox(width: 21),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketBar() {
    final ticketCount = 4;

    final firstTicketRadius = BorderRadius.only(
      topLeft: Radius.circular(3),
      bottomLeft: Radius.circular(3),
    );

    final lastTicketRadius = BorderRadius.only(
      topRight: Radius.circular(3),
      bottomRight: Radius.circular(3),
    );

    return Container(
      height: 13,
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF5F0),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: const Color(0xFFAE866B),
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 1,
        children: [
          for (var i = 0; i < ticketCount; i++)
            Container(
              width: 30,
              height: 7,
              decoration: BoxDecoration(
                color: const Color(0xFFF9DCA3),
                borderRadius: i == 0
                    ? firstTicketRadius
                    : i == ticketCount - 1
                        ? lastTicketRadius
                        : BorderRadius.circular(1),
              ),
            ),
        ],
      ),
    );
  }
}
