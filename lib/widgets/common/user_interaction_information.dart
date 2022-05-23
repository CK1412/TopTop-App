import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/user.dart' as user_model;
import '../../providers/state_providers.dart';
import '../../src/constants.dart';

class UserInteractionInformation extends ConsumerWidget {
  const UserInteractionInformation({
    Key? key,
    required this.user,
  }) : super(key: key);

  final user_model.User? user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Flexible(
          child: Center(
            child: Column(
              children: [
                Text(
                  user!.following.length.toString(),
                  style: CustomTextStyle.title1,
                ),
                const Text(
                  'Following',
                  style: CustomTextStyle.bodyText2,
                ),
              ],
            ),
          ),
        ),
        Flexible(
          child: Center(
            child: Column(
              children: [
                Text(
                  user!.followers.length.toString(),
                  style: CustomTextStyle.title1,
                ),
                const Text(
                  'Follower',
                  style: CustomTextStyle.bodyText2,
                ),
              ],
            ),
          ),
        ),
        Flexible(
          child: Center(
            child: Column(
              children: [
                Text(
                  ref
                      .watch(totalLikeVideosPostedByUserProvider(user!.id))
                      .toString(),
                  style: CustomTextStyle.title1,
                ),
                const Text(
                  'Likes',
                  style: CustomTextStyle.bodyText2,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
