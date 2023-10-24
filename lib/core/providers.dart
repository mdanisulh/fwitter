import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fwitter/constants/constants.dart';

final appwriteClientProvider = Provider.autoDispose((ref) {
  final client = Client();
  return client.setEndpoint(AppwriteConstants.endpoint).setProject(AppwriteConstants.projectID).setSelfSigned(status: true);
});

final appwriteAccountProvider = Provider.autoDispose((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Account(client);
});

final appwriteDatabaseProvider = Provider.autoDispose((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Databases(client);
});

final appwriteStorageProvider = Provider.autoDispose((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Storage(client);
});

final appwriteRealtimeProvider = Provider.autoDispose((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Realtime(client);
});
