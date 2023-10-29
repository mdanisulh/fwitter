import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fwitter/constants/constants.dart';
import 'package:fwitter/core/core.dart';
import 'package:fwitter/models/user_model.dart';

final userAPIProvider = Provider.autoDispose((ref) {
  final db = ref.watch(appwriteDatabaseProvider);
  return UserAPI(db: db);
});

abstract class IUserAPI {
  Future<Failure?> saveUserData({required UserModel user});
  Future<Document> getUserData(String uid);
  Future<List<Document>> searchUsers(String query);
  Future<Failure?> updateUserDetails({required UserModel user});
  Future<Failure?> followUser({required UserModel user, required UserModel currentUser});
}

class UserAPI implements IUserAPI {
  final Databases _db;
  UserAPI({required Databases db}) : _db = db;

  @override
  Future<Failure?> saveUserData({required UserModel user}) async {
    try {
      await _db.createDocument(
        databaseId: AppwriteConstants.databaseID,
        collectionId: AppwriteConstants.usersCollectionID,
        documentId: user.uid,
        data: user.toMap(),
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

  @override
  Future<List<Document>> searchUsers(String query) async {
    try {
      final searchByName = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseID,
        collectionId: AppwriteConstants.usersCollectionID,
        queries: [Query.search('name', query)],
      );
      final searchByUserName = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseID,
        collectionId: AppwriteConstants.usersCollectionID,
        queries: [Query.search('username', query)],
      );
      final users = searchByName.documents + searchByUserName.documents;
      users.sort((a, b) => a.data['name'].compareTo(b.data['name']));
      return users;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Failure?> updateUserDetails({required UserModel user}) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseID,
        collectionId: AppwriteConstants.usersCollectionID,
        documentId: user.uid,
        data: user.toMap(),
      );
      return null;
    } on AppwriteException catch (error, stackTrace) {
      return Failure(error.message ?? 'An unknown error occurred!', stackTrace);
    } catch (error, stackTrace) {
      return Failure(error.toString(), stackTrace);
    }
  }

  @override
  Future<Failure?> followUser({required UserModel user, required UserModel currentUser}) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseID,
        collectionId: AppwriteConstants.usersCollectionID,
        documentId: user.uid,
        data: {'followers': user.followers},
      );
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseID,
        collectionId: AppwriteConstants.usersCollectionID,
        documentId: currentUser.uid,
        data: {'following': currentUser.following},
      );
      return null;
    } on AppwriteException catch (error, stackTrace) {
      return Failure(error.message ?? 'An unknown error occurred!', stackTrace);
    } catch (error, stackTrace) {
      return Failure(error.toString(), stackTrace);
    }
  }
}
