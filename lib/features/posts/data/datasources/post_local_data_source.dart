import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:posts_app/core/error/exceptions.dart';
import 'package:posts_app/features/posts/data/models/post_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PostLocalDataSource {
  Future<List<PostModel>> getCachedPosts();
  Future<Unit> cachePosts(List<PostModel> postModels);
  Future<Unit> cachePost(PostModel postModel);
  Future<Unit> updateCachedPost(PostModel postModel);
  Future<Unit> clearCache();
  Future<Unit> deleteCachedPost(String postId);
}

const _POSTS_CACHE_KEY = "POSTS";

class PostLocalDataSourceImpl implements PostLocalDataSource {
  final SharedPreferences sharedPreferences;

  PostLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<Unit> cachePosts(List<PostModel> postModels) async {
    List<Map<String, dynamic>> postModelsToJson =
        postModels.map((postModel) => postModel.toJson()).toList();
    await sharedPreferences.setString(
        _POSTS_CACHE_KEY, json.encode(postModelsToJson));
    return unit;
  }

  @override
  Future<List<PostModel>> getCachedPosts() {
    final String? postModelsJson =
        sharedPreferences.getString(_POSTS_CACHE_KEY);
    List<PostModel> postModels = [];
    if (postModelsJson != null) {
      List decodedJson = json.decode(postModelsJson);
      postModels = decodedJson
          .map((postModelJson) => PostModel.fromJson(postModelJson))
          .toList();
      return Future.value(postModels);
    }
    throw EmptyCacheException();
  }

  @override
  Future<Unit> cachePost(PostModel postModel) async {
    late List<PostModel> cachedPosts;
    try {
      cachedPosts = await getCachedPosts();
    } on EmptyCacheException {
      cachedPosts = [];
    }
    cachedPosts.add(postModel);
    await cachePosts(cachedPosts);
    return unit;
  }

  @override
  Future<Unit> clearCache() async {
    await sharedPreferences.remove(_POSTS_CACHE_KEY);
    return unit;
  }

  @override
  Future<Unit> deleteCachedPost(String postId) async {
    late List<PostModel> cachedPosts;
    try {
      cachedPosts = await getCachedPosts();
    } on EmptyCacheException {
      rethrow;
    }
    cachedPosts.removeWhere((postModel) => postModel.id == postId);
    await cachePosts(cachedPosts);
    return unit;
  }

  @override
  Future<Unit> updateCachedPost(PostModel postModel) async {
    late List<PostModel> cachedPosts;
    try {
      cachedPosts = await getCachedPosts();
    } on EmptyCacheException {
      rethrow;
    }
    cachedPosts.map((item) => item.id == postModel.id ? postModel : item);
    await cachePosts(cachedPosts);
    return unit;
  }
}
