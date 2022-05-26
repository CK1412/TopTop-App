import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toptop_app/models/user.dart';
import 'package:toptop_app/providers/future_providers.dart';
import 'package:toptop_app/screens/settings_screen.dart';
import 'package:toptop_app/screens/tab/tab_screen.dart';
import 'package:toptop_app/widgets/common/center_loading_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../providers/providers.dart';
import '../../src/constants.dart';
import '../../src/page_routes.dart';
import '../../widgets/common/custom_circle_avatar.dart';
import '../../widgets/common/user_interaction_information.dart';
import '../../widgets/common/video_grid_view.dart';
import '../edit_profile_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);

    return SafeArea(
      child: SizedBox.expand(
        child: currentUser != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ContentBlockAbove(user: currentUser),
                  ContentBlockBelow(userId: currentUser.id),
                ],
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

class ContentBlockAbove extends ConsumerWidget {
  const ContentBlockAbove({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User? user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  user!.email,
                  style: CustomTextStyle.title1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              buildMenuButton(context)
            ],
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    avatarUrl: user!.avatarUrl,
                    radius: MediaQuery.of(context).size.width * .1,
                  ),
                ),
              ),
              Expanded(
                child: UserInteractionInformation(
                  user: user,
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              '@${user!.username}',
              style: CustomTextStyle.title3,
            ),
          ),
          Text(
            '#${user!.bio}',
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
              child: Text(AppLocalizations.of(context)!.edit_profile),
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
                    buildListTile(
                      iconData: Icons.settings,
                      title: AppLocalizations.of(context)!.settings,
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          CustomPageRoute(child: const SettingsScreen()),
                        );
                      },
                    ),
                    buildListTile(
                      iconData: Icons.analytics_outlined,
                      title: AppLocalizations.of(context)!.abs,
                      onPressed: () {},
                    ),
                    buildListTile(
                      iconData: Icons.qr_code_rounded,
                      title: AppLocalizations.of(context)!.qR_code,
                      onPressed: () {},
                    ),
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

  ListTile buildListTile({
    required IconData iconData,
    required String title,
    required VoidCallback onPressed,
  }) {
    return ListTile(
      leading: Icon(iconData, size: 28),
      title: Text(title),
      // dense: true,
      minLeadingWidth: 20,
      contentPadding: EdgeInsets.zero,
      onTap: onPressed,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -3),
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
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              indicatorColor: CustomColors.pink,
              labelColor: CustomColors.black,
              tabs: [
                Tab(icon: Icon(Icons.grid_on_rounded)),
                Tab(icon: Icon(Icons.favorite_border_outlined)),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  VideosPostGridView(userId: widget.userId),
                  VideoLikedGridView(userId: widget.userId),
                ],
              ),
            ),
          ],
        ),
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
                  Text(
                    AppLocalizations.of(context)!.share_your_first_video,
                    style: CustomTextStyle.title2,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 4,
                      left: 14,
                      right: 14,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!
                          .record_and_upload_video_with_effects_sounds_and_more,
                      style: CustomTextStyle.bodyText2.copyWith(
                        color: CustomColors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const TabScreen(screenIndex: 2),
                      ));
                    },
                    child: Text(AppLocalizations.of(context)!.create_video),
                  ),
                ],
              ),
            )
          : VideoGridView(
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
                Text(
                  AppLocalizations.of(context)!
                      .you_have_not_liked_any_videos_yet,
                  style: CustomTextStyle.title2,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const TabScreen(),
                      ),
                    );
                  },
                  child: Text(AppLocalizations.of(context)!.discover_now),
                ),
              ],
            ),
          )
        : VideoGridView(
            videos: videosLiked,
          );
  }
}
