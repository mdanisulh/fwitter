import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fwitter/features/tweet/controller/tweet_controller.dart';
import 'package:fwitter/features/tweet/widgets/tweet_card.dart';
import 'package:fwitter/models/tweet_model.dart';
import 'package:fwitter/theme/theme.dart';

class ReplyView extends ConsumerWidget {
  static route(Tweet tweet) => MaterialPageRoute(builder: (context) => ReplyView(tweet: tweet));
  final Tweet tweet;
  final controller = TextEditingController();
  ReplyView({super.key, required this.tweet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
      ),
      body: Column(
        children: [
          TweetCard(tweet: tweet),
          Expanded(
            child: ListView.builder(
              itemCount: tweet.commentIds.length,
              itemBuilder: (context, index) {
                final replyId = tweet.commentIds[index];
                final reply = ref.watch(getTweetByIDProvider(replyId)).value;
                if (reply == null) return const SizedBox();
                return TweetCard(tweet: reply);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 16),
        maxLines: null,
        decoration: InputDecoration(
          constraints: const BoxConstraints(maxHeight: 150),
          contentPadding: const EdgeInsets.all(20),
          hintText: 'Reply',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Pallete.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Pallete.grey),
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              ref.watch(tweetControllerProvider.notifier).shareTweet(
                images: [],
                text: controller.text,
                repliedTo: tweet.id,
                context: context,
              ).then((reply) {
                if (reply != null) {
                  tweet.commentIds.add(reply.id);
                  ref.watch(replyTweetProvider(tweet));
                }
              });
              controller.text = '';
            },
            child: const Icon(Icons.send, size: 25),
          ),
        ),
      ),
    );
  }
}
