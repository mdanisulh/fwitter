import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fwitter/constants/constants.dart';
import 'package:fwitter/core/core.dart';
import 'package:fwitter/models/tweet_model.dart';

final tweetAPIProvider = Provider((ref) {
  final database = ref.watch(appwriteDatabaseProvider);
  final realtime = ref.watch(appwriteRealtimeProvider);
  return TweetAPI(database: database, realtime: realtime);
});

abstract class ITweetAPI {
  Future<List<Document>> getTweets();
  Future<(Failure?, Document?)> shareTweet({required Tweet tweet});
  Future<(Failure?, Document?)> likeTweet({required Tweet tweet});
  Stream<RealtimeMessage> getLatestTweet();
}

class TweetAPI implements ITweetAPI {
  final Databases _database;
  final Realtime _realtime;
  TweetAPI({required Databases database, required Realtime realtime})
      : _database = database,
        _realtime = realtime;

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

  @override
  Future<List<Document>> getTweets() async {
    final documentList = await _database.listDocuments(
      databaseId: AppwriteConstants.databaseID,
      collectionId: AppwriteConstants.tweetsCollectionID,
      queries: [
        Query.orderDesc('tweetedAt'),
      ],
    );
    return documentList.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestTweet() {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.databaseID}.collections.${AppwriteConstants.tweetsCollectionID}.documents',
    ]).stream;
  }

  @override
  Future<(Failure?, Document?)> likeTweet({required Tweet tweet}) async {
    try {
      final document = await _database.updateDocument(
        databaseId: AppwriteConstants.databaseID,
        collectionId: AppwriteConstants.tweetsCollectionID,
        documentId: tweet.id,
        data: {'likes': tweet.likes},
      );
      return (null, document);
    } on AppwriteException catch (e, stackTrace) {
      return (Failure(e.message ?? 'An unknown error occurred!', stackTrace), null);
    } catch (e, stackTrace) {
      return (Failure(e.toString(), stackTrace), null);
    }
  }
}
