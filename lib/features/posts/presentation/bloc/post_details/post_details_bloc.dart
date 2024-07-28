import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_app/core/error/failures.dart';
import 'package:posts_app/features/posts/domain/entities/post.dart';
import 'package:posts_app/features/posts/domain/usecases/add_post_usecase.dart';
import 'package:posts_app/features/posts/domain/usecases/delete_post_usecase.dart';
import 'package:posts_app/features/posts/domain/usecases/update_post_usecase.dart';

part 'post_details_event.dart';
part 'post_details_state.dart';

class PostDetailsBloc extends Bloc<PostDetailsEvent, PostDetailsState> {
  final AddPostUsecase addPostUsecase;
  final DeletePostUsecase deletePostUsecase;
  final UpdatePostUsecase updatePostUsecase;

  PostDetailsBloc({
    required this.addPostUsecase,
    required this.deletePostUsecase,
    required this.updatePostUsecase,
  }) : super(PostDetailsInitial()) {
    on<PostDetailsEvent>((event, emit) async {
      emit(LoadingPostDetailsState());
      if (event is AddPostEvent) {
        final postEither = await addPostUsecase(event.post);
        emit(
          _mapEitherToPostDetailsState(
            postEither,
            "Post Added Successfully.",
          ),
        );
      } else if (event is UpdatePostEvent) {
        final postEither = await updatePostUsecase(event.post);
        emit(
          _mapEitherToPostDetailsState(
            postEither,
            "Post Updated Successfully.",
          ),
        );
      } else if (event is DeletePostEvent) {
        final postEither = await deletePostUsecase(event.postId);
        emit(
          _mapEitherToPostDetailsState(
            postEither,
            "Post Deleted Successfully.",
          ),
        );
      }
    });
  }

  PostDetailsState _mapEitherToPostDetailsState(
      Either<Failure, Unit> either, String successMessage) {
    return either.fold(
      (failure) {
        return ErrorPostDetailsState(
            errorMessage: _mapFailureToMessage(failure));
      },
      (_) {
        return SuccessPostDetailsState(message: successMessage);
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure) {
      case ServerFailure():
        return "Please try again later.";
      case OfflineFailure():
        return "Please check your internet connection.";
      default:
        return "An Unknown error occurred.";
    }
  }
}
