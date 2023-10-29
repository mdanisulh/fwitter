import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fwitter/common/common.dart';
import 'package:fwitter/constants/constants.dart';
import 'package:fwitter/core/enums/tweet_type_enum.dart';
import 'package:fwitter/features/auth/controller/auth_controller.dart';
import 'package:fwitter/features/tweet/controller/tweet_controller.dart';
import 'package:fwitter/features/tweet/views/reply_view.dart';
import 'package:fwitter/features/tweet/widgets/carousel_image.dart';
import 'package:fwitter/features/tweet/widgets/styled_text.dart';
import 'package:fwitter/features/tweet/widgets/tweet_icon_button.dart';
import 'package:fwitter/features/user_profile/views/user_profile_view.dart';
import 'package:fwitter/models/tweet_model.dart';
import 'package:fwitter/models/user_model.dart';
import 'package:fwitter/theme/theme.dart';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:like_button/like_button.dart';
import 'package:timeago/timeago.dart' as timeago;

class TweetCard extends ConsumerWidget {
  final Tweet tweet;

  const TweetCard({super.key, required this.tweet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return ref.watch(userDetailsProvider(tweet.uid)).when(
          data: (tweetAuthor) {
            if (tweetAuthor == null) return const SizedBox();
            ref.watch(getLatestDataProvider).whenData(
              (data) {
                if (data.events.contains('databases.*.collections.${AppwriteConstants.usersCollectionID}.documents.${tweetAuthor!.uid}.update')) {
                  tweetAuthor = UserModel.fromMap(data.payload);
                }
              },
            );
            return currentUser == null || tweetAuthor == null
                ? const SizedBox()
                : Container(
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(width: 1.5, color: Pallete.grey)),
                    ),
                    padding: const EdgeInsets.only(top: 10, bottom: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: GestureDetector(
                            onTap: () => Navigator.push(context, UserProfileView.route(tweetAuthor!)),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(tweetAuthor!.profilePic),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (tweet.retweetedBy.isNotEmpty)
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      AssetsConstants.retweetIcon,
                                      colorFilter: const ColorFilter.mode(Pallete.grey, BlendMode.srcIn),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 5),
                                      child: Text(
                                        'Retweeted by ${tweet.retweetedBy}',
                                        style: const TextStyle(
                                          color: Pallete.grey,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 5),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: RichText(
                                              overflow: TextOverflow.ellipsis,
                                              text: TextSpan(children: [
                                                TextSpan(
                                                  text: tweetAuthor!.name,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: ' @${tweetAuthor!.username}',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Pallete.grey,
                                                  ),
                                                ),
                                              ]),
                                            ),
                                          ),
                                          Text(
                                            timeago.format(tweet.tweetedAt, locale: 'en_short'),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Pallete.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              StyledText(
                                text: tweet.text,
                              ),
                              if (tweet.tweetType == TweetType.image)
                                CarouselImage(
                                  imageLinks: tweet.imageLinks,
                                ),
                              if (tweet.link.isNotEmpty && AnyLinkPreview.isValidLink(tweet.link))
                                Container(
                                  margin: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 20),
                                  child: AnyLinkPreview(
                                    link: tweet.link,
                                    displayDirection: UIDirection.uiDirectionHorizontal,
                                  ),
                                ),
                              Container(
                                margin: const EdgeInsets.only(top: 10, right: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TweetIconButton(
                                      pathname: AssetsConstants.commentIcon,
                                      text: tweet.commentIds.length.toString(),
                                      onTap: () {
                                        Navigator.push(context, ReplyView.route(tweet));
                                      },
                                    ),
                                    TweetIconButton(
                                      pathname: AssetsConstants.retweetIcon,
                                      text: tweet.retweetCount.toString(),
                                      onTap: () {
                                        ref.read(tweetControllerProvider.notifier).retweet(tweet, currentUser, context);
                                      },
                                    ),
                                    LikeButton(
                                      size: 25,
                                      isLiked: tweet.likes.contains(currentUser.uid),
                                      onTap: ((isLiked) async {
                                        ref.read(tweetControllerProvider.notifier).likeTweet(tweet, currentUser);
                                        return !isLiked;
                                      }),
                                      likeBuilder: (isLiked) {
                                        return isLiked
                                            ? SvgPicture.asset(
                                                AssetsConstants.likeFilledIcon,
                                                colorFilter: const ColorFilter.mode(Pallete.red, BlendMode.srcIn),
                                              )
                                            : SvgPicture.asset(
                                                AssetsConstants.likeOutlinedIcon,
                                                colorFilter: const ColorFilter.mode(Pallete.grey, BlendMode.srcIn),
                                              );
                                      },
                                      likeCount: tweet.likes.length,
                                      countBuilder: (likeCount, isLiked, text) {
                                        return Text(
                                          likeCount == 0 ? 'Like' : text,
                                          style: TextStyle(
                                            color: isLiked ? Pallete.red : Pallete.white,
                                            fontSize: 15,
                                            fontWeight: isLiked ? FontWeight.bold : FontWeight.w500,
                                          ),
                                        );
                                      },
                                    ),
                                    TweetIconButton(
                                      pathname: AssetsConstants.viewsIcon,
                                      text: (tweet.likes.length + tweet.retweetCount + tweet.commentIds.length).toString(),
                                      onTap: () {},
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.share_outlined,
                                        size: 25,
                                      ),
                                      color: Pallete.grey,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
          },
          error: (e, st) => ErrorPage(error: e.toString()),
          loading: () => const SizedBox(),
        );
  }
}
