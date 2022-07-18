import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(children: [
        CircleAvatar(
          backgroundImage: NetworkImage(widget.snap['profImageUrl']),
          radius: 18,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: widget.snap["userName"],
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                      text: "   ${widget.snap["text"]}",
                    )
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    DateFormat.yMMMEd()
                        .format(widget.snap["commentDate"].toDate()),
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8),
          child: Icon(
            Icons.favorite,
          ),
        )
      ]),
    );
  }
}
