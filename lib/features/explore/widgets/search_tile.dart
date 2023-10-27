import 'package:flutter/material.dart';
import 'package:fwitter/models/user_model.dart';
import 'package:fwitter/theme/theme.dart';

class SearchTile extends StatelessWidget {
  final UserModel user;
  const SearchTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(user.profilePic),
      ),
      title: Text(
        user.name,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        '@${user.username}',
        style: const TextStyle(fontSize: 16, color: Pallete.grey),
      ),
    );
  }
}
