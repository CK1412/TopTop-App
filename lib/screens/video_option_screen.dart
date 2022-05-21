import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toptop_app/functions/functions.dart';
import 'package:toptop_app/providers/state_notifier_providers.dart';
import 'package:toptop_app/screens/tab_screen.dart';

import '../models/video.dart';
import '../providers/providers.dart';
import '../src/constants.dart';

class VideoOptionScreen extends ConsumerWidget {
  const VideoOptionScreen({
    Key? key,
    required this.video,
  }) : super(key: key);

  final Video video;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<bool> _deleteVideo() async {
      final bool isDeleteAction = await showConfirmDialog(
            context: context,
            title: 'Delete?',
            actionName: 'Delete',
          ) ??
          false;

      if (isDeleteAction == false) {
        return isDeleteAction;
      }

      await ref
          .read(videoControllerProvider.notifier)
          .deleteVideo(videoId: video.id);
      showFlushbar(
        context: context,
        message: 'Delete video successfully',
        imageUrl: video.thumbnailUrl,
      );

      await ref.read(storageServiceProvider).deleteFile(
            context,
            folderName: 'videos',
            fileName: video.id,
          );
      await ref.read(storageServiceProvider).deleteFile(
            context,
            folderName: 'video-thumbnails',
            fileName: video.id,
          );
      return isDeleteAction;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          alignment: Alignment.center,
          child: const Text(
            'More',
            style: CustomTextStyle.title3,
          ),
        ),
        Row(
          children: [
            buildTextButton(
              iconData: Icons.download_outlined,
              text: 'Download',
              onPressed: () {},
            ),
            buildTextButton(
              iconData: Icons.delete_outline_rounded,
              text: 'Detete',
              onPressed: () {
                _deleteVideo().then((isDeleteAction) {
                  if (isDeleteAction == true) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const TabScreen(screenIndex: 4),
                      ),
                      ModalRoute.withName('/'),
                    );
                  }
                });
              },
            ),
          ],
        ),
        const Divider(height: 0),
        TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  Widget buildTextButton({
    required IconData iconData,
    required String text,
    required VoidCallback onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: CustomColors.grey.withOpacity(.15),
            foregroundColor: CustomColors.black,
            child: Icon(iconData),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              text,
              style: CustomTextStyle.bodyText2.copyWith(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
