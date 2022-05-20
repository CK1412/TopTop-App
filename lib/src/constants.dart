import 'package:flutter/material.dart';

const avatarUrl =
    'https://upload.wikimedia.org/wikipedia/commons/d/d6/IU_for_Chamisul_advertising_campaign_2020_07_%28cropped%29.png';

// COLOR
class CustomColors {
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color grey = Colors.grey;
  static const Color pink = Color(0xffF22E62);
  static const Color blue = Color(0xff0494B5);
  static const Color purple = Color(0xff6F3BFF);
  static const Color red = Colors.red;
}

// ICON PATH
class IconPath {
  static const commentFill = 'assets/icons/comment-fill.svg';
  static const shareFill = 'assets/icons/share-fill.svg';
  static const loaderColor = 'assets/icons/loader-color.svg';
  static const googleColor = 'assets/icons/google-color.svg';
  static const facebookRoundColor = 'assets/icons/facebook-round-color.svg';
  static const chatSquareTextFill = 'assets/icons/chat-square-text-fill.svg';
  static const chatSquareText = 'assets/icons/chat-square-text.svg';
  static const phoneColor = 'assets/icons/phone-color.svg';
  static const flagVNColor = 'assets/icons/flag_vn_color.svg';
  static const avatarPlaceHolder = 'assets/icons/avatar-placeholder.svg';
  static const galleryColor = 'assets/icons/gallery-color.svg';
  static const cameraColor = 'assets/icons/camera-color.svg';
  static const appLogo = 'assets/logos/toptop-logo-light.png';
}

// LOTTIE ANIMATION URL
class LottiePath {
  static const loader = 'assets/lotties/loader_color.json';
  static const music = 'assets/lotties/music.json';
  static const barMusic = 'assets/lotties/bars-music.json';
  static const heartAnimation = 'assets/lotties/heart-animation.json';
  static const videoEditor = 'assets/lotties/video-editor.json';
}

// TEXT STYLE
class CustomTextStyle {
  static const titleLarge = TextStyle(
    color: CustomColors.black,
    fontSize: 26,
    fontWeight: FontWeight.w800,
    letterSpacing: .25,
  );
  static const title1 = TextStyle(
    color: CustomColors.black,
    fontSize: 18,
    fontWeight: FontWeight.w800,
    letterSpacing: .25,
  );
  static const title2 = TextStyle(
    color: CustomColors.black,
    fontSize: 16,
    fontWeight: FontWeight.w800,
    letterSpacing: .25,
  );
  static const title3 = TextStyle(
    color: CustomColors.black,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: .25,
  );
  static const bodyText1 = TextStyle(
    color: CustomColors.black,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: .25,
  );
  static const bodyText2 = TextStyle(
    color: CustomColors.black,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: .25,
  );

  static const errorText = TextStyle(
    color: CustomColors.red,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: .25,
  );
}

enum SearchState {
  buildInitData,
  buildSuggest,
  buildResult,
}
