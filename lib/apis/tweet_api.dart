import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fwitter/constants/constants.dart';
import 'package:fwitter/core/core.dart';
import 'package:fwitter/models/tweet_model.dart';

final tweetAPIProvider = Provider((ref) {
  final database = ref.watch(appwriteDatabaseProvider);
  return TweetAPI(database: database);
});

abstract class ITweetAPI {
  Future<(Failure?, Document?)> shareTweet({required Tweet tweet});
}

class TweetAPI implements ITweetAPI {
  final Databases _database;
  TweetAPI({required Databases database}) : _database = database;

  @override
  Future<(Failure?, Document?)> shareTweet({required Tweet tweet}) async {
    try {
      final document = await _database.createDocument(
        databaseId: AppwriteConstants.databaseID,
        collectionId: AppwriteConstants.tweetsCollectionID,
        documentId: ID.unique(),
        data: tweet.toMap(),
      );
      return (null, document);
    } on AppwriteException catch (e, stackTrace) {
      return (Failure(e.message ?? 'An unknown error occurred!', stackTrace), null);
    } catch (e, stackTrace) {
      return (Failure(e.toString(), stackTrace), null);
    }
  }
}
