import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toptop_app/screens/video_screen.dart';
import 'package:video_player/video_player.dart';

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
  late VideoPlayerController _controller;
  late List<Video> videos = [];

  @override
  void initState() {
    super.initState();
    videos = widget.videos;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
              VideoPlayer(
                _controller = VideoPlayerController.network(
                  videos[index].videoUrl,
                )..initialize(),
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
