import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CircularAvatarWidget extends StatelessWidget {
  const CircularAvatarWidget({
    super.key,
    required this.imageUrl,
    this.outerRadius = 27.0,
    this.innerRadius = 25.0,
    this.color = Colors.white,
  });

  final String imageUrl;
  final double outerRadius;
  final double innerRadius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: outerRadius,
      backgroundColor: Colors.blueAccent,
      child: ClipOval(
        child: CachedNetworkImage(
          width: innerRadius * 2,
          height: innerRadius * 2,
          fit: BoxFit.cover,
          imageUrl: imageUrl,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              CircularProgressIndicator(
            value: downloadProgress.progress,
            color: Colors.amberAccent,
          ),
        ),
      ),
    );
  }
}
