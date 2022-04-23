import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../src/constants.dart';
import '../widgets/common/text_expand_widget.dart';
import '../widgets/common/video_player_widget.dart';
import '../widgets/custom_right_taskbar.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({Key? key}) : super(key: key);

  static final List videosUrl = [
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
  ];
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: videosUrl.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) => Stack(
        children: [
          VideoPlayerWidget(
            videoUrl: videosUrl[index],
          ),
          const Positioned(
            right: 10,
            bottom: 14,
            child: CustomRightTaskbar(),
          ),
          Positioned(
            bottom: 14,
            left: 10,
            width: MediaQuery.of(context).size.width * .6,
            child: const InformationBelow(),
          ),
        ],
      ),
    );
  }
}

class InformationBelow extends StatelessWidget {
  const InformationBelow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '@user',
          style: CustomTextStyle.title2.copyWith(color: CustomColors.white),
        ),
        const SizedBox(
          height: 6,
        ),
        const TextExpandWidget(
          text:
              'f hd asjsdjdjffdhfhđgdfdgdff s sadhfi asjsdjdjffdhfhđgdfdgdff s sadhfi fhd jd cdhid hds hdf idsf dsf hdsfhd jd cdhid hds hdf idsf dsf hds ha fhas dúah',
          textColor: CustomColors.white,
        ),
        const SizedBox(
          height: 6,
        ),
        Row(
          children: [
            Lottie.asset(LottiePath.barMusic, height: 26),
            Text(
              'Tên bài hát',
              style:
                  CustomTextStyle.bodyText2.copyWith(color: CustomColors.white),
            ),
          ],
        )
      ],
    );
  }
}
