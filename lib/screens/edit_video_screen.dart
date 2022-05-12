import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toptop_app/functions/functions.dart';
import 'package:toptop_app/models/video.dart';
import 'package:toptop_app/providers/providers.dart';
import 'package:toptop_app/providers/state_notifier_providers.dart';
import 'package:toptop_app/widgets/common/center_loading_widget.dart';
import 'package:video_player/video_player.dart';

import '../src/constants.dart';
import '../widgets/video_compression_progress_dialog.dart';

class EditVideoScreen extends ConsumerStatefulWidget {
  const EditVideoScreen({Key? key, required this.videoFile}) : super(key: key);

  final File videoFile;

  @override
  ConsumerState<EditVideoScreen> createState() => _EditVideoScreenState();
}

class _EditVideoScreenState extends ConsumerState<EditVideoScreen> {
  late VideoPlayerController _videoController;
  late TextEditingController _captionController;
  late TextEditingController _songNameController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _captionController = TextEditingController();
    _songNameController = TextEditingController();
    _videoController = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) => setState(() {
            // necessary
          }))
      ..play()
      ..setVolume(1)
      ..setLooping(true);
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.dispose();
    _captionController.dispose();
    _songNameController.dispose();
  }

  _postVideo() async {
    FocusScope.of(context).unfocus();

    final songName = _songNameController.text.trim().isNotEmpty
        ? _songNameController.text.trim()
        : 'Unknown';
    final caption = _captionController.text.trim();

    final videoId = DateTime.now().millisecondsSinceEpoch.toString();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Dialog(
        child: VideoCompressionProgressDialog(),
      ),
    );

    final compressedFileInfor = await compressVideo(widget.videoFile);

    //* closed dialog when compressed
    Navigator.of(context).pop();

    setState(() {
      _isLoading = !_isLoading;
    });

    if (compressedFileInfor == null) return;

    ref.read(userControllerProvider).whenData((user) async {
      await ref.read(storageServiceProvider).uploadFile(
            context,
            folderName: 'videos',
            filePath: compressedFileInfor.path!,
            fileName: videoId,
          );

      final videoUrl = await ref
          .read(storageServiceProvider)
          .getDownloadUrl(folder: 'videos', fileName: videoId);

      await ref.read(videoControllerProvider.notifier).addVideo(
            Video(
              id: videoId,
              songName: songName,
              videoUrl: videoUrl,
              userId: user!.id,
              username: user.username,
              caption: caption,
              userAvatarUrl: user.avatarUrl,
              userIdLiked: [],
            ),
          );
      setState(() {
        _isLoading = !_isLoading;
        Navigator.of(context).pop();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _videoController.value.isInitialized
          ? SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                    constraints: const BoxConstraints(
                      maxHeight: 600,
                      maxWidth: 600,
                    ),
                    child: VideoPlayer(_videoController),
                  ),
                  SizedBox(
                    height: 5,
                    child: VideoProgressIndicator(
                      _videoController,
                      allowScrubbing: true,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  _buildVideoControlBar(),
                  _buildInputFields(),
                  const SizedBox(height: 12),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _postVideo,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 10,
                            ),
                            shape: const StadiumBorder(),
                          ),
                          child: Text(
                            'Post video',
                            style: CustomTextStyle.title2.copyWith(
                              color: CustomColors.white,
                            ),
                          ),
                        ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            )
          : const CenterLoadingWidget(),
    );
  }

  _buildInputFields() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        left: 12,
        right: 12,
      ),
      child: Column(
        children: [
          CustomTextField(
            controller: _songNameController,
            label: 'Song name',
            limitText: 40,
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: _captionController,
            label: 'Caption for video',
            limitText: 150,
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
    );
  }

  Future _rewindSeconds(int seconds) async {
    final currentPosition = await _videoController.position;
    _videoController.seekTo(currentPosition! - Duration(seconds: seconds));
  }

  Future _forwardSeconds(int seconds) async {
    final currentPosition = await _videoController.position;
    _videoController.seekTo(currentPosition! + Duration(seconds: seconds));
  }

  Future _toggleState() async {
    if (_videoController.value.isPlaying) {
      await _videoController.pause();
    } else {
      await _videoController.play();
    }
    setState(() {});
  }

  _buildVideoControlBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => _rewindSeconds(3),
          icon: const Icon(Icons.skip_previous_rounded),
          iconSize: 40,
          color: CustomColors.pink,
        ),
        IconButton(
          onPressed: () => _toggleState(),
          icon: Icon(
            _videoController.value.isPlaying
                ? Icons.pause_circle_rounded
                : Icons.play_circle_fill_rounded,
          ),
          iconSize:
              40, //* use iconSize to fix eccentric when increasing size Iconbutton instead of using size in the Icon
          color: CustomColors.pink,
        ),
        IconButton(
          onPressed: () => _forwardSeconds(3),
          icon: const Icon(Icons.skip_next_rounded),
          iconSize: 40,
          color: CustomColors.pink,
        ),
      ],
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.limitText,
    this.textInputAction = TextInputAction.next,
    this.borderColor = CustomColors.pink,
  }) : super(key: key);

  final TextEditingController controller;
  final String label;
  final int limitText;
  final TextInputAction textInputAction;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: borderColor),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      inputFormatters: [
        LengthLimitingTextInputFormatter(limitText),
      ],
      textInputAction: textInputAction,
      maxLines: null,
    );
  }
}
