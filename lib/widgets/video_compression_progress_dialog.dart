import 'package:flutter/material.dart';
import 'package:toptop_app/src/constants.dart';
import 'package:video_compress/video_compress.dart';

class VideoCompressionProgressDialog extends StatefulWidget {
  const VideoCompressionProgressDialog({Key? key}) : super(key: key);

  @override
  State<VideoCompressionProgressDialog> createState() =>
      _VideoCompressionProgressDialogState();
}

class _VideoCompressionProgressDialogState
    extends State<VideoCompressionProgressDialog> {
  late Subscription subscription;
  double? progress;

  @override
  void initState() {
    super.initState();

    subscription = VideoCompress.compressProgress$.subscribe(
      (event) => setState(() {
        progress = event;
      }),
    );
  }

  @override
  void dispose() {
    VideoCompress.cancelCompression();
    subscription.unsubscribe();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final value = progress == null ? progress : (progress! / 100);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Compressing video...',
            style: CustomTextStyle.bodyText1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 12,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              VideoCompress.cancelCompression();
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
