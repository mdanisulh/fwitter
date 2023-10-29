import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fwitter/features/user_profile/widgets/user_profile.dart';
import 'package:fwitter/models/user_model.dart';

class UserProfileView extends ConsumerWidget {
  static route(UserModel user) => MaterialPageRoute(
        builder: (context) => UserProfileView(user: user),
      );

  final UserModel user;

  const UserProfileView({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: UserProfile(user: user),
    );
  }
}
