import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ttt_project_003/constant/common_size.dart';


class RoundedAvatar extends StatelessWidget {
  String imageUrl;

  final double size;

  RoundedAvatar({
    Key key, this.size = avatar_size, @required this.imageUrl
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        width: size,
        height: size,
      ),
    );
  }
}