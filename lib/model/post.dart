
import 'package:cloud_firestore/cloud_firestore.dart';

class Post{
  final String description;
  final String uid;
  final String postId;
  final String username;
  final datePublished;
  final String postUrl;
  final String profImage;
  final likes;

  const Post({
    required this.description,
    required this.uid,
    required this.postId,
    required this.username,
    required this.datePublished,
    required this.profImage,
    required this.postUrl,
    required this.likes,
  });

  Map<String, dynamic> toJson() =>{
    "username": username,
    "uid": uid,
    "description":description,
    "postUrl": postUrl,
    "postId": postId,
    "profImage":profImage,
    "datePublished":datePublished,
    "likes":likes,
  };

  static Post fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String,dynamic>;
    return Post(
      description: snapshot['description'],
      uid: snapshot['uid'],
      postUrl: snapshot['postUrl'],
      username: snapshot['username'],
      postId: snapshot['postId'],
      datePublished: snapshot['datePublished'],
      profImage: snapshot['profImage'],
      likes: snapshot['likes'],
    );
  }
}