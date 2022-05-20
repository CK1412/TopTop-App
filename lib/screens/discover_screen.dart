import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toptop_app/src/constants.dart';

import '../models/video.dart';
import '../providers/state_notifier_providers.dart';
import '../widgets/common/center_loading_widget.dart';
import 'error_screen.dart';
import 'video_screen.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  @override
  Widget build(BuildContext context) {
    final videosState = ref.watch(videoControllerProvider);

    void _navigateToVideoScreen(Video video) async {
      await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: CustomColors.black,
          body: VideoScreen(video: video),
        ),
      ));
      if (mounted) {
        setState(() {});
      }
    }

    return SafeArea(
      child: Column(
        children: [
          const SearchBox(),
          videosState.when(
            data: (videos) {
              return videos.isEmpty
                  ? const SizedBox.shrink()
                  : Flexible(
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                          childAspectRatio: 1,
                        ),
                        itemCount: videos.length,
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
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
            },
            error: (e, stackTrace) => ErrorScreen(e, stackTrace),
            loading: () => const CenterLoadingWidget(),
          )
        ],
      ),
    );
  }
}

class SearchBox extends StatefulWidget {
  const SearchBox({Key? key}) : super(key: key);

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  late TextEditingController _searchEditingController;

  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _searchEditingController = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, top: 12, bottom: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Focus(
              onFocusChange: (hasFocus) {
                setState(() {
                  debugPrint('Show or hide search button');
                });
              },
              child: TextField(
                controller: _searchEditingController,
                focusNode: _focusNode,
                decoration: InputDecoration(
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
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: 12),
            secondChild: TextButton(
              onPressed: () {},
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
