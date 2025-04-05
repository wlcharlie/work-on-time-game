import 'dart:ui';

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
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(
          sigmaX: 10,
          sigmaY: 10,
        ),
        child: Image.asset(
          images.getFullPath(images.loading),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
