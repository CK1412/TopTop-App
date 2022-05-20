import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toptop_app/providers/providers.dart';
import 'package:toptop_app/providers/state_providers.dart';
import 'package:toptop_app/src/constants.dart';

import '../models/video.dart';
import '../models/user.dart' as user_model;
import '../providers/state_notifier_providers.dart';
import '../widgets/common/center_loading_widget.dart';
import '../widgets/common/custom_circle_avatar.dart';
import 'error_screen.dart';
import 'video_screen.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  late TextEditingController _searchEditingController;
  List<user_model.User> users = [];

  @override
  void initState() {
    super.initState();
    _searchEditingController = TextEditingController();
    ref.read(userServiceProvider).getAllUser().then((value) {
      users = value;
    });
  }

  @override
  void dispose() {
    _searchEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videosState = ref.watch(videoControllerProvider);

    Widget buildContentSearch(List<Video> videos) {
      SearchState result = ref.watch(searchStateProvider);

      switch (result) {
        case SearchState.buildInitData:
          return videos.isEmpty
              ? const SizedBox.shrink()
              : Flexible(
                  child: VideoGridView(videos: videos),
                );
        case SearchState.buildSuggest:
        case SearchState.buildResult:
          final _searchText =
              _searchEditingController.text.trim().toLowerCase();
          final List<Video> resultVideos = _searchText.isEmpty
              ? []
              : videos
                  .where(
                    (video) =>
                        video.caption.toLowerCase().contains(_searchText),
                  )
                  .toList();
          final resultUsers = _searchText.isEmpty
              ? []
              : users
                  .where(
                    (user) =>
                        user.username.toLowerCase().contains(_searchText) &&
                        user.id != ref.read(currentUserProvider)!.id,
                  )
                  .toList();
          return Flexible(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    labelColor: CustomColors.black,
                    unselectedLabelColor: CustomColors.grey,
                    indicatorColor: CustomColors.pink,
                    tabs: [
                      Tab(text: 'Videos'),
                      Tab(text: 'People'),
                    ],
                  ),
                  Flexible(
                    child: TabBarView(
                      children: [
                        resultVideos.isNotEmpty
                            ? VideoGridView(videos: resultVideos)
                            : const Center(
                                child: Text('No matching results were found'),
                              ),
                        resultUsers.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: resultUsers.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: CustomCircleAvatar(
                                      avatarUrl: resultUsers[index].avatarUrl,
                                      radius: 20,
                                    ),
                                    title: Text(resultUsers[index].username),
                                    subtitle: Text(
                                      '${users[index].followers.length} followers',
                                    ),
                                  );
                                },
                              )
                            : const Center(
                                child: Text('No matching results were found'),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        default:
          return const SizedBox.shrink();
      }
    }

    return SafeArea(
      child: Column(
        children: [
          SearchBox(_searchEditingController),
          videosState.when(
            data: (videos) => buildContentSearch(videos),
            error: (e, stackTrace) => ErrorScreen(e, stackTrace),
            loading: () => const CenterLoadingWidget(),
          )
        ],
      ),
    );
  }
}

class VideoGridView extends StatelessWidget {
  final List<Video> videos;

  const VideoGridView({
    Key? key,
    required this.videos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _navigateToVideoScreen(Video video) async {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Scaffold(
            backgroundColor: CustomColors.black,
            body: VideoScreen(video: video),
          ),
        ),
      );
      // if (mounted) {
      //   setState(() {});
      // }
    }

    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        childAspectRatio: 1,
      ),
      itemCount: videos.length > 20 ? 20 : videos.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _navigateToVideoScreen(videos[index]),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: videos[index].thumbnailUrl,
                fit: BoxFit.fitWidth,
                placeholder: (context, url) => Container(
                  color: CustomColors.grey.withOpacity(.3),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SearchBox extends ConsumerStatefulWidget {
  const SearchBox(this.searchEditingController, {Key? key}) : super(key: key);

  final TextEditingController searchEditingController;

  @override
  ConsumerState<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends ConsumerState<SearchBox> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedCrossFade(
            firstChild: const SizedBox(width: 12),
            secondChild: IconButton(
              onPressed: () {
                setState(() {
                  ref.read(searchStateProvider.notifier).state =
                      SearchState.buildInitData;
                  _focusNode.unfocus();
                });
              },
              icon: const Icon(Icons.arrow_back),
            ),
            duration: const Duration(milliseconds: 300),
            crossFadeState: ref.watch(searchStateProvider.notifier).state ==
                    SearchState.buildInitData
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstCurve: Curves.easeInBack,
            secondCurve: Curves.slowMiddle,
          ),
          Flexible(
            child: Focus(
              onFocusChange: (hasFocus) {
                setState(() {
                  debugPrint('Show or hide search button');
                });
              },
              child: TextField(
                controller: widget.searchEditingController,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: 'Search',
                  filled: true,
                  fillColor: CustomColors.grey.withOpacity(.2),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  prefixIcon: const Icon(Icons.search),
                ),
                onTap: () {
                  ref.read(searchStateProvider.notifier).state =
                      SearchState.buildSuggest;
                },
                onSubmitted: (value) {
                  ref.read(searchStateProvider.notifier).state =
                      SearchState.buildResult;
                },
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: 12),
            secondChild: TextButton(
              onPressed: () {
                ref.read(searchStateProvider.notifier).state =
                    SearchState.buildResult;
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              child: Text(
                'Search',
                style: CustomTextStyle.title2.copyWith(
                  color: CustomColors.pink,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            duration: const Duration(milliseconds: 300),
            crossFadeState: _focusNode.hasFocus
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstCurve: Curves.easeInBack,
            secondCurve: Curves.slowMiddle,
          ),
        ],
      ),
    );
  }
}
