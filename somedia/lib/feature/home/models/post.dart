import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String? makerID;
  final String? makerEmail;
  final String? postContent;
  final Timestamp? timestamp;

  Post({
    required this.makerID,
    required this.makerEmail,
    required this.postContent,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
    'makerID': makerID,
    'makerEmail': makerEmail,
    'postContent': postContent,
    'timestamp': timestamp,
  };
}
