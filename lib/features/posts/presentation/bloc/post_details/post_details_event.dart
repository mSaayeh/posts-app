part of 'post_details_bloc.dart';

sealed class PostDetailsEvent extends Equatable {
  const PostDetailsEvent();

  @override
  List<Object?> get props => [];
}

final class AddPostEvent extends PostDetailsEvent {
  final Post post;

  const AddPostEvent(this.post);

  @override
  List<Object?> get props => [post];
}

final class UpdatePostEvent extends PostDetailsEvent {
  final Post post;

  const UpdatePostEvent(this.post);

  @override
  List<Object?> get props => [post];
}

final class DeletePostEvent extends PostDetailsEvent {
  final String postId;

  const DeletePostEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}
