import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/video.dart';
import '../../screens/video_screen.dart';
import '../../src/constants.dart';

class VideoGridView extends ConsumerWidget {
  const VideoGridView({
    Key? key,
    required this.videos,
  }) : super(key: key);

  final List<Video> videos;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void _navigateToVideoScreen(Video video) async {
      await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: CustomColors.black,
          body: VideoScreen(video: video, isProfileScreen: true),
        ),
      ));
      // if (mounted) {
      //   setState(() {});
      // }
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 3 / 4,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: videos.length,
      itemBuilder: (ctx, index) {
        return GestureDetector(
          onTap: () => _navigateToVideoScreen(videos[index]),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: videos[index].thumbnailUrl,
                fit: BoxFit.fitWidth,
                placeholder: (context, url) => Container(
                  color: CustomColors.grey.withOpacity(.3),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text(
                    '❤️ ${videos[index].userIdLiked.length}',
                    style: CustomTextStyle.title3.copyWith(
                      color: CustomColors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
