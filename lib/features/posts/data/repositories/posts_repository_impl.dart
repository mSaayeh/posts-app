import 'package:dartz/dartz.dart';
import 'package:posts_app/core/error/exceptions.dart';
import 'package:posts_app/core/error/failures.dart';
import 'package:posts_app/core/network/network_info.dart';
import 'package:posts_app/features/posts/data/datasources/post_local_data_source.dart';
import 'package:posts_app/features/posts/data/datasources/post_remote_data_source.dart';
import 'package:posts_app/features/posts/data/models/post_model.dart';
import 'package:posts_app/features/posts/domain/entities/post.dart';
import 'package:posts_app/features/posts/domain/repositories/posts_repository.dart';

class PostsRepositoryImpl implements PostsRepository {
  final PostRemoteDataSource remoteDataSource;
  final PostLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PostsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Post>>> getAllPosts() async {
    if (await networkInfo.isConnected) {
      try {
        await _refreshPosts();
      } on ServerException {
        return Left(ServerFailure());
      }
    }
    try {
      final localPosts = await localDataSource.getCachedPosts();
      return Right(localPosts);
    } on EmptyCacheException {
      return Left(EmptyCacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addPost(Post post) async {
    return _tryConnect(() async {
      final PostModel postModel = PostModel.fromEntity(post);
      final addedPost = await remoteDataSource.addPost(postModel);
      await localDataSource.cachePost(addedPost);
      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> deletePost(String postId) async {
    return _tryConnect(() async {
      await remoteDataSource.deletePost(postId);
      await localDataSource.deleteCachedPost(postId);
      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> updatePost(Post post) async {
    return _tryConnect(() async {
      final PostModel postModel = PostModel.fromEntity(post);
      final updatedPost = await remoteDataSource.updatePost(postModel);
      await localDataSource.updateCachedPost(updatedPost);
      return unit;
    });
  }

  Future<Either<Failure, T>> _tryConnect<T>(Future<T> Function() task) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await task());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  _refreshPosts() async {
    final remotePosts = await remoteDataSource.getAllPosts();
    await localDataSource.clearCache();
    await localDataSource.cachePosts(remotePosts);
  }
}
