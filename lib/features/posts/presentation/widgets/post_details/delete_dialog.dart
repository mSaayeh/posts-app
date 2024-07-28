import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_app/features/posts/presentation/bloc/post_details/post_details_bloc.dart';

class DeleteDialog extends StatelessWidget {
  final String postId;
  const DeleteDialog(this.postId, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Are you sure?"),
      content: const Text("This action can't be reverted."),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("No")),
        TextButton(
            onPressed: () {
              BlocProvider.of<PostDetailsBloc>(context)
                  .add(DeletePostEvent(postId));
            },
            child: const Text("Yes")),
      ],
    );
  }
}
