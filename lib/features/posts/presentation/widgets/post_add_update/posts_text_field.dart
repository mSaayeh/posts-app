import 'package:flutter/material.dart';

class PostsTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int lines;
  const PostsTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.lines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
      child: TextFormField(
        controller: controller,
        validator: (value) =>
            (value?.isEmpty ?? true) ? "$hint Can't be empty." : null,
        decoration: InputDecoration(
          hintText: hint,
        ),
        minLines: lines,
        maxLines: lines,
      ),
    );
  }
}
