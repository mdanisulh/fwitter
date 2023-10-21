import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fwitter/constants/constants.dart';
import 'package:fwitter/features/tweet/widgets/tweet_list.dart';

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

  static const List<Widget> bottomTabBarPages = [
    TweetList(),
    Text('Search'),
    Text('Notifications'),
    Text('Messages'),
  ];
}
