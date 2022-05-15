import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toptop_app/screens/video_screen.dart';

import '../../models/video.dart';
import '../../src/constants.dart';

class VideoGridView extends ConsumerStatefulWidget {
  const VideoGridView({
    Key? key,
    required this.userId,
    required this.videos,
  }) : super(key: key);

  final String userId;
  final List<Video> videos;

  @override
  ConsumerState<VideoGridView> createState() => _VideoGridViewState();
}

class _VideoGridViewState extends ConsumerState<VideoGridView> {
  late List<Video> videos = [];

  @override
  void initState() {
    super.initState();
    videos = widget.videos;
  }

  void _navigateToVideoScreen(Video video) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Scaffold(
        backgroundColor: CustomColors.black,
        body: VideoScreen(video: video),
      ),
    ));
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
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
