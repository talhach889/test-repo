// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:sayhi/model/user.dart';
// import 'package:sayhi/views/state_management/user_provide.dart';
// import 'package:sayhi/views/ui_logic/comment_card.dart';
// import 'package:sayhi/views/ui_logic/show_snack_bar.dart';
// import 'package:sayhi/viewModel/firestore_method.dart';
//
// class CommentsScreen extends StatefulWidget {
//   final snap;
//   final postId;
//
//   const CommentsScreen({Key? key, required this.snap, required this.postId})
//       : super(key: key);
//
//   @override
//   _CommentsScreenState createState() => _CommentsScreenState();
// }
//
// class _CommentsScreenState extends State<CommentsScreen> {
//   final TextEditingController commentEditingController =
//       TextEditingController();
//
//   void postComment(String uid, String name, String profilePic) async {
//     try {
//       String res = await FirestoreMethods().postComment(
//           widget.snap, commentEditingController.text, uid, name, profilePic);
//
//       if (res != 'success') {
//         showSnackBar(res, context);
//       }
//       setState(() {
//         commentEditingController.text = "";
//       });
//     } catch (err) {
//       showSnackBar(err.toString(), context);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final User user = Provider.of<UserProvide>(context).getUser;
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: const Text(
//           'Comments',
//         ),
//         centerTitle: true,
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('posts')
//             .doc(widget.snap)
//             .collection('comments')
//             .snapshots(),
//         builder: (context,
//             AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//
//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (context, index) => CommentCard(
//               snap: snapshot.data!.docs[index],
//             ),
//           );
//         },
//       ),
//       // text input
//       bottomNavigationBar: SafeArea(
//         child: Container(
//           height: kToolbarHeight,
//           margin:
//               EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//           padding: const EdgeInsets.only(left: 16, right: 8),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 backgroundImage: NetworkImage(user.photoUrl),
//                 radius: 18,
//               ),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 16, right: 8),
//                   child: TextField(
//                     controller: commentEditingController,
//                     decoration: InputDecoration(
//                       hintText: 'Comment as ${user.username}',
//                       border: InputBorder.none,
//                     ),
//                   ),
//                 ),
//               ),
//               InkWell(
//                 onTap: () => postComment(
//                   user.uid,
//                   user.username,
//                   user.photoUrl,
//                 ),
//                 child: Container(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
//                   child: const Text(
//                     'Post',
//                     style: TextStyle(color: Colors.blue),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sayhi/viewModel/firestore_method.dart';
import 'package:sayhi/views/state_management/user_provide.dart';
import 'package:sayhi/model/user.dart';
import 'package:sayhi/views/ui_logic/comment_card.dart';

class CommentsPage extends StatefulWidget {
  final snap;

  //final postId;

  const CommentsPage({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvide>(context).getUser;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Comments'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.snap['postId'])
            .collection('comments')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.deepOrange,
              ),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) =>
                  CommentCard(snap: snapshot.data!.docs[index]));
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.photoUrl),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                        hintText: 'Comment as ${user.username}',
                        border: InputBorder.none),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await FirestoreMethods().postComment(
                      widget.snap['postId'],
                      _commentController.text,
                      user.uid,
                      user.username,
                      user.photoUrl);
                  setState(() {
                    _commentController.text = "";
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                        color: Colors.deepPurple, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
