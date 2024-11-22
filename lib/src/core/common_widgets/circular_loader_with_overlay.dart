import 'package:flutter/material.dart';
import 'package:VidBox/src/core/media_query.dart';

class CircularLoaderWithOverlay extends StatelessWidget {
  const CircularLoaderWithOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: context.width,
          height: context.height,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
        const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
