// THEMEDATA
import 'package:flutter/material.dart';

import 'constants.dart';

final ThemeData theme = ThemeData();
final customThemeData = theme.copyWith(
  primaryColor: CustomColors.pink,
  colorScheme: theme.colorScheme
      .copyWith(secondary: CustomColors.blue, primary: CustomColors.pink),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    foregroundColor: CustomColors.black,
    elevation: 0,
    centerTitle: true,
    titleTextStyle:
        CustomTextStyle.title2.copyWith(fontWeight: FontWeight.w500),
  ),
  listTileTheme: const ListTileThemeData(
    iconColor: CustomColors.black,
  ),
);
