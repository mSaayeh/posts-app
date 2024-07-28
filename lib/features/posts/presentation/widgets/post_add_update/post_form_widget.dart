import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_app/features/posts/domain/entities/post.dart';
import 'package:posts_app/features/posts/presentation/bloc/post_details/post_details_bloc.dart';
import 'package:posts_app/features/posts/presentation/widgets/post_add_update/posts_text_field.dart';

class PostFormWidget extends StatefulWidget {
  final Post? post;

  const PostFormWidget({this.post, super.key});

  @override
  State<PostFormWidget> createState() => _PostFormWidgetState();
}

class _PostFormWidgetState extends State<PostFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.post != null) {
      _titleController.text = widget.post!.title;
      _bodyController.text = widget.post!.body;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _bodyController.dispose();
  }

  void _validateAndSubmit() {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final Post submittedPost = Post(
        id: widget.post?.id ?? "-1",
        title: _titleController.text,
        body: _bodyController.text,
      );
      if (widget.post == null) {
        BlocProvider.of<PostDetailsBloc>(context)
            .add(AddPostEvent(submittedPost));
      } else {
        BlocProvider.of<PostDetailsBloc>(context)
            .add(UpdatePostEvent(submittedPost));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PostsTextField(controller: _titleController, hint: "Title"),
          PostsTextField(
            controller: _bodyController,
            hint: "Body",
            lines: 6,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: _validateAndSubmit,
              label: Text(widget.post == null ? "Add" : "Edit"),
              icon: Icon(widget.post == null ? Icons.add : Icons.edit),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Theme.of(context).secondaryHeaderColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
