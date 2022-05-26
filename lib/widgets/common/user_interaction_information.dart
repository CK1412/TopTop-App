import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/user.dart' as user_model;
import '../../providers/state_providers.dart';
import '../../src/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                Text(
                  AppLocalizations.of(context)!.following,
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
                Text(
                  AppLocalizations.of(context)!.followers,
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
                Text(
                  AppLocalizations.of(context)!.likes,
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
