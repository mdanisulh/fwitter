import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fwitter/core/core.dart';

final authApiProvider = Provider((ref) {
  final account = ref.watch(appwriteAccountProvider);
  return AuthApi(account: account);
});

abstract class IAuthApi {
  Future<(Failure?, User?)> signUp({required String email, required String password});
  Future<(Failure?, Session?)> login({required String email, required String password});
  Future<User?> currentUserAccount();
}

class AuthApi implements IAuthApi {
  final Account _account;
  AuthApi({required Account account}) : _account = account;

  @override
  Future<(Failure?, User?)> signUp({required String email, required String password}) async {
    try {
      final account = await _account.create(userId: ID.unique(), email: email, password: password);
      return (null, account);
    } on AppwriteException catch (e, stackTrace) {
      return (Failure(e.message ?? 'An unknown error occurred!', stackTrace), null);
    } catch (e, stackTrace) {
      return (Failure(e.toString(), stackTrace), null);
    }
  }

  @override
  Future<(Failure?, Session?)> login({required String email, required String password}) async {
    try {
      final session = await _account.createEmailSession(email: email, password: password);
      return (null, session);
    } on AppwriteException catch (e, stackTrace) {
      return (Failure(e.message ?? 'An unknown error occurred!', stackTrace), null);
    } catch (e, stackTrace) {
      return (Failure(e.toString(), stackTrace), null);
    }
  }

  @override
  Future<User?> currentUserAccount() async {
    try {
      return await _account.get();
    } catch (e) {
      return null;
    }
  }
}
