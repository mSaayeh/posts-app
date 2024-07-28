import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:posts_app/core/network/network_info.dart';
import 'package:posts_app/features/posts/data/datasources/post_local_data_source.dart';
import 'package:posts_app/features/posts/data/datasources/post_remote_data_source.dart';
import 'package:posts_app/features/posts/data/repositories/posts_repository_impl.dart';
import 'package:posts_app/features/posts/domain/repositories/posts_repository.dart';
import 'package:posts_app/features/posts/domain/usecases/add_post_usecase.dart';
import 'package:posts_app/features/posts/domain/usecases/delete_post_usecase.dart';
import 'package:posts_app/features/posts/domain/usecases/get_all_posts_usecase.dart';
import 'package:posts_app/features/posts/domain/usecases/update_post_usecase.dart';
import 'package:posts_app/features/posts/presentation/bloc/post_details/post_details_bloc.dart';
import 'package:posts_app/features/posts/presentation/bloc/posts/posts_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // Features - posts ========
  // Bloc
  getIt.registerFactory(() => PostsBloc(getAllPostsUsecase: getIt()));
  getIt.registerFactory(
    () => PostDetailsBloc(
      addPostUsecase: getIt(),
      deletePostUsecase: getIt(),
      updatePostUsecase: getIt(),
    ),
  );

  // Usecases
  getIt.registerLazySingleton(() => GetAllPostsUsecase(getIt()));
  getIt.registerLazySingleton(() => AddPostUsecase(getIt()));
  getIt.registerLazySingleton(() => DeletePostUsecase(getIt()));
  getIt.registerLazySingleton(() => UpdatePostUsecase(getIt()));

  // Repository
  getIt.registerLazySingleton<PostsRepository>(
    () => PostsRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  // Data sources
  getIt.registerLazySingleton<PostLocalDataSource>(
      () => PostLocalDataSourceImpl(getIt()));
  getIt.registerLazySingleton<PostRemoteDataSource>(
      () => PostRemoteDataSourceImpl(getIt()));

  // Core ====================
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

  // External ================
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
  getIt.registerLazySingleton(() => http.Client());
  getIt.registerLazySingleton(() => InternetConnectionChecker());
}
