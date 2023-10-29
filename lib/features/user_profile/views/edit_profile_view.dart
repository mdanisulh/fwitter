import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fwitter/common/common.dart';
import 'package:fwitter/core/core.dart';
import 'package:fwitter/features/auth/controller/auth_controller.dart';
import 'package:fwitter/theme/theme.dart';

class EditProfileView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const EditProfileView());
  const EditProfileView({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  final nameEditingController = TextEditingController();
  final usernameEditingController = TextEditingController();
  final bioEditingController = TextEditingController();
  File? profilePic;
  File? bannerPic;

  @override
  void dispose() {
    super.dispose();
    nameEditingController.dispose();
    usernameEditingController.dispose();
    bioEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserDetailsProvider).value;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: () {},
            style: ButtonStyle(padding: MaterialStateProperty.all(const EdgeInsets.only(right: 25))),
            child: const Text(
              'Save',
              style: TextStyle(color: Pallete.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: user == null
          ? const Loader()
          : Column(
              children: [
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 150,
                        child: GestureDetector(
                          onTap: () {
                            pickImage().then((value) => setState(() {
                                  bannerPic = value;
                                }));
                          },
                          child: user.bannerPic.isEmpty && bannerPic == null
                              ? Container(color: Pallete.blue)
                              : SizedBox(
                                  width: double.infinity,
                                  child: bannerPic == null
                                      ? Image.network(
                                          user.bannerPic,
                                          fit: BoxFit.fill,
                                        )
                                      : Image.file(
                                          bannerPic!,
                                          fit: BoxFit.fill,
                                        ),
                                ),
                        ),
                      ),
                      Positioned(
                        top: 90,
                        bottom: 0,
                        left: 20,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Pallete.black,
                          child: GestureDetector(
                            onTap: () {
                              pickImage().then((value) => setState(() {
                                    profilePic = value;
                                  }));
                            },
                            child: profilePic == null
                                ? CircleAvatar(
                                    radius: 50,
                                    backgroundImage: NetworkImage(user.profilePic),
                                  )
                                : CircleAvatar(
                                    radius: 50,
                                    backgroundImage: FileImage(profilePic!, scale: 100),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextField(
                    controller: nameEditingController,
                    style: const TextStyle(fontSize: 25),
                    decoration: const InputDecoration(
                      hintText: 'Name cannot be empty',
                      hintStyle: TextStyle(fontSize: 16),
                      contentPadding: EdgeInsets.all(10),
                      labelText: 'Name',
                      labelStyle: TextStyle(color: Pallete.grey, fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextField(
                    controller: usernameEditingController,
                    style: const TextStyle(fontSize: 25),
                    decoration: const InputDecoration(
                      hintText: 'Username cannot be empty',
                      hintStyle: TextStyle(fontSize: 16),
                      contentPadding: EdgeInsets.all(10),
                      labelText: 'Username',
                      labelStyle: TextStyle(color: Pallete.grey, fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextField(
                    controller: bioEditingController,
                    style: const TextStyle(fontSize: 20),
                    maxLines: 10,
                    decoration: const InputDecoration(
                      hintText: 'Tell something about yourself!',
                      hintStyle: TextStyle(fontSize: 16),
                      contentPadding: EdgeInsets.all(10),
                      labelText: 'Bio',
                      labelStyle: TextStyle(color: Pallete.grey, fontSize: 25, fontWeight: FontWeight.bold),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
