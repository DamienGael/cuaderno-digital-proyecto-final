import 'package:flutter/material.dart';
import '../models/forum_post_model.dart';

class ForumPostCard extends StatelessWidget {
  final ForumPostModel post;
  const ForumPostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(post.title),
        subtitle: Text(post.content),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${post.likes} 👍'),
            Text('${post.replies} respuestas'),
          ],
        ),
      ),
    );
  }
}
