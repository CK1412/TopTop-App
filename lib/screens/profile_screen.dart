import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toptop_app/models/user.dart';
import 'package:toptop_app/providers/future_providers.dart';
import 'package:toptop_app/providers/state_notifier_providers.dart';
import 'package:toptop_app/screens/error_screen.dart';
import 'package:toptop_app/widgets/common/center_loading_widget.dart';

import '../models/video.dart';
import '../providers/providers.dart';
import '../src/constants.dart';
import '../widgets/common/custom_circle_avatar.dart';
import '../widgets/common/video_grid_view.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserState = ref.watch(userControllerProvider);

    return SafeArea(
      child: SizedBox.expand(
        child: currentUserState.when(
          data: (user) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ContentBlockAbove(user: user!),
              ContentBlockBelow(userId: user.id),
            ],
          ),
          error: (e, stackTrace) => ErrorScreen(e, stackTrace),
          loading: () => const CenterLoadingWidget(),
        ),
      ),
    );
  }
}

class ContentBlockAbove extends StatelessWidget {
  const ContentBlockAbove({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  user.email,
                  style: CustomTextStyle.title1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              buildMenuButton(context)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.blueAccent,
                      Colors.redAccent,
                      Colors.purpleAccent,
                      Colors.yellowAccent,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CustomCircleAvatar(
                    avatarUrl: user.avatarUrl,
                    radius: MediaQuery.of(context).size.width * .1,
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    user.following.length.toString(),
                    style: CustomTextStyle.title1,
                  ),
                  const Text(
                    'Following',
                    style: CustomTextStyle.bodyText2,
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    user.followers.length.toString(),
                    style: CustomTextStyle.title1,
                  ),
                  const Text(
                    'Followers',
                    style: CustomTextStyle.bodyText2,
                  ),
                ],
              ),
              Column(
                children: const [
                  Text('0', style: CustomTextStyle.title1),
                  Text(
                    'Likes',
                    style: CustomTextStyle.bodyText2,
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              '@${user.username}',
              style: CustomTextStyle.title3,
            ),
          ),
          Text(
            '#${user.bio}',
            style: CustomTextStyle.bodyText2,
          ),
          const SizedBox(
            height: 6,
          ),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const EditProfileScreen(),
                ));
              },
              child: const Text('Edit profile'),
              style: OutlinedButton.styleFrom(
                primary: CustomColors.black,
                side: BorderSide(
                  color: CustomColors.grey.withOpacity(.6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMenuButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          builder: (ctx) {
            // SingleChildScrollView adjust the bottomsheet height based on the content
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 20, right: 12),
                child: Column(
                  children: [
                    Container(
                      height: 4,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: CustomColors.black.withOpacity(.8),
                      ),
                      margin: const EdgeInsets.only(top: 10, bottom: 20),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: const [
                          Icon(Icons.settings, size: 28),
                          SizedBox(width: 8),
                          Text(
                            'Settings',
                            style: CustomTextStyle.bodyText1,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: const [
                          Icon(Icons.analytics_outlined, size: 28),
                          SizedBox(width: 8),
                          Text(
                            'Abs',
                            style: CustomTextStyle.bodyText1,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: const [
                          Icon(Icons.qr_code_rounded, size: 28),
                          SizedBox(width: 8),
                          Text(
                            'QR code',
                            style: CustomTextStyle.bodyText1,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Consumer(
                      builder: (context, ref, child) {
                        _logOutCurrentUser() async {
                          Navigator.of(context).pop();
                          await ref
                              .read(authControllerProvider.notifier)
                              .signOut(context);
                        }

                        return GestureDetector(
                          onTap: _logOutCurrentUser,
                          child: Row(
                            children: const [
                              Icon(Icons.logout_rounded, size: 28),
                              SizedBox(width: 8),
                              Text(
                                'Log out',
                                style: CustomTextStyle.bodyText1,
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
      icon: const Icon(Icons.menu),
    );
  }
}

class ContentBlockBelow extends ConsumerStatefulWidget {
  const ContentBlockBelow({
    Key? key,
    required this.userId,
  }) : super(key: key);

  final String userId;

  @override
  ConsumerState<ContentBlockBelow> createState() => _ContentBlockBelowState();
}

class _ContentBlockBelowState extends ConsumerState<ContentBlockBelow> {
  int _tabIndex = 0;

  List tabIcons = [
    Icons.grid_on_rounded,
    Icons.favorite_border_outlined,
  ];

  //* List of videos posted by current user
  late List<Video>? videosPosted;
  //* List of videos Liked by current user
  late List<Video>? videosLiked;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            children: List.generate(
              tabIcons.length,
              (index) => Flexible(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _tabIndex = index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: _tabIndex == index
                            ? const BorderSide(
                                width: 2,
                                color: CustomColors.black,
                              )
                            : const BorderSide(
                                width: 1,
                                color: CustomColors.grey,
                              ),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Icon(
                      tabIcons[index],
                      color: _tabIndex == index
                          ? CustomColors.black
                          : CustomColors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: IndexedStack(
              sizing: StackFit.expand,
              index: _tabIndex,
              children: [
                VideosPostGridView(userId: widget.userId),
                VideoLikedGridView(userId: widget.userId),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class VideosPostGridView extends ConsumerWidget {
  const VideosPostGridView({
    Key? key,
    required this.userId,
  }) : super(key: key);

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videosPostedState = ref.watch(videosPostedByUserProvider(userId));

    return videosPostedState.when(
      data: (videos) => videos!.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Share your first video',
                    style: CustomTextStyle.title2,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 4,
                      left: 14,
                      right: 14,
                    ),
                    child: Text(
                      'Record and upload video with effects, sounds, and more.',
                      style: CustomTextStyle.bodyText2.copyWith(
                        color: CustomColors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Create video'),
                  ),
                ],
              ),
            )
          : VideoGridView(
              userId: userId,
              videos: videos,
            ),
      error: (e, stackTrace) => const CenterLoadingWidget(),
      loading: () => const CenterLoadingWidget(),
    );
  }
}

class VideoLikedGridView extends ConsumerWidget {
  const VideoLikedGridView({
    Key? key,
    required this.userId,
  }) : super(key: key);

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videosLiked = ref.watch(videosLikedByUserProvider(userId));

    return videosLiked!.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'You haven\'t liked any videos yet',
                  style: CustomTextStyle.title2,
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Discover now'),
                ),
              ],
            ),
          )
        : VideoGridView(
            userId: userId,
            videos: videosLiked,
          );
  }
}
