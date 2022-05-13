import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:toptop_app/models/comment.dart';
import 'package:toptop_app/models/video.dart';
import 'package:toptop_app/providers/providers.dart';
import 'package:toptop_app/providers/state_notifier_providers.dart';

import '../src/constants.dart';
import '../widgets/common/center_loading_widget.dart';
import '../widgets/common/custom_circle_avatar.dart';
import '../models/user.dart' as user_model;
import 'error_screen.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  const CommentsScreen({Key? key, required this.video}) : super(key: key);

  final Video video;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final _commentController = TextEditingController();
  user_model.User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = ref.read(currentUserProvider);
    ref
        .read(commentControllerProvider.notifier)
        .retrieveCommentsByVideo(widget.video.id);
  }

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  Future addComment() async {
    if (_commentController.text.trim().isEmpty) return;

    final comment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      commentText: _commentController.text.trim(),
      createdDateTime: DateTime.now(),
      userId: currentUser!.id,
      avatarUrl: currentUser!.avatarUrl,
      username: currentUser!.username,
      videoId: widget.video.id,
      userIdLiked: [],
    );

    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    _commentController.text = '';
    await ref.read(commentControllerProvider.notifier).addComment(comment);

    widget.video.increaseCommentCount();

    await ref.read(videoControllerProvider.notifier).updateVideo(
          videoId: widget.video.id,
          videoUpdated: widget.video,
        );
  }

  @override
  Widget build(BuildContext context) {
    final commentsState = ref.watch(commentControllerProvider);

    return commentsState.when(
      data: (comments) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    '${comments!.length} comments',
                    style: CustomTextStyle.title3,
                  ),
                ),
              ),
              const SizedBox(width: 32)
            ],
          ),
          Expanded(
            child: comments.isEmpty
                ? const Center(
                    child: Text('No comment.'),
                  )
                : ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      List _userIdLiked = comments[index].userIdLiked;

                      return Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomCircleAvatar(
                              avatarUrl: comments[index].avatarUrl,
                              radius: 16,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    comments[index].username,
                                    style: CustomTextStyle.title3.copyWith(
                                      color: CustomColors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    comments[index].commentText,
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    DateFormat.Md().format(
                                      comments[index].createdDateTime,
                                    ),
                                    style: CustomTextStyle.title3.copyWith(
                                      color: CustomColors.grey,
                                      fontSize: 12,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            LikeButton(
                              isLiked: _userIdLiked.contains(currentUser!.id),
                              likeCount: _userIdLiked.length,
                              likeCountAnimationType:
                                  LikeCountAnimationType.all,
                              size: 20,
                              countPostion: CountPostion.bottom,
                              bubblesColor: const BubblesColor(
                                dotPrimaryColor: CustomColors.pink,
                                dotSecondaryColor: CustomColors.purple,
                              ),
                              likeCountPadding:
                                  const EdgeInsets.only(top: 4, left: 4),
                              likeBuilder: (bool isLiked) {
                                return isLiked
                                    ? const Icon(
                                        Icons.favorite,
                                        color: CustomColors.pink,
                                      )
                                    : const Icon(
                                        Icons.favorite_outline_outlined,
                                        color: CustomColors.grey,
                                      );
                              },
                              onTap: (isLiked) async {
                                isLiked = !isLiked;

                                if (isLiked) {
                                  _userIdLiked.add(currentUser!.id);
                                } else {
                                  _userIdLiked.remove(currentUser!.id);
                                }

                                ref
                                    .read(commentControllerProvider.notifier)
                                    .updateComment(
                                      commentId: comments[index].id,
                                      commentUpdated: comments[index]
                                          .copyWith(userIdLiked: _userIdLiked),
                                    );

                                return isLiked;
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          const Divider(height: 0),
          Padding(
            padding: EdgeInsets.only(
              left: 10,
              right: 10,
              top: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10,
            ),
            child: Row(
              children: [
                CustomCircleAvatar(
                  avatarUrl: ref.watch(currentUserProvider)!.avatarUrl,
                  radius: 16,
                ),
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment',
                      hintStyle: CustomTextStyle.bodyText2.copyWith(
                        color: CustomColors.grey,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => addComment(),
                  child: const Text('Post'),
                )
              ],
            ),
          ),
        ],
      ),
      error: (e, stackTrace) => ErrorScreen(e, stackTrace),
      loading: () => const CenterLoadingWidget(),
    );
  }
}
