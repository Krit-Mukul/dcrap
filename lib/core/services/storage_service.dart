import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Upload images to Firebase Storage and return list of download URLs
  static Future<List<String>> uploadOrderImages({
    required String orderId,
    required List<XFile> images,
    Function(int, int)? onProgress,
  }) async {
    List<String> downloadUrls = [];

    try {
      for (int i = 0; i < images.length; i++) {
        final image = images[i];

        // Create a unique filename
        final String fileName =
            '${orderId}_${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
        final String filePath = 'orders/$orderId/$fileName';

        // Create reference
        final Reference ref = _storage.ref().child(filePath);

        // Read image bytes
        final bytes = await image.readAsBytes();

        // Upload with metadata
        final UploadTask uploadTask = ref.putData(
          bytes,
          SettableMetadata(
            contentType: 'image/jpeg',
            customMetadata: {
              'orderId': orderId,
              'uploadedAt': DateTime.now().toIso8601String(),
            },
          ),
        );

        // Listen to upload progress
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          if (onProgress != null) {
            final progress =
                (snapshot.bytesTransferred / snapshot.totalBytes * 100).round();
            onProgress(i + 1, images.length);
          }
        });

        // Wait for upload to complete
        final TaskSnapshot snapshot = await uploadTask;

        // Get download URL
        final String downloadUrl = await snapshot.ref.getDownloadURL();
        downloadUrls.add(downloadUrl);

        print('✅ Image ${i + 1}/${images.length} uploaded: $downloadUrl');
      }

      return downloadUrls;
    } catch (e) {
      print('❌ Error uploading images: $e');
      throw Exception('Failed to upload images: $e');
    }
  }

  /// Delete order images from Firebase Storage
  static Future<void> deleteOrderImages(String orderId) async {
    try {
      final Reference orderRef = _storage.ref().child('orders/$orderId');
      final ListResult result = await orderRef.listAll();

      for (Reference fileRef in result.items) {
        await fileRef.delete();
        print('🗑️ Deleted: ${fileRef.fullPath}');
      }
    } catch (e) {
      print('❌ Error deleting images: $e');
      // Don't throw error, just log it
    }
  }

  /// Upload a single image
  static Future<String> uploadSingleImage({
    required String path,
    required XFile image,
  }) async {
    try {
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final Reference ref = _storage.ref().child('$path/$fileName');

      final bytes = await image.readAsBytes();
      final UploadTask uploadTask = ref.putData(
        bytes,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}
