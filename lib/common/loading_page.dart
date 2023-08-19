import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fwitter/constants/constants.dart';
import 'package:fwitter/theme/theme.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Center(
          child: SizedBox(
            height: 75,
            width: 75,
            child: CircularProgressIndicator(color: Pallete.white),
          ),
        ),
        Center(
            child: SvgPicture.asset(
          AssetsConstants.twitterLogo,
          height: 40,
        )),
      ],
    );
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Loader());
  }
}
