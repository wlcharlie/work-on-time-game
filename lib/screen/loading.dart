import 'package:flutter/material.dart';
import 'package:work_on_time_game/config/images.dart';

class Loading extends StatelessWidget {
  const Loading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          images.getFullPath(images.loading),
        ),
        // Positioned(
        //   bottom: 110,
        //   left: 0,
        //   right: 0,
        //   child: Container(
        //     padding: const EdgeInsets.symmetric(horizontal: 10),
        //     child: Stack(
        //       children: [
        //         Expanded(
        //           child: Container(
        //             height: 23,
        //             padding:
        //                 const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
        //             decoration: BoxDecoration(
        //               color: Colors.white,
        //               borderRadius: BorderRadius.circular(8),
        //               border: Border.all(
        //                 color: Color(0xFF9c8472),
        //                 width: 2,
        //               ),
        //             ),
        //             child: Stack(
        //               children: [
        //                 Container(
        //                   decoration: BoxDecoration(
        //                     color: Color(0xFF9c8472).withValues(alpha: 0.15),
        //                     borderRadius: BorderRadius.circular(4),
        //                   ),
        //                   height: 15,
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
