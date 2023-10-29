import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fwitter/apis/storage_api.dart';
import 'package:fwitter/apis/tweet_api.dart';
import 'package:fwitter/core/core.dart';
import 'package:fwitter/core/enums/tweet_type_enum.dart';
import 'package:fwitter/features/auth/controller/auth_controller.dart';
import 'package:fwitter/models/tweet_model.dart';
import 'package:fwitter/models/user_model.dart';

final tweetControllerProvider = StateNotifierProvider.autoDispose<TweetController, bool>((ref) {
  return TweetController(
    ref: ref,
    tweetAPI: ref.watch(tweetAPIProvider),
    storageAPI: ref.watch(storageAPIProvider),
  );
});

final getTweetsProvider = FutureProvider.autoDispose((ref) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweets();
});

final getTweetByIDProvider = FutureProvider.autoDispose.family((ref, String tweetId) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweetById(tweetId: tweetId);
});

final replyTweetProvider = FutureProvider.autoDispose.family((ref, Tweet tweet) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.replyTweet(tweet: tweet);
});

// * This provider is not completely related to tweetAPI or tweetController but appwrite only allows
// * subscribing to channels simultaneously otherwise previous channel subscription is cancelled.
// TODO: Find a better way to do this
final getLatestDataProvider = StreamProvider.autoDispose((ref) {
  final tweetAPI = ref.watch(tweetAPIProvider);
  return tweetAPI.getLatestData();
});

class TweetController extends StateNotifier<bool> {
  final Ref _ref;
  final TweetAPI _tweetAPI;
  final StorageAPI _storageAPI;
  TweetController({required Ref ref, required StorageAPI storageAPI, required TweetAPI tweetAPI})
      : _ref = ref,
        _storageAPI = storageAPI,
        _tweetAPI = tweetAPI,
        super(false);

  Future<Tweet?> shareTweet({
    required List<File> images,
    required String text,
    String repliedTo = '',
    required BuildContext context,
  }) async {
    if (text.isEmpty && images.isEmpty) {
      showSnackBar(context, 'Please enter some text or add an image!');
      return null;
    }
    state = true;
    final List<String> imageLinks;
    if (images.isNotEmpty) {
      imageLinks = await _storageAPI.uploadFiles(files: images);
    } else {
      imageLinks = [];
    }
    final link = _getLinkFromText(text);
    final hashtags = _getHashtagsFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value!;
    Tweet tweet = Tweet(
      text: text,
      link: link,
      uid: user.uid,
      hashtags: hashtags,
      imageLinks: imageLinks,
      tweetType: images.isEmpty ? TweetType.text : TweetType.image,
      tweetedAt: DateTime.now(),
      likes: [],
      commentIds: [],
      id: '',
      retweetCount: 0,
      retweetedBy: '',
      repliedTo: repliedTo,
    );
    final res = await _tweetAPI.shareTweet(tweet: tweet);
    state = false;
    if (context.mounted) {
      if (res.$1 != null) {
        showSnackBar(context, res.$1!.message);
      } else {
        return Tweet.fromMap(res.$2!.data);
      }
    }
    return null;
  }

  String _getLinkFromText(String text) {
    final words = text.split(' ');
    for (var word in words) {
      if (word.startsWith('www.') || word.startsWith('https://')) {
        return word;
      }
    }
    return '';
  }

  List<String> _getHashtagsFromText(String text) {
    final words = text.split(' ');
    final hashtags = <String>[];
    for (var word in words) {
      if (word.startsWith('#')) {
        hashtags.add(word);
      }
    }
    return hashtags;
  }

  Future<List<Tweet>> getTweets() async {
    final tweetList = await _tweetAPI.getTweets();
    return tweetList.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }

  void likeTweet(Tweet tweet, UserModel user) async {
    final likes = tweet.likes;
    if (likes.contains(user.uid)) {
      likes.remove(user.uid);
    } else {
      likes.add(user.uid);
    }
    tweet = tweet.copyWith(likes: likes);
    await _tweetAPI.likeTweet(tweet: tweet);
  }

  void retweet(Tweet tweet, UserModel user, BuildContext context) async {
    final res = await _tweetAPI.retweet(tweet: tweet);
    if (res.$1 != null && context.mounted) {
      showSnackBar(context, res.$1!.message);
    } else {
      tweet = tweet.copyWith(
        retweetedBy: user.name,
        retweetCount: 0,
        likes: [],
        commentIds: [],
        repliedTo: '',
        tweetedAt: DateTime.now(),
        id: ID.unique(),
      );
      final res2 = await _tweetAPI.shareTweet(tweet: tweet);
      if (context.mounted) {
        if (res2.$1 != null) {
          showSnackBar(context, res2.$1!.message);
        } else {
          showSnackBar(context, 'Retweeted successfully!');
        }
      }
    }
  }

  Future<Tweet?> getTweetById({required String tweetId}) async {
    final tweet = await _tweetAPI.getTweetById(tweetId: tweetId);
    if (tweet == null) return null;
    return Tweet.fromMap(tweet.data);
  }

  void replyTweet({required Tweet tweet}) async {
    await _tweetAPI.replyTweet(tweet: tweet);
  }
}
