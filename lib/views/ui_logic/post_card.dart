import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sayhi/model/user.dart';
import 'package:sayhi/viewModel/firestore_method.dart';
import 'package:sayhi/views/home/comment_page.dart';
import 'package:sayhi/views/state_management/user_provide.dart';
import 'package:sayhi/views/ui_logic/like_animation.dart';
import 'package:sayhi/views/ui_logic/show_snack_bar.dart';

class PostCard extends StatefulWidget {
  final snap;

  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLength = 0;

  @override
  void initState() {
    getComments();
    super.initState();
  }

  void getComments() async {
    try{
      QuerySnapshot snap = await FirebaseFirestore.instance.collection('posts').doc(widget.snap['postId']).collection('comments').get();
      commentLength = snap.docs.length;
    }catch(e){
      showSnackBar(e.toString(), context);
    }
    // setState(() {
    //
    // });
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvide>(context).getUser;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 5, bottom: 5, left: 20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.snap['profImage']),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.snap['username'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shrinkWrap: true,
                            children: ['Delete']
                                .map(
                                  (e) => GestureDetector(
                                    onTap: () async {
                                      await FirestoreMethods().deletePost(widget.snap['postId']);
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 15),
                                      child: Text(e),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.more_vert_outlined))
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethods().likePost(
                widget.snap['postId'].toString(),
                user.uid,
                widget.snap['likes'],
              );
              isLikeAnimating = true;
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: 3 / 4,
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                              image: NetworkImage(widget.snap['postUrl']),
                              fit: BoxFit.fitHeight,
                              filterQuality: FilterQuality.low,
                              alignment: FractionalOffset.topCenter)),
                    ),
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isLikeAnimating ? 1 : 0,
                    child: LikeAnimation(
                      isAnimating: isLikeAnimating,
                      duration: const Duration(milliseconds: 400),
                      onEnd: () {
                        setState(() {
                          isLikeAnimating = false;
                        });
                      },
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.deepPurpleAccent,
                        size: 100,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLikes: true,
                child: IconButton(
                    onPressed: () async {
                      await FirestoreMethods().likePost(
                        widget.snap['postId'].toString(),
                        user.uid,
                        widget.snap['likes'],
                      );
                    },
                    icon: widget.snap['likes'].contains(user.uid)
                        ? const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Icon(
                              Icons.favorite,
                              color: Colors.deepPurple,
                            ))
                        : const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Icon(
                              Icons.favorite_border,
                            ))),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            //CommentsScreen()
                            CommentsPage(
                          snap: widget.snap,
                        ),
                        //     CommentsPage(
                        //   //snap: widget.snap,
                        //     postId: widget.snap['postId'].toString()
                        // ),
                      ),
                    );
                  },
                  icon: const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(Icons.comment_outlined))),
              IconButton(
                  onPressed: () {},
                  icon: const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(Icons.share_outlined)))
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'likes ${widget.snap['likes'].length}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )),
                 Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Comments $commentLength',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      DateFormat.yMMMd()
                          .format(widget.snap['datePublished'].toDate()),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )),
                RichText(
                  //textAlign: TextAlign.end,
                  text: TextSpan(
                    style: TextStyle(
                        fontFamily: GoogleFonts.varelaRound().fontFamily),
                    children: [
                      TextSpan(
                          text: 'Description: ',
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              color: Colors.grey.shade900)),
                      TextSpan(
                          text: widget.snap['description'],
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade800)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
