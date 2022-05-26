import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toptop_app/providers/future_providers.dart';
import 'package:toptop_app/providers/providers.dart';
import 'package:toptop_app/screens/error_screen.dart';
import 'package:toptop_app/widgets/common/center_loading_widget.dart';
import 'package:toptop_app/widgets/common/custom_circle_avatar.dart';
import 'package:toptop_app/widgets/common/user_interaction_information.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../functions/functions.dart';
import '../providers/state_notifier_providers.dart';
import '../src/constants.dart';
import '../widgets/common/video_grid_view.dart';

class OtherUserProfileScreen extends ConsumerStatefulWidget {
  const OtherUserProfileScreen({Key? key, required this.userId})
      : super(key: key);

  final String userId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OtherUserProfileScreenState();
}

class _OtherUserProfileScreenState
    extends ConsumerState<OtherUserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final userPostedVideoState = ref.watch(userByIdProvider(widget.userId));
    final currentUser = ref.watch(currentUserProvider);
    final videosPostedState =
        ref.watch(videosPostedByUserProvider(widget.userId));

    return userPostedVideoState.when(
      data: (userPostedVideo) {
        Future<void> _followOrUnfollow({
          required bool isFollow,
        }) async {
          if (isFollow) {
            currentUser!.following.add(widget.userId);
            userPostedVideo!.followers.add(currentUser.id);
          } else {
            currentUser!.following.remove(widget.userId);
            userPostedVideo!.followers.remove(currentUser.id);
          }
          setState(() {});

          await ref
              .read(currentUserControllerProvider.notifier)
              .updateUser(id: currentUser.id, userUpdated: currentUser);

          await ref
              .read(userServiceProvider)
              .updateUser(id: widget.userId, userUpdated: userPostedVideo);
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(userPostedVideo!.email),
            centerTitle: true,
          ),
          body: SizedBox.expand(
            child: Column(
              children: [
                CustomCircleAvatar(
                  avatarUrl: userPostedVideo.avatarUrl,
                  radius: MediaQuery.of(context).size.width * .1,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    '@${userPostedVideo.username}',
                    style: CustomTextStyle.title3,
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                  child: UserInteractionInformation(user: userPostedVideo),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedCrossFade(
                        firstChild: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            minimumSize: const Size(160, 44),
                            maximumSize: const Size(240, 44),
                          ),
                          onPressed: () => _followOrUnfollow(isFollow: true),
                          child: Text(AppLocalizations.of(context)!.follow),
                        ),
                        secondChild: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            elevation: 0,
                            minimumSize: const Size(160, 44),
                            maximumSize: const Size(240, 44),
                          ),
                          onPressed: () => _followOrUnfollow(isFollow: false),
                          child: Text(AppLocalizations.of(context)!.unfollow),
                        ),
                        duration: const Duration(milliseconds: 300),
                        crossFadeState:
                            currentUser!.following.contains(widget.userId)
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                      ),
                      const SizedBox(width: 4),
                      OutlinedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          minimumSize: const Size(40, 44),
                        ),
                        onPressed: () {
                          if (userPostedVideo.instagramLink.isEmpty) {
                            showSnackbarMessage(
                              context,
                              AppLocalizations.of(context)!
                                  .this_user_has_not_added_instagram_link_yet,
                            );
                          } else {
                            openUrl(userPostedVideo.instagramLink);
                          }
                        },
                        child: const FaIcon(
                          FontAwesomeIcons.instagram,
                          color: CustomColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                if (userPostedVideo.bio.isNotEmpty)
                  Container(
                    margin:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    alignment: Alignment.center,
                    child: Text(userPostedVideo.bio),
                  ),
                const Divider(),
                Expanded(
                    child: videosPostedState.when(
                  data: (videosPosted) => videosPosted!.isEmpty
                      ? Center(
                          child: Text(
                            AppLocalizations.of(context)!
                                .this_user_has_not_posted_any_videos_yet,
                            style: CustomTextStyle.bodyText1,
                          ),
                        )
                      : VideoGridView(
                          videos: videosPosted,
                        ),
                  error: (error, stackTrace) => ErrorScreen(error, stackTrace),
                  loading: () => const CenterLoadingWidget(
                    backgroundTransparent: false,
                  ),
                )),
              ],
            ),
          ),
        );
      },
      error: (error, stackTrace) => ErrorScreen(error, stackTrace),
      loading: () => const Scaffold(
        body: CenterLoadingWidget(backgroundTransparent: false),
      ),
    );
  }
}
