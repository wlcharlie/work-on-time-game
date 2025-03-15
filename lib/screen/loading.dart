import 'package:flutter/material.dart';
import 'package:work_on_time_game/config/images.dart';

class Loading extends StatelessWidget {
  const Loading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Image.asset(
        images.getFullPath(images.loading),
        fit: BoxFit.contain,
      ),
    );
  }
}
