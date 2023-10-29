import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fwitter/common/common.dart';
import 'package:fwitter/features/auth/controller/auth_controller.dart';
import 'package:fwitter/features/tweet/widgets/tweet_card.dart';
import 'package:fwitter/features/user_profile/controller/user_profile_controller.dart';
import 'package:fwitter/features/user_profile/views/edit_profile_view.dart';
import 'package:fwitter/models/user_model.dart';
import 'package:fwitter/theme/theme.dart';

class UserProfile extends ConsumerWidget {
  final UserModel user;

  const UserProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return currentUser == null
        ? const Loader()
        : NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 200,
                  floating: true,
                  pinned: true,
                  snap: true,
                  flexibleSpace: SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 150,
                          child: user.bannerPic.isEmpty
                              ? Container(
                                  color: Pallete.blue,
                                )
                              : SizedBox(
                                  width: double.infinity,
                                  child: Image.network(
                                    user.bannerPic,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                        ),
                        Positioned(
                          top: 90,
                          bottom: 0,
                          left: 10,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Pallete.black,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(user.profilePic),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          right: 20,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, EditProfileView.route());
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Pallete.black),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: const BorderSide(color: Pallete.white, width: 2),
                                ),
                              ),
                            ),
                            child: Text(
                              user.uid == currentUser.uid ? 'Edit Profile' : 'Follow',
                              style: const TextStyle(color: Pallete.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(10),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Text(user.name, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                        Text('@${user.username}', style: const TextStyle(fontSize: 18, color: Pallete.grey)),
                        const SizedBox(height: 10),
                        Text(user.bio, style: const TextStyle(color: Pallete.white, fontSize: 16)),
                        const SizedBox(height: 10),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(text: user.following.length.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              const TextSpan(text: '\t\tFollowing', style: TextStyle(fontSize: 16, color: Pallete.grey)),
                              const WidgetSpan(child: SizedBox(width: 20)),
                              TextSpan(text: user.followers.length.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              const TextSpan(text: '\t\tFollowers', style: TextStyle(fontSize: 16, color: Pallete.grey)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Divider(color: Pallete.white),
                      ],
                    ),
                  ),
                )
              ];
            },
            body: ref.watch(getUserTweetsProvider(user.uid)).when(
                  data: (tweets) {
                    return ListView.builder(
                      itemCount: tweets.length,
                      itemBuilder: (context, index) {
                        final tweet = tweets[index];
                        if (tweet.retweetedBy.isNotEmpty) return const SizedBox();
                        return TweetCard(tweet: tweet);
                      },
                    );
                  },
                  error: (e, st) => ErrorPage(error: e.toString()),
                  loading: () => const Loader(),
                ),
          );
  }
}