import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../src/constants.dart';

class CustomElevateButton extends StatelessWidget {
  const CustomElevateButton({
    Key? key,
    required this.iconPath,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  final String iconPath;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 10,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          primary: CustomColors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              child: Align(
                alignment: Alignment.centerRight,
                child: SvgPicture.asset(iconPath, height: 34),
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              flex: 7,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  text,
                  style: CustomTextStyle.title2.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
          ],
        ),
        onPressed: onPressed,
      ),
    );
  }
}
