import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toptop_app/screens/video_screen.dart';

import '../providers/state_notifier_providers.dart';
import '../screens/error_screen.dart';
import '../widgets/common/center_loading_widget.dart';

class VideosScreen extends ConsumerWidget {
  const VideosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videosState = ref.watch(videoControllerProvider);

    _refreshData() async {
      await ref.read(videoControllerProvider.notifier).retrieveVideos();
      ref.refresh(videoControllerProvider.future);
    }

    return videosState.when(
      data: (videos) => RefreshIndicator(
        onRefresh: _refreshData,
        child: PageView.builder(
          itemCount: videos.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) => VideoScreen(
            video: videos[index],
          ),
        ),
      ),
      error: (e, stackTrace) => ErrorScreen(e, stackTrace),
      loading: () => const CenterLoadingWidget(),
    );
  }
}
