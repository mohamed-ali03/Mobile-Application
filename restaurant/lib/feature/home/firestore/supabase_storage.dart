import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorage {
  static final SupabaseClient _supabase = Supabase.instance.client;

  /// Add image to Supabase Storage
  /// Returns the public URL of the uploaded image
  static Future<String?> uploadImage(
    String bucket,
    String filename,
    File file,
  ) async {
    try {
      // Upload the file to the specified bucket
      await _supabase.storage.from(bucket).upload(filename, file);

      // Get the public URL of the uploaded file
      final publicUrl = _supabase.storage.from(bucket).getPublicUrl(filename);

      return publicUrl; // return URL as String
    } catch (e) {
      rethrow;
    }
  }

  /// Get image from Supabase Storage
  /// Returns the File object (downloads to local temp file)
  static Future<File?> getImage(String bucket, String filename) async {
    try {
      // Download file as bytes
      final response = await _supabase.storage.from(bucket).download(filename);

      // Create a temporary file
      final file = File('/tmp/$filename');
      await file.writeAsBytes(response);

      return file; // return the File
    } catch (e) {
      rethrow;
    }
  }

  /// Delete image from Supabase Storage
  static Future<void> deleteImage(String bucket, String filename) async {
    try {
      await _supabase.storage.from(bucket).remove([filename]);
    } catch (e) {
      rethrow;
    }
  }
}
