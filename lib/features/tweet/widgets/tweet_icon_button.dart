import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fwitter/theme/theme.dart';

class TweetIconButton extends StatelessWidget {
  final String pathname;
  final String text;
  final VoidCallback onTap;

  const TweetIconButton({
    super.key,
    required this.pathname,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          SvgPicture.asset(
            pathname,
            colorFilter: const ColorFilter.mode(Pallete.grey, BlendMode.srcIn),
            height: 25,
            width: 25,
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
