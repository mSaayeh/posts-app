import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_app/core/error/failures.dart';
import 'package:posts_app/features/posts/domain/entities/post.dart';
import 'package:posts_app/features/posts/domain/usecases/get_all_posts_usecase.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final GetAllPostsUsecase getAllPostsUsecase;

  PostsBloc({
    required this.getAllPostsUsecase,
  }) : super(PostsInitial()) {
    on<PostsEvent>((event, emit) async {
      if (event is GetAllPostsEvent) {
        emit(LoadingPostsState());
        final postsEither = await getAllPostsUsecase();
        postsEither.fold(
          (failure) {
            emit(ErrorPostsState(errorMessage: _mapFailureToMessage(failure)));
          },
          (posts) {
            emit(LoadedPostsState(posts: posts));
          },
        );
      }
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure) {
      case ServerFailure():
        return "Please try again later.";
      case OfflineFailure():
        return "Please check your internet connection.";
      case EmptyCacheFailure():
        return "No Posts Available.";
    }
  }
}
