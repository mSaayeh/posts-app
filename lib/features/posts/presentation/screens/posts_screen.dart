import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_app/core/widgets/loading_widget.dart';
import 'package:posts_app/features/posts/presentation/bloc/posts/posts_bloc.dart';
import 'package:posts_app/features/posts/presentation/screens/post_add_update_screen.dart';
import 'package:posts_app/features/posts/presentation/widgets/posts/message_display_widget.dart';
import 'package:posts_app/features/posts/presentation/widgets/posts/post_list_widget.dart';
import 'package:posts_app/injection_container.dart' as di;

class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.getIt<PostsBloc>()..add(GetAllPostsEvent()),
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
        floatingActionButton: _buildFAB(context),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text("Posts"),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: BlocBuilder<PostsBloc, PostsState>(
        builder: (context, state) {
          if (state is LoadingPostsState) {
            return const LoadingWidget();
          } else if (state is LoadedPostsState) {
            return RefreshIndicator(
                onRefresh: () => _onRefresh(context),
                child: PostListWidget(posts: state.posts));
          } else if (state is ErrorPostsState) {
            return MessageDisplayWidget(
              message: state.errorMessage,
            );
          }
          return const LoadingWidget();
        },
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (ctx) => const PostAddUpdateScreen()));
      },
      child: const Icon(Icons.add),
    );
  }

  Future<void> _onRefresh(BuildContext context) async {
    BlocProvider.of<PostsBloc>(context).add(GetAllPostsEvent());
  }
}
