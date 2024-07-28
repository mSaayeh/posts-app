part of 'posts_bloc.dart';

sealed class PostsState extends Equatable {
  const PostsState();

  @override
  List<Object> get props => [];
}

final class PostsInitial extends PostsState {}

final class LoadingPostsState extends PostsState {}

final class LoadedPostsState extends PostsState {
  final List<Post> posts;

  const LoadedPostsState({required this.posts});

  @override
  List<Object> get props => [posts];
}

final class ErrorPostsState extends PostsState {
  final String errorMessage;

  const ErrorPostsState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
