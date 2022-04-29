import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:toptop_app/models/user.dart';
import 'package:toptop_app/models/video.dart';
import 'package:toptop_app/providers/state.dart';
import 'package:toptop_app/services/auth_service.dart';
import 'package:toptop_app/services/video_service.dart';
import 'package:toptop_app/widgets/animations/heart_animation_widget.dart';
import 'package:video_player/video_player.dart';

import '../../src/constants.dart';
import '../common/loading_widget.dart';

class VideoPlayerWidget extends ConsumerStatefulWidget {
  const VideoPlayerWidget({
    Key? key,
    required this.video,
  }) : super(key: key);

  final Video video;

  @override
  ConsumerState<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends ConsumerState<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  late final User _currentUser;
  late final VideoService _videoService;

  late bool _isLiked;
  late bool _isHeartAnimating;

  @override
  void initState() {
    super.initState();
    _currentUser = AuthService.instance.currentUser!;
    _videoService = ref.read(videoProvider);
    _controller = VideoPlayerController.network(widget.video.videoUrl)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      })
      ..play()
      ..setVolume(1)
      ..setLooping(true)
          .then((value) => ref.read(videoStateProvider.notifier).state = true);

    _isLiked = widget.video.userIdLiked.contains(_currentUser.id);
    _isHeartAnimating = false;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.pause();
    _controller.dispose();
  }

  void _toggleVideoState() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        ref.read(videoStateProvider.state).state = false;
      } else {
        _controller.play();
        ref.read(videoStateProvider.state).state = true;
      }
    });
  }

  //! only like video
  Future<void> _onlyLikeVideo() async {
    _isLiked = widget.video.userIdLiked.contains(_currentUser.id);
    if (_isLiked) {
      _isHeartAnimating = true;
      return;
    }

    _isLiked = true;
    _isHeartAnimating = true;
    widget.video.userIdLiked.add(_currentUser.id);

    await _videoService.update(
      videoId: widget.video.id,
      videoUpdated: widget.video.copyWith(
        userIdLiked: widget.video.userIdLiked,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _videoSize = _controller.value.size;
    BoxFit _fit =
        (_videoSize.width > _videoSize.height) ? BoxFit.contain : BoxFit.cover;

    return _controller.value.isInitialized
        ? GestureDetector(
            onTap: _toggleVideoState,
            onDoubleTap: () => _onlyLikeVideo(),
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
                ),
                //* show heart animation when doubleTap
                Opacity(
                  opacity: _isHeartAnimating ? 1 : 0,
                  child: Align(
                    child: HeartAnimationWidget(
                      isAnimating: _isHeartAnimating,
                      child: Lottie.asset(
                        LottiePath.heartAnimation,
                        width: 240,
                      ),
                      onEnd: () => setState(() {
                        _isHeartAnimating = false;
                      }),
                    ),
                  ),
                )
              ],
            ),
          )
        : const LoadingWidget();
  }
}
