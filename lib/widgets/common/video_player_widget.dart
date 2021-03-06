import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:toptop_app/models/user.dart';
import 'package:toptop_app/models/video.dart';
import 'package:toptop_app/providers/providers.dart';
import 'package:toptop_app/providers/state_notifier_providers.dart';
import 'package:toptop_app/providers/state_providers.dart';
import 'package:toptop_app/widgets/common/center_loading_widget.dart';

import '../../src/constants.dart';
import '../animations/heart_animation_widget.dart';

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
  late CachedVideoPlayerController _controller;
  // late CachedVideoPlayerController _controller;

  User? _currentUser;

  late bool _isLiked;
  bool _isHeartAnimating = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () {
        _currentUser = ref.read(currentUserProvider);
      },
    ).then((_) {
      if (_currentUser != null) {
        _isLiked = widget.video.userIdLiked.contains(_currentUser!.id);
      }
    });

    _controller = CachedVideoPlayerController.network(
      widget.video.videoUrl,
    )
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
        ref.refresh(videoStateProvider);
        ref.read(videoPlayerControllerProvider.notifier).state = _controller;
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

  void _toggleVideoState() async {
    if (_controller.value.isPlaying) {
      ref.read(videoStateProvider.notifier).state = false;
      await _controller.pause();
    } else {
      ref.read(videoStateProvider.notifier).state = true;
      await _controller.play();
    }
    setState(() {});
  }

  //! only like video
  void _onlyLikeVideo() {
    _isLiked = widget.video.userIdLiked.contains(_currentUser?.id);
    if (_isLiked) {
      _isHeartAnimating = true;
      return;
    }

    _isLiked = true;
    _isHeartAnimating = true;
    widget.video.userIdLiked.add(_currentUser?.id);

    ref.read(videoControllerProvider.notifier).updateVideo(
          videoId: widget.video.id,
          videoUpdated: widget.video.copyWith(
            userIdLiked: widget.video.userIdLiked,
            recentUpdatedDate: DateTime.now(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final _videoSize = _controller.value.size;
    BoxFit _fit =
        (_videoSize.width >= _videoSize.height) ? BoxFit.contain : BoxFit.cover;

    return _controller.value.isInitialized
        ? GestureDetector(
            onTap: () => _toggleVideoState(),
            onDoubleTap: _onlyLikeVideo,
            child: Stack(
              children: [
                SizedBox.expand(
                  child: FittedBox(
                    fit: _fit,
                    child: SizedBox(
                      height: _videoSize.height,
                      width: _videoSize.width,
                      child: CachedVideoPlayer(_controller),
                    ),
                  ),
                ),
                Visibility(
                  // visible: !_controller.value.isPlaying,
                  // visible: !ref
                  //     .watch(videoPlayerControllerProvider)!
                  //     .value
                  //     .isPlaying,
                  visible: !ref.watch(videoStateProvider.notifier).state,
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
        : const CenterLoadingWidget();
  }
}
