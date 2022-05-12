import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:like_button/like_button.dart';
import 'package:share_plus/share_plus.dart';
import 'package:toptop_app/providers/providers.dart';
import 'package:toptop_app/providers/state_notifier_providers.dart';
import 'package:toptop_app/screens/comments_screen.dart';

import '../models/video.dart';
import '../src/constants.dart';
import 'animations/circle_animation_widget.dart';
import 'common/custom_circle_avatar.dart';

class CustomRightTaskbar extends ConsumerStatefulWidget {
  const CustomRightTaskbar({Key? key, required this.video}) : super(key: key);

  final Video video;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomRightTaskbarState();
}

class _CustomRightTaskbarState extends ConsumerState<CustomRightTaskbar> {
  late Video currentVideo;

  @override
  void initState() {
    super.initState();
    currentVideo = widget.video;
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = ref.watch(currentUserProvider);

    Future<bool> _likeVideo(bool isLiked) async {
      isLiked = !isLiked;
      var _userIdLiked = currentVideo.userIdLiked;

      if (isLiked) {
        _userIdLiked.add(currentUser?.id);
      } else {
        _userIdLiked.remove(currentUser?.id);
      }

      ref.read(videoControllerProvider.notifier).updateVideo(
            videoId: currentVideo.id,
            videoUpdated: currentVideo.copyWith(
              userIdLiked: _userIdLiked,
            ),
          );

      return isLiked;
    }

    Future<void> _shareVideo() async {
      final result = await Share.shareWithResult(currentVideo.videoUrl);
      if (result.status == ShareResultStatus.success) {
        currentVideo.shareCount++;

        await ref.read(videoControllerProvider.notifier).updateVideo(
              videoId: currentVideo.id,
              videoUpdated: currentVideo.copyWith(
                shareCount: currentVideo.shareCount,
              ),
            );
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        buildAvatar(),
        const SizedBox(
          height: 14,
        ),
        LikeButton(
          isLiked: currentVideo.userIdLiked.contains(currentUser?.id),
          size: 40,
          bubblesColor: const BubblesColor(
            dotPrimaryColor: CustomColors.pink,
            dotSecondaryColor: CustomColors.purple,
          ),
          likeBuilder: (bool isLiked) {
            return Icon(
              Icons.favorite,
              color: isLiked ? CustomColors.pink : CustomColors.white,
              size: 40,
            );
          },
          onTap: _likeVideo,
        ),
        buildText(currentVideo.userIdLiked.length, context),
        const SizedBox(
          height: 12,
        ),
        buildIconButton(
          iconPath: IconPath.commentFill,
          onPressed: _showComment,
        ),
        buildText(currentVideo.commentCount, context),
        const SizedBox(
          height: 12,
        ),
        //! share button
        buildIconButton(
          iconPath: IconPath.shareFill,
          onPressed: _shareVideo,
        ),
        buildText(currentVideo.shareCount, context),
        const SizedBox(
          height: 16,
        ),
        CircleAnimationWidget(avatarUrl: currentVideo.userAvatarUrl),
      ],
    );
  }

  Widget buildIconButton(
      {required String iconPath, required VoidCallback onPressed}) {
    return IconButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      icon: SvgPicture.asset(
        iconPath,
        color: CustomColors.white,
        width: 32,
      ),
    );
  }

  Widget buildText(int likedCount, BuildContext context) {
    return Text(
      '$likedCount',
      style: CustomTextStyle.bodyText2.copyWith(color: CustomColors.white),
    );
  }

  Widget buildAvatar() {
    return SizedBox(
      height: 60,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: CustomColors.white,
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: CustomCircleAvatar(
                avatarUrl: currentVideo.userAvatarUrl,
                radius: 24,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            height: 22,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                elevation: 0,
                padding: const EdgeInsets.all(2),
                primary: CustomColors.pink,
                onPrimary: CustomColors.white,
              ),
              onPressed: () {},
              child: const FittedBox(
                child: Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showComment() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return CommentsScreen(video: currentVideo);
      },
    );
  }
}
