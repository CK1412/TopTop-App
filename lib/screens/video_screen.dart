import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../models/video.dart';
import '../src/constants.dart';
import '../widgets/common/text_expand_widget.dart';
import '../widgets/common/video_player_widget.dart';
import '../widgets/custom_right_taskbar.dart';

class VideoScreen extends ConsumerWidget {
  const VideoScreen({
    Key? key,
    required this.video,
    this.isProfileScreen = false,
  }) : super(key: key);

  final Video video;
  final bool isProfileScreen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox.expand(
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {},
            child: VideoPlayerWidget(video: video),
          ),
          Positioned(
            right: 10,
            bottom: 14,
            child: CustomRightTaskbar(
              video: video,
              isProfileScreen: isProfileScreen,
            ),
          ),
          Positioned(
            bottom: 14,
            left: 10,
            width: MediaQuery.of(context).size.width * .6,
            child: InformationBelow(video: video),
          ),
        ],
      ),
    );
  }
}

class InformationBelow extends StatelessWidget {
  const InformationBelow({
    Key? key,
    required this.video,
  }) : super(key: key);

  final Video video;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '@${video.username}',
          style: CustomTextStyle.title2.copyWith(color: CustomColors.white),
        ),
        const SizedBox(
          height: 6,
        ),
        TextExpandWidget(
          text: video.caption,
          textColor: CustomColors.white,
        ),
        const SizedBox(
          height: 6,
        ),
        Row(
          children: [
            Lottie.asset(LottiePath.barMusic, height: 26),
            Text(
              video.songName,
              style: CustomTextStyle.bodyText2.copyWith(
                color: CustomColors.white,
              ),
            ),
          ],
        )
      ],
    );
  }
}
