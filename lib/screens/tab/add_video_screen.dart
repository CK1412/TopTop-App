import 'dart:io';

import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:toptop_app/screens/edit_video_screen.dart';
import 'package:toptop_app/src/constants.dart';
import 'package:toptop_app/src/page_routes.dart';
import 'package:toptop_app/widgets/common/custom_elevate_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../functions/pick_file.dart';

class AddVideoScreen extends StatelessWidget {
  const AddVideoScreen({Key? key}) : super(key: key);

  final limitSize = 1024 * 1024 * 50; // bytes

  Future<void> _pickVideoFromSrc(
    BuildContext context, {
    required ImageSource imageSource,
  }) async {
    final File? videoFile = await pickVideo(imageSource);

    if (videoFile != null) {
      final videoFileSize = await videoFile.length();
      debugPrint(
          '-----------------------------$videoFileSize----------------------------');

      if (videoFileSize > limitSize) {
        FlushbarHelper.createInformation(
          title: AppLocalizations.of(context)!.video_size_is_too_big,
          message: AppLocalizations.of(context)!
              .please_choose_video_less_than_50MB_in_size,
        ).show(context);
      } else {
        Navigator.of(context).push(
          CustomPageRoute(
            child: EditVideoScreen(
              videoFile: videoFile,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              LottiePath.videoEditor,
            ),
            Text(
              '${AppLocalizations.of(context)!.make_a_video_of_your_own_and_share_it_with_everyone}.',
              style: GoogleFonts.lato(
                color: CustomColors.black,
                fontSize: 24,
                fontWeight: FontWeight.w800,
                letterSpacing: .25,
              ),
            ),
            const SizedBox(height: 60),
            CustomElevateButton(
              iconData: Icons.video_library,
              text: AppLocalizations.of(context)!.add_video_from_Gallery,
              backgroundColor: CustomColors.pink,
              foregroundColor: CustomColors.white,
              onPressed: () async => await _pickVideoFromSrc(
                context,
                imageSource: ImageSource.gallery,
              ),
            ),
            CustomElevateButton(
              iconData: Icons.camera_alt,
              text: AppLocalizations.of(context)!.add_video_from_Camera,
              backgroundColor: CustomColors.pink,
              foregroundColor: CustomColors.white,
              onPressed: () async => await _pickVideoFromSrc(
                context,
                imageSource: ImageSource.camera,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
