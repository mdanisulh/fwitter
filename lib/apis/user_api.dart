import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fwitter/constants/constants.dart';
import 'package:fwitter/core/core.dart';
import 'package:fwitter/models/user_model.dart';

final userAPIProvider = Provider((ref) {
  final db = ref.watch(appwriteDatabaseProvider);
  return UserAPI(db: db);
});

abstract class IUserAPI {
  Future<Failure?> saveUserData({required UserModel userModel});
  Future<Document> getUserData(String uid);
}

class UserAPI implements IUserAPI {
  final Databases _db;
  UserAPI({required Databases db}) : _db = db;

  @override
  Future<Failure?> saveUserData({required UserModel userModel}) async {
    try {
      await _db.createDocument(
        databaseId: AppwriteConstants.databaseID,
        collectionId: AppwriteConstants.usersCollectionID,
        documentId: userModel.uid,
        data: userModel.toMap(),
      );
      return null;
    } on AppwriteException catch (error, stackTrace) {
      return Failure(error.message ?? 'An unknown error occurred!', stackTrace);
    } catch (error, stackTrace) {
      return Failure(error.toString(), stackTrace);
    }
  }

  @override
  Future<Document> getUserData(String uid) {
    return _db.getDocument(
      databaseId: AppwriteConstants.databaseID,
      collectionId: AppwriteConstants.usersCollectionID,
      documentId: uid,
    );
  }
}
