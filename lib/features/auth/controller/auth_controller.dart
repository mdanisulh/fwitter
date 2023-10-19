import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fwitter/apis/auth_api.dart';
import 'package:fwitter/apis/user_api.dart';
import 'package:fwitter/core/core.dart';
import 'package:fwitter/features/auth/views/login_view.dart';
import 'package:fwitter/features/home/views/home_view.dart';
import 'package:fwitter/models/user_model.dart';

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authAPI: ref.watch(authAPIProvider),
    userAPI: ref.watch(userAPIProvider),
  ),
);

final currentUserDetailsProvider = FutureProvider((ref) {
  final currentUserId = ref.watch(currentUserAccountProvider).value!.$id;
  final userDetails = ref.watch(userDetailsProvider(currentUserId));
  return userDetails.value;
});

final userDetailsProvider = FutureProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

final currentUserAccountProvider = FutureProvider(
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
        bio: '',
        profilePic: 'https://avatars.githubusercontent.com/u/112408973?v=4',
        bannerPic: '',
        followers: [],
        following: [],
        isTwitterBlue: false,
      );
      final user = await _userAPI.saveUserData(userModel: userModel);
      if (context.mounted) {
        if (user == null) {
          showSnackBar(context, 'Account successfully created. Please login!');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginView(),
            ),
          );
        } else {
          showSnackBar(context, user.message);
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

  Future<UserModel> getUserData(String uid) async {
    final document = await _userAPI.getUserData(uid);
    final updatedUser = UserModel.fromMap(document.data);
    return updatedUser;
  }
}
