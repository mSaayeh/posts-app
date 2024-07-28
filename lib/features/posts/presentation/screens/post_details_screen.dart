import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_app/features/posts/domain/entities/post.dart';
import 'package:posts_app/features/posts/presentation/bloc/post_details/post_details_bloc.dart';
import 'package:posts_app/features/posts/presentation/widgets/post_details/post_details_widget.dart';
import 'package:posts_app/injection_container.dart';

class PostDetailsScreen extends StatelessWidget {
  final Post post;

  const PostDetailsScreen(this.post, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostDetailsBloc>(
      create: (context) => getIt<PostDetailsBloc>(),
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  _buildAppBar() => AppBar(
        title: const Text("Post Details"),
      );

  _buildBody() => Padding(
        padding: const EdgeInsets.all(10),
        child: PostDetailsWidget(post),
      );
}
