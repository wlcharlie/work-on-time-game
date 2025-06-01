// 這是一個單純方便開發者切換場景的工具

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_on_time_game/enums/character_status.dart';
import 'package:work_on_time_game/providers/character_status.dart';
import 'package:work_on_time_game/wot_game.dart';

class Helper extends ConsumerStatefulWidget {
  final WOTGame game;
  const Helper({super.key, required this.game});

  @override
  ConsumerState<Helper> createState() => _HelperState();
}

class _HelperState extends ConsumerState<Helper> {
  // 按钮位置的状态
  Offset _buttonPosition = Offset(0, 0);
  // 按钮的初始位置（屏幕中央右侧）
  late Size _screenSize;
  bool _isInitialized = false;
  // 控制选单显示状态
  bool _isMenuOpen = false;

  // 选单宽度和按钮半径
  final double _menuWidth = 200;
  final double _buttonRadius = 20; // 按钮半径为40/2

  // 计算选单的位置，避免超出屏幕边界
  Offset _calculateMenuPosition() {
    double left = _buttonPosition.dx;
    double top = _buttonPosition.dy + _buttonRadius + 5; // 按钮下方5像素

    // 检查水平方向是否会超出屏幕
    // 如果按钮在屏幕右半部分，则选单向左展开
    if (left > _screenSize.width / 2) {
      left = left - _menuWidth;
    }

    // 确保选单不会超出左边界
    if (left < 10) {
      left = 10;
    }

    // 确保选单不会超出右边界
    if (left + _menuWidth > _screenSize.width - 10) {
      left = _screenSize.width - _menuWidth - 10;
    }

    // 检查垂直方向是否会超出屏幕底部
    double menuHeight = 150; // 估计选单高度
    if (top + menuHeight > _screenSize.height - 10) {
      // 如果底部空间不够，则选单向上展开
      top = _buttonPosition.dy - menuHeight - 5;
    }

    // 确保选单不会超出顶部边界
    if (top < 10) {
      top = 10;
    }

    return Offset(left, top);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 获取屏幕尺寸并设置按钮的初始位置
      _screenSize = MediaQuery.of(context).size;
      setState(() {
        _buttonPosition =
            Offset(_screenSize.width * 0.85, _screenSize.height * 0.5);
        _isInitialized = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final characterStatus = ref.watch(characterStatusNotifierProvider);

    return Stack(
      children: [
        // 狀態
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Mind: ${characterStatus[CharacterStatus.mind]}'),
              const SizedBox(width: 16),
              Text('Saving: ${characterStatus[CharacterStatus.saving]}'),
              const SizedBox(width: 16),
              Text('Energy: ${characterStatus[CharacterStatus.energy]}'),
            ],
          ),
        ),

        // 当选单打开时显示一个半透明背景，点击背景关闭选单
        if (_isMenuOpen)
          GestureDetector(
            onTap: () {
              setState(() {
                _isMenuOpen = false;
              });
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withValues(alpha: .3),
            ),
          ),

        // 选单内容
        if (_isInitialized && _isMenuOpen)
          Positioned(
            left: _calculateMenuPosition().dx,
            top: _calculateMenuPosition().dy,
            child: Container(
              width: _menuWidth,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 这里是选单内容，您可以根据需要自行填充
                  _buildMenuItem(Icons.home, '首頁'),
                  _buildMenuItem(Icons.picture_in_picture, '下雨場景'),
                  _buildMenuItem(Icons.traffic, '交通場景'),
                  Divider(height: 1),
                  _buildMenuItem(Icons.settings, '設定'),
                  Divider(height: 1),
                  _buildMenuItem(Icons.info, '關於'),
                  // 可以根据需要添加更多选项
                ],
              ),
            ),
          ),

        // 可拖曳的按钮
        if (_isInitialized)
          Positioned(
            left: _buttonPosition.dx - _buttonRadius, // 调整位置使按钮中心点在触摸位置
            top: _buttonPosition.dy - _buttonRadius,
            child: GestureDetector(
              onPanUpdate: (details) {
                // 当用户拖动时更新按钮位置
                setState(() {
                  _buttonPosition = Offset(
                    _buttonPosition.dx + details.delta.dx,
                    _buttonPosition.dy + details.delta.dy,
                  );
                });
              },
              onTap: () {
                // 点击按钮时切换选单显示状态
                setState(() {
                  _isMenuOpen = !_isMenuOpen;
                });
              },
              child: Container(
                width: _buttonRadius * 2,
                height: _buttonRadius * 2,
                decoration: BoxDecoration(
                  color: Color(0xFFFAC7A0),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.drag_handle,
                    color: Color(0xFFAE886C),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  // 构建选单项的辅助方法
  Widget _buildMenuItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFFAE886C)),
      title: Text(title),
      dense: true,
      onTap: () {
        // 点击后关闭选单
        setState(() {
          _isMenuOpen = false;
        });

        switch (title) {
          case '首頁':
            widget.game.router.pushNamed('lobby');
            break;
          case '下雨場景':
            widget.game.router.pushNamed('scene');
            break;
          case '交通場景':
            widget.game.router.pushNamed('traffic');
            break;
          default:
            break;
        }
      },
    );
  }
}
