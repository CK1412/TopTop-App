import 'package:flutter/material.dart';
import 'package:toptop_app/screens/video_screen.dart';
import 'package:video_player/video_player.dart';

import '../../models/video.dart';
import '../../src/constants.dart';

class VideoGridView extends StatefulWidget {
  const VideoGridView({
    Key? key,
    required this.videos,
  }) : super(key: key);

  final List<Video> videos;

  @override
  State<VideoGridView> createState() => _VideoGridViewState();
}

class _VideoGridViewState extends State<VideoGridView> {
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

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 3 / 4,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
      ),
      itemCount: videos.length,
      itemBuilder: (ctx, index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => VideoScreen(video: videos[index]),
            ));
          },
          child: Stack(
            children: [
              VideoPlayer(
                _controller = VideoPlayerController.network(
                  videos[index].videoUrl,
                )..initialize(),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    '❤️ 23K',
                    style: CustomTextStyle.title3
                        .copyWith(color: CustomColors.white),
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
