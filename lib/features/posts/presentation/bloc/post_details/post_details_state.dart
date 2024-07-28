part of 'post_details_bloc.dart';

sealed class PostDetailsState extends Equatable {
  const PostDetailsState();

  @override
  List<Object> get props => [];
}

final class PostDetailsInitial extends PostDetailsState {}

final class LoadingPostDetailsState extends PostDetailsState {}

final class SuccessPostDetailsState extends PostDetailsState {
  final String message;

  const SuccessPostDetailsState({required this.message});

  @override
  List<Object> get props => [message];
}

final class ErrorPostDetailsState extends PostDetailsState {
  final String errorMessage;

  const ErrorPostDetailsState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
