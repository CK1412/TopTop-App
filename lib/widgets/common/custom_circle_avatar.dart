import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../src/constants.dart';

class CustomCircleAvatar extends StatelessWidget {
  const CustomCircleAvatar({
    Key? key,
    required this.avatarUrl,
    required this.radius,
  }) : super(key: key);

  final String avatarUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    // return CircleAvatar(
    //   radius: widget.radius,
    //   backgroundImage: _loadImageError ? null : NetworkImage(widget.avatarUrl),
    //   backgroundColor: CustomColors.white,
    //   onBackgroundImageError: _loadImageError
    //       ? null
    //       : (e, stack) {
    //           setState(() {
    //             _loadImageError = true;
    //           });
    //         },
    //   child: _loadImageError
    //       ? const FittedBox(
    //           child: Padding(
    //           padding: EdgeInsets.all(6.0),
    //           child: Text('ERROR'),
    //         ))
    //       : null,
    // );
    return CachedNetworkImage(
      imageUrl: avatarUrl,
      fit: BoxFit.cover,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        radius: radius,
        backgroundImage: imageProvider,
      ),
      placeholder: (context, url) => CircleAvatar(
        radius: radius,
        backgroundColor: CustomColors.grey.withOpacity(.3),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
