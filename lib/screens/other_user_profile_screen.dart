import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toptop_app/providers/future_providers.dart';
import 'package:toptop_app/screens/error_screen.dart';
import 'package:toptop_app/widgets/common/center_loading_widget.dart';
import 'package:toptop_app/widgets/common/custom_circle_avatar.dart';
import 'package:toptop_app/widgets/common/user_interaction_information.dart';

import '../src/constants.dart';

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
  bool _isFollowed = false;

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userByIdProvider(widget.userId));
    return userState.when(
      data: (user) => Scaffold(
        appBar: AppBar(
          title: Text(user!.email),
          centerTitle: true,
        ),
        body: SizedBox.expand(
          child: Column(
            children: [
              CustomCircleAvatar(
                avatarUrl: user.avatarUrl,
                radius: MediaQuery.of(context).size.width * .1,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  '@${user.username}',
                  style: CustomTextStyle.title3,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                child: UserInteractionInformation(user: user),
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
                        onPressed: () {
                          setState(() {
                            _isFollowed = !_isFollowed;
                          });
                        },
                        child: const Text('Follow'),
                      ),
                      secondChild: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          elevation: 0,
                          minimumSize: const Size(160, 44),
                          maximumSize: const Size(240, 44),
                        ),
                        onPressed: () {
                          setState(() {
                            _isFollowed = !_isFollowed;
                          });
                        },
                        child: const Text('Unfollow'),
                      ),
                      duration: const Duration(milliseconds: 300),
                      crossFadeState: _isFollowed
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                    ),
                    const SizedBox(width: 4),
                    OutlinedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        minimumSize: const Size(40, 44),
                      ),
                      onPressed: () {},
                      child: const FaIcon(
                        FontAwesomeIcons.instagram,
                        color: CustomColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      error: (error, stackTrace) => ErrorScreen(error, stackTrace),
      loading: () => const CenterLoadingWidget(
        backgroundTransparent: false,
      ),
    );
  }
}
