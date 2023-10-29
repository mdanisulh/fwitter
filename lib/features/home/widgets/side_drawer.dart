import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fwitter/common/common.dart';
import 'package:fwitter/features/auth/controller/auth_controller.dart';
import 'package:fwitter/features/user_profile/controller/user_profile_controller.dart';
import 'package:fwitter/features/user_profile/views/user_profile_view.dart';
import 'package:fwitter/theme/theme.dart';

class SideDrawer extends ConsumerWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return currentUser == null
        ? const Loader()
        : SafeArea(
            child: Drawer(
              backgroundColor: Pallete.black,
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  ListTile(
                    leading: const Icon(Icons.person, size: 30),
                    title: const Text('My Profile', style: TextStyle(fontSize: 22)),
                    onTap: () {
                      Navigator.push(context, UserProfileView.route(currentUser));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.payment, size: 30),
                    title: const Text('Twitter Blue', style: TextStyle(fontSize: 22)),
                    onTap: () {
                      ref.read(userProfileControllerProvider.notifier).updateUserDetails(
                            user: currentUser.copyWith(isTwitterBlue: true),
                            context: context,
                          );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, size: 30),
                    title: const Text('Log Out', style: TextStyle(fontSize: 22)),
                    onTap: () {
                      ref.read(authControllerProvider.notifier).logout(context: context);
                    },
                  ),
                ],
              ),
            ),
          );
  }
}
