import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toptop_app/models/user.dart';
import 'package:toptop_app/providers/state.dart';

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

  @override
  void initState() {
    super.initState();
    currentUser = ref.read(getUserProvider(currentUser.id)).value!;
    _usernameController.text = currentUser.username;
    _emailController.text = currentUser.email;
    _phoneNumberController.text = currentUser.phoneNumber;
    _bioController.text = currentUser.bio;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  _saveInfor() async {
    setState(() {});
    _isLoading = true;
    await Future.delayed(const Duration(seconds: 1));
    await ref.read(userProvider).update(
          id: currentUser.id,
          userUpdated: currentUser.copyWith(
            username: _usernameController.text.trim(),
            bio: _bioController.text.trim(),
          ),
        );
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: const NetworkImage(avatarUrl),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.4),
                            BlendMode.srcOver,
                          ),
                        ),
                        shape: BoxShape.circle,
                      ),
                      width: screenSize.width * .2,
                      height: screenSize.width * .2,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.camera_alt_outlined,
                          color: CustomColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InformationField extends StatelessWidget {
  const InformationField({
    Key? key,
    required this.title,
    required this.controller,
    this.enabled = true,
  }) : super(key: key);

  final String title;
  final TextEditingController controller;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        hintText: controller.text,
        labelText: title,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
