import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({Key? key,required this.snap}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
                widget.snap['profilePic']),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.snap['name'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800),
                        ),
                        TextSpan(
                          text: " ${widget.snap['text']}",
                          style: TextStyle(color: Colors.grey.shade800),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd().format(
                        widget.snap['datePublished'].toDate(),
                      ),
                      style: TextStyle(
                      fontWeight: FontWeight.w400,
                        color: Colors.grey.shade600
                    ),),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// class CommentCard extends StatelessWidget {
//   final snap;
//   const CommentCard({Key? key, required this.snap}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//       child: Row(
//         children: [
//           CircleAvatar(
//             backgroundImage: NetworkImage(
//               snap.data()['profilePic'],
//             ),
//             radius: 18,
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.only(left: 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   RichText(
//                     text: TextSpan(
//                       children: [
//                         TextSpan(
//                             //text: snap.data()['name'],
//                           text: snap.data()['name'],
//                             style:  TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade800)
//                         ),
//                         TextSpan(
//                           text: ' ${snap.data()['text']}',
//                           style: TextStyle(color: Colors.grey.shade800)
//                         ),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 4),
//                     child: Text(
//                       DateFormat.yMMMd().format(
//                         snap.data()['datePublished'].toDate(),
//                       ),
//                       style: TextStyle(
//                         color: Colors.grey.shade600,
//                         fontSize: 12, fontWeight: FontWeight.w300,),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.all(8),
//             child: const Icon(
//               Icons.favorite,
//               size: 16,
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
