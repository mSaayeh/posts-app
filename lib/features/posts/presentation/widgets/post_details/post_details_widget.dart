import 'package:flutter/material.dart';
import 'package:posts_app/features/posts/domain/entities/post.dart';
import 'package:posts_app/features/posts/presentation/widgets/post_details/delete_post_button.dart';
import 'package:posts_app/features/posts/presentation/widgets/post_details/edit_post_button.dart';

class PostDetailsWidget extends StatelessWidget {
  final Post post;
  const PostDetailsWidget(this.post, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              post.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const Divider(height: 50, thickness: 0.2),
            Text(
              post.body,
              style: const TextStyle(fontSize: 16),
            ),
            const Divider(height: 50, thickness: 0.2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                EditPostButton(post),
                DeletePostButton(post.id),
              ],
            )
          ],
        ),
      ),
    );
  }
}
