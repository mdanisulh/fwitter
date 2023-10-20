import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fwitter/constants/constants.dart';
import 'package:fwitter/core/core.dart';

final storageAPIProvider = Provider((ref) {
  final storage = ref.watch(appwriteStorageProvider);
  return StorageAPI(storage: storage);
});

class StorageAPI {
  final Storage _storage;
  StorageAPI({required Storage storage}) : _storage = storage;

  String fileURL({required id, String operation = 'view'}) {
    return '${AppwriteConstants.endpoint}/storage/buckets/${AppwriteConstants.bucketID}/files/$id/$operation?project=${AppwriteConstants.projectID}&mode=admin';
  }

  Future<List<String>> uploadFiles({required List<File> files}) async {
    List<String> fileLinks = [];
    for (final file in files) {
      final uploadedFile = await _storage.createFile(
        bucketId: AppwriteConstants.bucketID,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: file.path),
      );
      fileLinks.add(fileURL(id: uploadedFile.$id));
    }
    return fileLinks;
  }
}
