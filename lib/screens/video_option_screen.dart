import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toptop_app/functions/functions.dart';
import 'package:toptop_app/providers/state_notifier_providers.dart';
import 'package:toptop_app/screens/tab/tab_screen.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/video.dart';
import '../providers/providers.dart';
import '../src/constants.dart';
import '../utils/custom_exception.dart';
import '../utils/custom_flushbar.dart';

class VideoOptionScreen extends ConsumerStatefulWidget {
  const VideoOptionScreen({
    Key? key,
    required this.video,
  }) : super(key: key);

  final Video video;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VideoOptionScreenState();
}

class _VideoOptionScreenState extends ConsumerState<VideoOptionScreen> {
  late Video video;

  bool _enableDownloadButton = true;

  @override
  void initState() {
    super.initState();
    video = widget.video;
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _deleteVideo() async {
      final bool isDeleteAction = await showConfirmDialog(
            context: context,
            title: '${AppLocalizations.of(context)!.delete}?',
            actionName: AppLocalizations.of(context)!.delete,
          ) ??
          false;

      if (isDeleteAction == false) {
        return isDeleteAction;
      }

      await ref
          .read(videoControllerProvider.notifier)
          .deleteVideo(videoId: widget.video.id);

      flushbarMessage(
        context: context,
        title: AppLocalizations.of(context)!.message,
        message: AppLocalizations.of(context)!.delete_video_successfully,
        imageUrl: video.thumbnailUrl,
      ).show(context);

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

    Future<void> downloadVideoToGallery() async {
      final tempDir = await getTemporaryDirectory();
      final path = '${tempDir.path}/${video.id}.${video.fileFormat}';

      try {
        setState(() {
          _enableDownloadButton = false;
        });
        var _flushbarProgress = flushbarProgress(
          title: '${AppLocalizations.of(context)!.please_wait_a_moment}!',
          message: '${AppLocalizations.of(context)!.video_is_downloading}...',
          linearProgressIndicator: const LinearProgressIndicator(),
          duration: const Duration(seconds: 10),
        );
        _flushbarProgress.show(context);

        await Dio().download(
          video.videoUrl,
          path,
          onReceiveProgress: (received, total) {
            if (received == total) {
              setState(() {
                _enableDownloadButton = true;
                _flushbarProgress.dismiss();
              });
            }
          },
        );

        debugPrint('Path video: $path');

        final isSuccess = await GallerySaver.saveVideo(path, toDcim: true);

        if (isSuccess == true) {
          flushbarMessage(
            context: context,
            title: AppLocalizations.of(context)!.message,
            message: AppLocalizations.of(context)!.video_is_saved_to_Gallery,
            imageUrl: video.thumbnailUrl,
          ).show(context);
        }
      } catch (e) {
        debugPrint(e.toString());
        throw CustomException(message: e.toString());
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          alignment: Alignment.center,
          child: Text(
            AppLocalizations.of(context)!.more,
            style: CustomTextStyle.title3,
          ),
        ),
        Row(
          children: [
            buildIconTextButton(
              iconData: FontAwesomeIcons.download,
              text: AppLocalizations.of(context)!.download,
              onPressed:
                  _enableDownloadButton ? () => downloadVideoToGallery() : null,
            ),
            buildIconTextButton(
              iconData: FontAwesomeIcons.trashCan,
              text: AppLocalizations.of(context)!.delete,
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
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
      ],
    );
  }

  Widget buildIconTextButton({
    required IconData iconData,
    required String text,
    required VoidCallback? onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: CustomColors.grey.withOpacity(.15),
            foregroundColor: CustomColors.black,
            child: FaIcon(
              iconData,
              size: 18,
            ),
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
