import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fwitter/apis/user_api.dart';
import 'package:fwitter/models/user_model.dart';

final exploreControllerProvider = StateNotifierProvider.autoDispose<ExploreController, bool>(
  (ref) => ExploreController(
    userAPI: ref.watch(userAPIProvider),
  ),
);

final searchUsersProvider = FutureProvider.autoDispose.family((ref, String query) async {
  final users = await ref.watch(exploreControllerProvider.notifier).searchUsers(query);
  return users;
});

class ExploreController extends StateNotifier<bool> {
  final UserAPI _userAPI;
  ExploreController({required UserAPI userAPI})
      : _userAPI = userAPI,
        super(false);

  Future<List<UserModel>> searchUsers(String query) async {
    final users = await _userAPI.searchUsers(query);
    return users.map((user) => UserModel.fromMap(user.data)).toList();
  }
}
