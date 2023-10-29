import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fwitter/common/common.dart';
import 'package:fwitter/constants/constants.dart';
import 'package:fwitter/features/tweet/controller/tweet_controller.dart';
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
    UserModel user = this.user;
    return Scaffold(
      body: ref.watch(getLatestDataProvider).when(
            data: (data) {
              if (data.events.contains(
                'databases.*.collections.${AppwriteConstants.usersCollectionID}.documents.${user.uid}.update',
              )) {
                user = UserModel.fromMap(data.payload);
                return UserProfile(user: user);
              }
              return UserProfile(user: user);
            },
            loading: () => UserProfile(user: user),
            error: (error, stackTrace) => ErrorText(error: error.toString()),
          ),
    );
  }
}
