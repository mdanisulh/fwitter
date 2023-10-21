import 'package:flutter/material.dart';
import 'package:fwitter/theme/theme.dart';

class StyledText extends StatelessWidget {
  final String text;
  const StyledText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textSpans = [];
    text.split('\n').join(' ').split(' ').forEach((element) {
      if (element.startsWith('#') || element.startsWith('www.') || element.startsWith('http://') || element.startsWith('https://')) {
        textSpans.add(
          TextSpan(
            text: '$element ',
            style: const TextStyle(
              color: Pallete.blue,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      } else {
        textSpans.add(TextSpan(text: '$element '));
      }
    });
    return RichText(
      text: TextSpan(
        children: textSpans,
      ),
    );
  }
}
