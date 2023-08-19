import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fwitter/apis/auth_api.dart';
import 'package:fwitter/core/core.dart';
import 'package:fwitter/features/auth/views/login_view.dart';
import 'package:fwitter/features/home/views/home_view.dart';

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authApi: ref.watch(authApiProvider),
  ),
);

final currentUserAccountProvider = FutureProvider(
  (ref) => ref.watch(authControllerProvider.notifier).currentUser(),
);

class AuthController extends StateNotifier<bool> {
  final AuthApi _authApi;
  AuthController({required AuthApi authApi})
      : _authApi = authApi,
        super(false);

  Future<User?> currentUser() => _authApi.currentUserAccount();

  void signUp({required String email, required String password, required BuildContext context}) async {
    state = true;
    final res = await _authApi.signUp(email: email, password: password);
    state = false;
    if (context.mounted) {
      if (res.$2 != null) {
        showSnackBar(context, 'Account successfully created. You can login now!');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginView()));
      } else {
        showSnackBar(context, res.$1!.message);
      }
    }
  }

  void login({required String email, required String password, required BuildContext context}) async {
    state = true;
    final res = await _authApi.login(email: email, password: password);
    state = false;
    if (context.mounted) {
      if (res.$2 != null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeView()));
      } else {
        showSnackBar(context, res.$1!.message);
      }
    }
  }
}
