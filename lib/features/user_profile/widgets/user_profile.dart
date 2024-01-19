import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fwitter/common/common.dart';
import 'package:fwitter/constants/constants.dart';
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
    bool isFollowing = currentUser?.following.contains(user.uid) ?? false;
    if (currentUser?.uid == user.uid) isFollowing = true;
    bool isFollower = currentUser?.followers.contains(user.uid) ?? false;
    return currentUser == null
        ? const Loader()
        : Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: NestedScrollView(
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
                                  if (currentUser.uid == user.uid) {
                                    Navigator.push(context, EditProfileView.route());
                                  } else {
                                    ref.read(userProfileControllerProvider.notifier).followUser(
                                          user: user,
                                          currentUser: currentUser,
                                          context: context,
                                        );
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(isFollowing ? Pallete.black : Pallete.white),
                                  shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: const BorderSide(color: Pallete.white, width: 1.5),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  user.uid == currentUser.uid
                                      ? 'Edit Profile'
                                      : isFollowing
                                          ? 'Following'
                                          : 'Follow',
                                  style: TextStyle(color: isFollowing ? Pallete.white : Pallete.black, fontSize: 18, fontWeight: FontWeight.bold),
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
                            Row(
                              children: [
                                Text(user.name, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                                if (user.isTwitterBlue)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 3),
                                    child: SvgPicture.asset(AssetsConstants.verifiedIcon, height: 20, width: 20),
                                  ),
                              ],
                            ),
                            Row(
                              children: [
                                Text('@${user.username}', style: const TextStyle(fontSize: 18, color: Pallete.grey)),
                                const SizedBox(width: 10),
                                if (isFollower) const Text('Follows you', style: TextStyle(color: Pallete.grey, fontSize: 16)),
                              ],
                            ),
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
              ),
            ),
          );
  }
}
