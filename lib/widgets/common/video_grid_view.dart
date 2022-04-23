import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../screens/video_screen.dart';
import '../../src/constants.dart';

class VideoGridView extends StatefulWidget {
  const VideoGridView({
    Key? key,
  }) : super(key: key);

  @override
  State<VideoGridView> createState() => _VideoGridViewState();
}

class _VideoGridViewState extends State<VideoGridView> {
  late VideoPlayerController _controller;

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
      itemCount: VideoScreen.videosUrl.length,
      itemBuilder: (ctx, index) {
        return GestureDetector(
          onTap: (() {}),
          child: Stack(
            children: [
              VideoPlayer(
                _controller = VideoPlayerController.network(
                  VideoScreen.videosUrl[index],
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
