import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fwitter/apis/auth_api.dart';
import 'package:fwitter/apis/user_api.dart';
import 'package:fwitter/constants/constants.dart';
import 'package:fwitter/core/core.dart';
import 'package:fwitter/features/auth/views/login_view.dart';
import 'package:fwitter/features/home/views/home_view.dart';
import 'package:fwitter/models/user_model.dart';

final authControllerProvider = StateNotifierProvider.autoDispose<AuthController, bool>(
  (ref) => AuthController(
    authAPI: ref.watch(authAPIProvider),
    userAPI: ref.watch(userAPIProvider),
  ),
);

final currentUserDetailsProvider = FutureProvider.autoDispose((ref) async {
  final currentUser = await ref.watch(authControllerProvider.notifier).currentUser();
  final userDetails = await ref.watch(authControllerProvider.notifier).getUserData(currentUser?.$id);
  return userDetails;
});

final userDetailsProvider = FutureProvider.autoDispose.family((ref, String? uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

final currentUserAccountProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(authControllerProvider.notifier).currentUser(),
);

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final UserAPI _userAPI;
  AuthController({required AuthAPI authAPI, required UserAPI userAPI})
      : _authAPI = authAPI,
        _userAPI = userAPI,
        super(false);

  Future<User?> currentUser() => _authAPI.currentUserAccount();

  void signUp({required String email, required String password, required BuildContext context}) async {
    state = true;
    final res = await _authAPI.signUp(email: email, password: password);
    state = false;
    if (res.$2 != null) {
      UserModel userModel = UserModel(
        uid: res.$2!.$id,
        email: email,
        name: email.split('@')[0],
        username: email.split('@')[0],
        bio: '',
        profilePic: '${AppwriteConstants.endpoint}/storage/buckets/${AppwriteConstants.bucketID}/files/default_profile/view?project=${AppwriteConstants.projectID}',
        bannerPic: '',
        followers: [],
        following: [],
        isTwitterBlue: false,
      );
      final response = await _userAPI.saveUserData(userModel: userModel);
      if (context.mounted) {
        if (response == null) {
          showSnackBar(context, 'Account successfully created. Please login!');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginView()),
          );
        } else {
          showSnackBar(context, response.message);
        }
      }
    } else {
      if (context.mounted) {
        showSnackBar(context, res.$1!.message);
      }
    }
  }

  void login({required String email, required String password, required BuildContext context}) async {
    state = true;
    final res = await _authAPI.login(email: email, password: password);
    state = false;
    if (context.mounted) {
      if (res.$2 != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeView(),
          ),
        );
      } else {
        showSnackBar(context, res.$1!.message);
      }
    }
  }

  Future<UserModel?> getUserData(String? uid) async {
    if (uid == null) {
      return null;
    }
    final document = await _userAPI.getUserData(uid);
    final updatedUser = UserModel.fromMap(document.data);
    return updatedUser;
  }
}
