import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../src/constants.dart';

class CustomElevateButton extends StatelessWidget {
  const CustomElevateButton({
    Key? key,
    this.iconPath = '',
    this.iconData,
    required this.text,
    required this.onPressed,
    this.backgroundColor = CustomColors.white,
    this.foregroundColor = CustomColors.black,
  }) : super(key: key);

  final String iconPath;
  final IconData? iconData;
  final String text;
  final Color backgroundColor;
  final Color foregroundColor;
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
            side: const BorderSide(
              color: CustomColors.greyLight,
            ),
          ),
          primary: backgroundColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              child: Align(
                alignment: Alignment.centerRight,
                child: (iconPath.isNotEmpty)
                    ? SvgPicture.asset(iconPath, height: 34)
                    : Icon(iconData, size: 28),
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
                    color: foregroundColor,
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
