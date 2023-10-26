import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fwitter/common/common.dart';
import 'package:fwitter/constants/constants.dart';
import 'package:fwitter/features/tweet/controller/tweet_controller.dart';
import 'package:fwitter/features/tweet/widgets/tweet_card.dart';
import 'package:fwitter/models/tweet_model.dart';

class TweetList extends ConsumerWidget {
  const TweetList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getTweetsProvider).when(
          data: (tweets) {
            return ref.watch(getLatestTweetProvider).when(
                  data: (data) {
                    final tweet = Tweet.fromMap(data.payload);
                    if (tweet.repliedTo.isEmpty) {
                      if (data.events.contains(
                        'databases.*.collections.${AppwriteConstants.tweetsCollectionID}.documents.*.create',
                      )) {
                        tweets.insert(0, tweet);
                      }
                      if (data.events.contains(
                        'databases.*.collections.${AppwriteConstants.tweetsCollectionID}.documents.*.update',
                      )) {
                        final index = tweets.indexWhere((element) => element.id == tweet.id);
                        tweets[index] = tweet;
                      }
                      if (data.events.contains(
                        'databases.*.collections.${AppwriteConstants.tweetsCollectionID}.documents.*.delete',
                      )) {
                        tweets.removeWhere((element) => element.id == tweet.id);
                      }
                    }
                    return ListView.builder(
                      itemCount: tweets.length,
                      itemBuilder: (context, index) {
                        final tweet = tweets[index];
                        if (tweet.repliedTo.isNotEmpty) return const SizedBox();
                        return TweetCard(tweet: tweet);
                      },
                    );
                  },
                  error: (e, st) => ErrorPage(error: e.toString()),
                  loading: () {
                    return ListView.builder(
                      itemCount: tweets.length,
                      itemBuilder: (context, index) {
                        final tweet = tweets[index];
                        if (tweet.repliedTo.isNotEmpty) return const SizedBox();
                        return TweetCard(tweet: tweet);
                      },
                    );
                  },
                );
          },
          error: (e, st) => ErrorPage(error: e.toString()),
          loading: () => const Loader(),
        );
  }
}
