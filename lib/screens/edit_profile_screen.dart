import 'package:flutter/material.dart';

import '../src/constants.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _bioController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = 'Tran Huy Canh';
    _usernameController.text = 'CK001';
    _bioController.text = 'cdncbkq';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  _saveInfor() async {
    setState(() {});
    _isLoading = true;
    await Future.delayed(const Duration(seconds: 1));
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
                          image: const NetworkImage(
                              'https://scontent.fhan2-4.fna.fbcdn.net/v/t39.30808-6/277556063_2178000099054433_18910963916724021_n.jpg?_nc_cat=1&ccb=1-5&_nc_sid=730e14&_nc_ohc=XdMqOc-RRPQAX-2yn5G&_nc_ht=scontent.fhan2-4.fna&oh=00_AT8H0c9qWfDFPRO95IDHPvDI9UZbCT5Y-AwyMAsDAePwYg&oe=62513819'),
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
                Text(
                  'Name',
                  style: Theme.of(context).textTheme.caption,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      _nameController.text,
                      style: CustomTextStyle.title3,
                    ),
                  ),
                ),
                const Divider(
                  color: CustomColors.grey,
                  height: 26,
                ),
                Text(
                  'Username',
                  style: Theme.of(context).textTheme.caption,
                ),
                GestureDetector(
                  onTap: (() {}),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      _usernameController.text,
                      style: CustomTextStyle.title3,
                    ),
                  ),
                ),
                const Divider(color: CustomColors.grey, height: 26),
                Text(
                  'Bio',
                  style: Theme.of(context).textTheme.caption,
                ),
                GestureDetector(
                  onTap: (() {}),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      '#' + _bioController.text,
                      style: CustomTextStyle.title3,
                    ),
                  ),
                ),
                const Divider(color: CustomColors.grey, height: 26),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
