import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fwitter/constants/constants.dart';
import 'package:fwitter/features/user_profile/views/user_profile_view.dart';
import 'package:fwitter/models/user_model.dart';
import 'package:fwitter/theme/theme.dart';

class SearchTile extends StatelessWidget {
  final UserModel user;
  const SearchTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(context, UserProfileView.route(user));
      },
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(user.profilePic),
      ),
      title: Row(
        children: [
          Text(user.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          if (user.isTwitterBlue)
            Padding(
              padding: const EdgeInsets.only(left: 3),
              child: SvgPicture.asset(AssetsConstants.verifiedIcon, height: 20, width: 20),
            ),
        ],
      ),
      subtitle: Text(
        '@${user.username}',
        style: const TextStyle(fontSize: 16, color: Pallete.grey),
      ),
    );
  }
}
