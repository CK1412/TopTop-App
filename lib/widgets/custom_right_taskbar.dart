import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:share_plus/share_plus.dart';
import 'package:toptop_app/providers/state_notifier_providers.dart';

import '../models/user.dart';
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
  final isLikedComment = false;
  var likedCommentCount = 0;

  User? currentUser;
  late Video currentVideo;

  @override
  void initState() {
    super.initState();
    currentVideo = widget.video;
    ref.read(userControllerProvider).whenData((value) {
      currentUser = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _likeVideo(bool isLiked) async {
      isLiked = !isLiked;
      if (isLiked) {
        currentVideo.userIdLiked.add(currentUser?.id);
      } else {
        currentVideo.userIdLiked.remove(currentUser?.id);
      }

      ref.read(videoControllerProvider.notifier).updateVideo(
            videoId: currentVideo.id,
            videoUpdated: currentVideo.copyWith(
              userIdLiked: currentVideo.userIdLiked,
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
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      '123 comments',
                      style: CustomTextStyle.title3,
                    ),
                  ),
                ),
                const SizedBox(width: 32)
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomCircleAvatar(
                        avatarUrl: avatarUrl,
                        radius: 16,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'My name',
                              style: CustomTextStyle.title3.copyWith(
                                color: CustomColors.grey,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            const Text(
                              'Hahaha sdh h fd fhf  sf  sdfh sfhsd sf dfhd fdf f dfh sdfhs',
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              DateFormat.Md().format(DateTime.now()),
                              style: CustomTextStyle.title3.copyWith(
                                color: CustomColors.grey,
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      LikeButton(
                        isLiked: isLikedComment,
                        likeCount: likedCommentCount,
                        size: 20,
                        countPostion: CountPostion.bottom,
                        bubblesColor: const BubblesColor(
                          dotPrimaryColor: CustomColors.pink,
                          dotSecondaryColor: CustomColors.purple,
                        ),
                        likeCountPadding: const EdgeInsets.only(top: 4),
                        likeBuilder: (bool isLiked) {
                          return isLiked
                              ? const Icon(
                                  Icons.favorite,
                                  color: CustomColors.pink,
                                )
                              : const Icon(
                                  Icons.favorite_outline_outlined,
                                  color: CustomColors.grey,
                                );
                        },
                        onTap: (isLiked) async {
                          isLiked = !isLiked;
                          if (isLiked) {
                            likedCommentCount++;
                          } else {
                            likedCommentCount--;
                          }
                          return isLiked;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(height: 0),
            Padding(
              padding: EdgeInsets.only(
                left: 10,
                right: 10,
                top: 10,
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: Row(
                children: [
                  CustomCircleAvatar(
                    avatarUrl: currentVideo.userAvatarUrl,
                    radius: 16,
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Add a comment',
                        hintStyle: CustomTextStyle.bodyText2.copyWith(
                          color: CustomColors.grey,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Post'),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
