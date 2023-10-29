import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fwitter/apis/tweet_api.dart';
import 'package:fwitter/apis/user_api.dart';
import 'package:fwitter/models/tweet_model.dart';

final userProfileControllerProvider = StateNotifierProvider.autoDispose<UserProfileController, bool>(
  (ref) => UserProfileController(
    tweetAPI: ref.watch(tweetAPIProvider),
    userAPI: ref.watch(userAPIProvider),
  ),
);

final getUserTweetsProvider = FutureProvider.autoDispose.family((ref, String userId) async {
  final userProfileController = ref.watch(userProfileControllerProvider.notifier);
  return userProfileController.getUserTweets(userId: userId);
});

class UserProfileController extends StateNotifier<bool> {
  final TweetAPI _tweetAPI;
  final UserAPI _userAPI;

  UserProfileController({required TweetAPI tweetAPI, required UserAPI userAPI})
      : _tweetAPI = tweetAPI,
        _userAPI = userAPI,
        super(false);

  Future<List<Tweet>> getUserTweets({required String userId}) async {
    final tweets = await _tweetAPI.getUserTweets(userId: userId);
    return tweets.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }
}
