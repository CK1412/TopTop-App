import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../src/constants.dart';
import '../common/loading_widget.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({
    Key? key,
    required this.videoUrl,
  }) : super(key: key);

  final String videoUrl;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      })
      ..play()
      ..setVolume(1)
      ..setLooping(true);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.pause();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _videoSize = _controller.value.size;
    BoxFit _fit =
        (_videoSize.width > _videoSize.height) ? BoxFit.contain : BoxFit.cover;

    return _controller.value.isInitialized
        ? GestureDetector(
            onTap: (() {
              setState(() {
                _controller.value.isPlaying
                    ? _controller.pause()
                    : _controller.play();
              });
            }),
            child: Stack(
              children: [
                SizedBox.expand(
                  child: FittedBox(
                    fit: _fit,
                    child: SizedBox(
                      height: _videoSize.height,
                      width: _videoSize.width,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),
                Visibility(
                  visible: !_controller.value.isPlaying,
                  child: const Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.play_arrow,
                      color: CustomColors.white,
                      size: 60,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SizedBox(
                    height: 6,
                    child: VideoProgressIndicator(
                      _controller,
                      allowScrubbing: true,
                      colors: const VideoProgressColors(
                        playedColor: CustomColors.white,
                        bufferedColor: CustomColors.black,
                        backgroundColor: CustomColors.black,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        : const LoadingWidget();
  }
}
