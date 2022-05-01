import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:toptop_app/models/video.dart';
import 'package:toptop_app/providers/state_notifier_providers.dart';
import 'package:toptop_app/screens/error_screen.dart';
import 'package:toptop_app/widgets/common/center_loading_widget.dart';

import '../src/constants.dart';
import '../widgets/common/text_expand_widget.dart';
import '../widgets/common/video_player_widget.dart';
import '../widgets/custom_right_taskbar.dart';

class VideoScreen extends ConsumerWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videosState = ref.watch(videoControllerProvider);

    return videosState.when(
      data: (videos) => PageView.builder(
        itemCount: videos.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) => Stack(
          children: [
            GestureDetector(
              onTap: () {},
              child: VideoPlayerWidget(
                video: videos[index],
              ),
            ),
            Positioned(
              right: 10,
              bottom: 14,
              child: CustomRightTaskbar(video: videos[index]),
            ),
            Positioned(
              bottom: 14,
              left: 10,
              width: MediaQuery.of(context).size.width * .6,
              child: InformationBelow(video: videos[index]),
            ),
          ],
        ),
      ),
      error: (e, stackTrace) => ErrorScreen(e, stackTrace),
      loading: () => const CenterLoadingWidget(),
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
