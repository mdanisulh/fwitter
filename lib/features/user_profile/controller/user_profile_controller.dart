import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fwitter/apis/storage_api.dart';
import 'package:fwitter/apis/tweet_api.dart';
import 'package:fwitter/apis/user_api.dart';
import 'package:fwitter/core/core.dart';
import 'package:fwitter/models/tweet_model.dart';
import 'package:fwitter/models/user_model.dart';

final userProfileControllerProvider = StateNotifierProvider.autoDispose<UserProfileController, bool>(
  (ref) => UserProfileController(
    tweetAPI: ref.watch(tweetAPIProvider),
    userAPI: ref.watch(userAPIProvider),
    storageAPI: ref.watch(storageAPIProvider),
  ),
);

final getUserTweetsProvider = FutureProvider.autoDispose.family((ref, String userId) async {
  final userProfileController = ref.watch(userProfileControllerProvider.notifier);
  return userProfileController.getUserTweets(userId: userId);
});

class UserProfileController extends StateNotifier<bool> {
  final TweetAPI _tweetAPI;
  final UserAPI _userAPI;
  final StorageAPI _storageAPI;

  UserProfileController({required TweetAPI tweetAPI, required UserAPI userAPI, required StorageAPI storageAPI})
      : _tweetAPI = tweetAPI,
        _userAPI = userAPI,
        _storageAPI = storageAPI,
        super(false);

  Future<List<Tweet>> getUserTweets({required String userId}) async {
    final tweets = await _tweetAPI.getUserTweets(userId: userId);
    return tweets.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }

  void updateUserDetails({required UserModel user, required BuildContext context, File? profilePic, File? bannerPic}) async {
    try {
      state = true;
      if (bannerPic != null) {
        final bannerUrl = await _storageAPI.uploadFiles(files: [bannerPic]);
        user = user.copyWith(bannerPic: bannerUrl[0]);
      }
      if (profilePic != null) {
        final profileUrl = await _storageAPI.uploadFiles(files: [profilePic]);
        user = user.copyWith(profilePic: profileUrl[0]);
      }
      final res = await _userAPI.updateUserDetails(user: user);
      state = false;
      if (context.mounted) {
        if (res != null) {
          showSnackBar(context, res.message);
        } else {
          Navigator.pop(context);
        }
      }
    } catch (error) {
      return;
    }
  }

  void followUser({required UserModel user, required UserModel currentUser, required BuildContext context}) async {
    try {
      state = true;
      if (currentUser.following.contains(user.uid)) {
        currentUser.following.remove(user.uid);
        user.followers.remove(currentUser.uid);
      } else {
        currentUser.following.add(user.uid);
        user.followers.add(currentUser.uid);
      }
      final res = await _userAPI.followUser(user: user, currentUser: currentUser);
      state = false;
      if (context.mounted) {
        if (res != null) {
          showSnackBar(context, res.message);
        }
      }
    } catch (error) {
      if (context.mounted) {
        showSnackBar(context, error.toString());
      }
    }
  }
}
