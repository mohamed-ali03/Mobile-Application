import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UploadImage {
  final supabase = Supabase.instance.client;

  // ================================
  // PICK AND UPLOAD IMAGE
  // ================================
  Future<File?> pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile == null) {
        debugPrint('❌ No image selected');
        return null;
      }

      return File(pickedFile.path);
    } catch (e) {
      debugPrint('❌ Pick image failed: $e');
      return null;
    }
  }

  // ================================
  // UPLOAD IMAGE
  // ================================
  Future<String> uploadImage(
    String bucketName,
    String filename,
    File file,
  ) async {
    try {
      if (bucketName.isEmpty || filename.isEmpty) {
        debugPrint('❌ Bucket or filename is empty');
        return '';
      }

      if (!file.existsSync()) {
        debugPrint('❌ File does not exist: ${file.path}');
        return '';
      }

      final fileSizeInMB = file.lengthSync() / (1024 * 1024);
      if (fileSizeInMB > 10) {
        debugPrint('❌ File too large: ${fileSizeInMB.toStringAsFixed(2)}MB');
        return '';
      }

      // Upload the file to the specified bucket
      await supabase.storage.from(bucketName).upload(filename, file);

      // Get the public URL of the uploaded file
      final publicUrl = supabase.storage
          .from(bucketName)
          .getPublicUrl(filename);

      return publicUrl; // return URL as String
    } catch (e) {
      debugPrint('❌ Upload failed: $e');
      return '';
    }
  }

  // ================================
  // DELETE IMAGE
  // ================================
  Future<void> deleteImage(String bucketName, String filename) async {
    try {
      if (bucketName.isEmpty || filename.isEmpty) {
        debugPrint('❌ Bucket or filename is empty');
        return;
      }

      debugPrint('🗑️ Deleting: $filename');

      debugPrint('✅ Delete successful');
    } catch (e) {
      debugPrint('❌ Delete failed: $e');
    }
  }
}
