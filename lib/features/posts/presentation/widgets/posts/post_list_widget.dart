import 'package:flutter/material.dart';
import 'package:posts_app/features/posts/domain/entities/post.dart';
import 'package:posts_app/features/posts/presentation/screens/post_details_screen.dart';

class PostListWidget extends StatelessWidget {
  final List<Post> posts;
  const PostListWidget({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (_, index) => ListTile(
        leading: Text(
          posts[index].id.toString(),
          style: const TextStyle(fontSize: 18),
        ),
        title: Text(
          posts[index].title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          posts[index].body,
          style: const TextStyle(fontSize: 16),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        isThreeLine: true,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => PostDetailsScreen(posts[index])));
        },
      ),
      separatorBuilder: (_, index) => const Divider(thickness: 0.1),
      itemCount: posts.length,
    );
  }
}
