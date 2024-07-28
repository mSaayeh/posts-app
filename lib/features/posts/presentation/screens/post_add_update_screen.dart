import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_app/core/widgets/loading_widget.dart';
import 'package:posts_app/features/posts/domain/entities/post.dart';
import 'package:posts_app/features/posts/presentation/bloc/post_details/post_details_bloc.dart';
import 'package:posts_app/features/posts/presentation/screens/posts_screen.dart';
import 'package:posts_app/features/posts/presentation/widgets/post_add_update/post_form_widget.dart';
import 'package:posts_app/injection_container.dart' as di;

class PostAddUpdateScreen extends StatelessWidget {
  final Post? post;

  const PostAddUpdateScreen({super.key, this.post});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.getIt<PostDetailsBloc>(),
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  Center _buildBody() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: BlocConsumer<PostDetailsBloc, PostDetailsState>(
          listener: (context, state) {
            if (state is SuccessPostDetailsState) {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (ctx) => const PostsScreen()),
                (route) => false,
              );
            } else if (state is ErrorPostDetailsState) {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.errorMessage,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is LoadingPostDetailsState) {
              return const LoadingWidget();
            }
            return PostFormWidget(post: post);
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(post == null ? "Add Post" : "Edit Post"),
    );
  }
}
