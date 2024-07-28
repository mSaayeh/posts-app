import 'package:flutter/material.dart';
import 'package:posts_app/features/posts/domain/entities/post.dart';
import 'package:posts_app/features/posts/presentation/screens/post_add_update_screen.dart';

class EditPostButton extends StatelessWidget {
  final Post post;
  const EditPostButton(this.post, {super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PostAddUpdateScreen(post: post),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        foregroundColor: Theme.of(context).primaryColor,
      ),
      label: const Text("Edit"),
      icon: const Icon(Icons.edit),
    );
  }
}
