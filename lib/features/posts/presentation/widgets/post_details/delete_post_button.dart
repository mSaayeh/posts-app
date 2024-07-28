import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_app/core/widgets/loading_widget.dart';
import 'package:posts_app/features/posts/presentation/bloc/post_details/post_details_bloc.dart';
import 'package:posts_app/features/posts/presentation/screens/posts_screen.dart';
import 'package:posts_app/features/posts/presentation/widgets/post_details/delete_dialog.dart';

class DeletePostButton extends StatelessWidget {
  final String postId;
  const DeletePostButton(this.postId, {super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _showDeleteDialog(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      label: const Text("Delete"),
      icon: const Icon(Icons.delete),
    );
  }

  _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<PostDetailsBloc>(),
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
                MaterialPageRoute(builder: (_) => const PostsScreen()),
                (route) => false,
              );
            } else if (state is ErrorPostDetailsState) {
              Navigator.pop(context);
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
              return const AlertDialog(
                title: LoadingWidget(),
              );
            } else {
              return DeleteDialog(postId);
            }
          },
        ),
      ),
    );
  }
}
