import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:share_plus/share_plus.dart';
import 'package:toptop_app/providers/providers.dart';
import 'package:toptop_app/providers/state_notifier_providers.dart';
import 'package:toptop_app/screens/comments_screen.dart';
import 'package:toptop_app/screens/other_user_profile_screen.dart';
import 'package:toptop_app/screens/tab/tab_screen.dart';
import 'package:toptop_app/screens/video_option_screen.dart';
import 'package:toptop_app/src/page_routes.dart';

import '../models/video.dart';
import '../models/user.dart' as user_model;
import '../src/constants.dart';
import 'animations/circle_animation_widget.dart';
import 'common/custom_circle_avatar.dart';

class CustomRightTaskbar extends ConsumerStatefulWidget {
  const CustomRightTaskbar({
    Key? key,
    required this.video,
    this.isProfileScreen = false,
  }) : super(key: key);

  final Video video;
  final bool isProfileScreen;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomRightTaskbarState();
}

class _CustomRightTaskbarState extends ConsumerState<CustomRightTaskbar>
    with TickerProviderStateMixin {
  late Video currentVideo;
  user_model.User? currentUser;
  user_model.User? postedVideoUser;
  bool? isFollowed;

  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(microseconds: 300),
      vsync: this,
    )..forward();

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _loadData();
  }

  Future<void> _loadData() async {
    currentVideo = widget.video;
    currentUser = await ref.read(currentUserProvider);
    postedVideoUser =
        await ref.read(userServiceProvider).getUserByID(currentVideo.userId);

    isFollowed = postedVideoUser?.followers.contains(currentUser?.id);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void _followUserAccount() {
      setState(() {
        isFollowed = true;
      });

      if (currentUser == null) return;

      // update user posted video
      postedVideoUser!.followers.add(currentUser!.id);
      final videoUserUpdated = postedVideoUser!.copyWith(
        followers: postedVideoUser!.followers,
        recentUpdatedDate: DateTime.now(),
      );

      ref.read(userServiceProvider).updateUser(
            userId: postedVideoUser!.id,
            userUpdated: videoUserUpdated,
          );

      // update current user
      currentUser!.following.add(postedVideoUser!.id);

      final currentUserUpdated = currentUser!.copyWith(
        following: currentUser!.following,
        recentUpdatedDate: DateTime.now(),
      );

      ref.read(currentUserControllerProvider.notifier).updateUser(
            id: currentUser!.id,
            userUpdated: currentUserUpdated,
          );
    }

    Future<bool> _likeVideo(bool isLiked) async {
      isLiked = !isLiked;
      var _userIdLiked = currentVideo.userIdLiked;

      if (isLiked) {
        _userIdLiked.add(currentUser?.id);
      } else {
        _userIdLiked.remove(currentUser?.id);
      }

      setState(() {});

      await ref.read(videoControllerProvider.notifier).updateVideo(
            videoId: currentVideo.id,
            videoUpdated: currentVideo.copyWith(
              userIdLiked: _userIdLiked,
              recentUpdatedDate: DateTime.now(),
            ),
          );

      return isLiked;
    }

    Future<void> _shareVideo() async {
      final result = await Share.shareWithResult(currentVideo.videoUrl);
      if (result.status == ShareResultStatus.success) {
        currentVideo.increaseShareCount();

        await ref.read(videoControllerProvider.notifier).updateVideo(
              videoId: currentVideo.id,
              videoUpdated: currentVideo,
            );
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              (currentUser?.id != currentVideo.userId)
                  ? CustomPageRoute(
                      child: OtherUserProfileScreen(
                        userId: currentVideo.userId,
                      ),
                    )
                  : MaterialPageRoute(
                      builder: (context) => const TabScreen(screenIndex: 4),
                    ),
            );
          },
          child: buildAvatar(onPressed: _followUserAccount),
        ),
        // const SizedBox(
        //   height: 14,
        // ),
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

        (currentVideo.userId == currentUser?.id && widget.isProfileScreen)
            ? Column(
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: _showOption,
                    icon: const FaIcon(
                      FontAwesomeIcons.ellipsis,
                      color: CustomColors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              )
            : const SizedBox(
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

  Widget buildAvatar({required VoidCallback onPressed}) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          height: 74,
          alignment: Alignment.topCenter,
          child: CircleAvatar(
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
        ),
        if (isFollowed == false &&
            currentVideo.userId != ref.watch(currentUserProvider)!.id)
          Positioned(
            bottom: 17,
            height: 22,
            child: FadeTransition(
              opacity: _animation,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  elevation: 0,
                  padding: const EdgeInsets.all(2),
                  primary: CustomColors.pink,
                  onPrimary: CustomColors.white,
                ),
                onPressed: onPressed,
                child: const FittedBox(
                  child: Icon(Icons.add),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _showOption() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => VideoOptionScreen(video: currentVideo),
    );
  }

  void _showComment() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => CommentsScreen(video: widget.video),
    ).whenComplete(() => setState(() {}));
  }
}
