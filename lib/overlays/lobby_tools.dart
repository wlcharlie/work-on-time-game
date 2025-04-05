import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:work_on_time_game/wot_game.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(),
        ),
      ),
    );
  }
}
