import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toptop_app/screens/video_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../providers/providers.dart';
import '../providers/state_notifier_providers.dart';
import '../screens/error_screen.dart';
import '../widgets/common/center_loading_widget.dart';

class VideosScreen extends ConsumerWidget {
  const VideosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videosState = ref.watch(videoControllerProvider);

    Future<void> _refreshData() async {
      await ref.read(videoControllerProvider.notifier).retrieveVideos();
    }

    return videosState.when(
      data: (videos) {
        ref.refresh(currentUserProvider);

        return RefreshIndicator(
          onRefresh: _refreshData,
          child: videos.isNotEmpty
              ? PageView.builder(
                  itemCount: videos.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) => VideoScreen(
                    video: videos[index],
                  ),
                )
              : Center(
                  child: Text(
                    AppLocalizations.of(context)!.video_list_is_empty,
                  ),
                ),
        );
      },
      error: (e, stackTrace) => ErrorScreen(e, stackTrace),
      loading: () => const CenterLoadingWidget(),
    );
  }
}
