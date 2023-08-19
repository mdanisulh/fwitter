import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fwitter/constants/constants.dart';

class UIConstants {
  static AppBar appBar() {
    return AppBar(
      centerTitle: true,
      title: SvgPicture.asset(
        AssetsConstants.twitterLogo,
        height: 25,
      ),
    );
  }
}
