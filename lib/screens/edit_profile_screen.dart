import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toptop_app/functions/pick_file.dart';
import 'package:toptop_app/models/user.dart';
import 'package:toptop_app/providers/providers.dart';
import 'package:toptop_app/providers/state_notifier_providers.dart';

import '../src/constants.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _bioController = TextEditingController();

  late final User currentUser;
  bool _isLoading = false;
  String? avatarPath = '';

  @override
  void initState() {
    super.initState();
    ref.read(userControllerProvider).whenData((user) {
      currentUser = user!;
      _usernameController.text = currentUser.username;
      _emailController.text = currentUser.email;
      _phoneNumberController.text = currentUser.phoneNumber;
      _bioController.text = currentUser.bio;
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _changeImage() async {
    final imagePath = await pickImage(ImageSource.gallery);
    setState(() {
      avatarPath = imagePath;
    });
  }

  Future<void> _saveInfor() async {
    setState(() {
      _isLoading = true;
    });

    if (avatarPath!.isNotEmpty) {
      await ref.read(storageServiceProvider).uploadFile(
            context,
            folderName: 'user-avatar',
            filePath: avatarPath!,
            fileName: currentUser.id,
          );

      final String avatarUrl =
          await ref.read(storageServiceProvider).getDownloadUrl(
                folder: 'user-avatar',
                fileName: currentUser.id,
              );

      await ref.read(userControllerProvider.notifier).updateUser(
            id: currentUser.id,
            userUpdated: currentUser.copyWith(
              username: _usernameController.text.trim(),
              bio: _bioController.text.trim(),
              avatarUrl: avatarUrl,
            ),
          );
    } else {
      await ref.read(userControllerProvider.notifier).updateUser(
            id: currentUser.id,
            userUpdated: currentUser.copyWith(
              username: _usernameController.text.trim(),
              bio: _bioController.text.trim(),
            ),
          );
    }

    setState(() {
      _isLoading = false;
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit profile'),
        actions: [
          _isLoading
              ? Container(
                  width: 34,
                  padding: const EdgeInsets.only(right: 18),
                  child: const FittedBox(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : IconButton(
                  onPressed: _saveInfor,
                  icon: const Icon(
                    Icons.check,
                    color: CustomColors.pink,
                  ),
                )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildAvatar(screenSize),
                Container(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 20),
                  alignment: Alignment.center,
                  child: Text(
                    'Change profile photo',
                    style: CustomTextStyle.bodyText2
                        .copyWith(color: CustomColors.black.withOpacity(.6)),
                  ),
                ),
                InformationField(
                  title: 'Username',
                  controller: _usernameController,
                ),
                InformationField(
                  title: 'Email',
                  controller: _emailController,
                  enabled: false,
                ),
                InformationField(
                  title: 'Phone number',
                  controller: _phoneNumberController,
                  enabled: false,
                ),
                InformationField(
                  title: 'Bio',
                  controller: _bioController,
                  lengthLimit: 100,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row buildAvatar(Size screenSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            // image: DecorationImage(
            //   image: const NetworkImage(avatarUrl),
            //   fit: BoxFit.cover,
            //   colorFilter: ColorFilter.mode(
            //     Colors.black.withOpacity(0.4),
            //     BlendMode.srcOver,
            //   ),
            // ),
            shape: BoxShape.circle,
          ),
          width: screenSize.width * .2,
          height: screenSize.width * .2,
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              avatarPath!.isNotEmpty
                  ? Image.file(
                      File(avatarPath!),
                      fit: BoxFit.cover,
                      colorBlendMode: BlendMode.srcOver,
                      color: CustomColors.black.withOpacity(.4),
                    )
                  : Image.network(
                      currentUser.avatarUrl,
                      fit: BoxFit.cover,
                      colorBlendMode: BlendMode.srcOver,
                      color: CustomColors.black.withOpacity(.4),
                    ),
              IconButton(
                onPressed: _changeImage,
                icon: const Icon(
                  Icons.camera_alt_outlined,
                  color: CustomColors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class InformationField extends StatelessWidget {
  const InformationField({
    Key? key,
    required this.title,
    required this.controller,
    this.enabled = true,
    this.lengthLimit = 30,
  }) : super(key: key);

  final String title;
  final TextEditingController controller;
  final bool enabled;
  final int lengthLimit;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: title,
        hintText: controller.text,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      inputFormatters: [
        LengthLimitingTextInputFormatter(lengthLimit),
      ],
    );
  }
}
