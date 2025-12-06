import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:somedia/feature/auth/auth_service/auth_service.dart';
import 'package:somedia/feature/home/models/post.dart';

class DatabaseService {
  static final FirebaseFirestore _database = FirebaseFirestore.instance;

  // send a post
  static Future<void> sendPost(String post) {
    try {
      // get current user
      User user = AuthService.getCurrentUser()!;

      // prepare post content
      Post newPost = Post(
        makerID: user.uid,
        makerEmail: user.email,
        postContent: post,
        timestamp: Timestamp.now(),
      );

      return _database.collection('Posts').add(newPost.toMap());
    } catch (e) {
      rethrow;
    }
  }

  // get posts
  static Stream<List<Map<String, dynamic>>> getPosts() {
    return _database
        .collection('Posts')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
