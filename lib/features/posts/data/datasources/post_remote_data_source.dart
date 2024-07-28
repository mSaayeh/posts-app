import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:posts_app/core/error/exceptions.dart';
import 'package:posts_app/features/posts/data/models/post_model.dart';

abstract class PostRemoteDataSource {
  Future<List<PostModel>> getAllPosts();
  Future<Unit> deletePost(String postId);
  Future<PostModel> updatePost(PostModel post);
  Future<PostModel> addPost(PostModel post);
}

const _BASE_URL = "https://664a50bda300e8795d41a188.mockapi.io";

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final http.Client client;

  PostRemoteDataSourceImpl(this.client);

  @override
  Future<List<PostModel>> getAllPosts() async {
    final response = await client.get(Uri.parse("$_BASE_URL/posts"));

    if (response.statusCode == 200) {
      final List decodedJson = json.decode(response.body);
      final postModelsList = decodedJson
          .map((postModelJson) => PostModel.fromJson(postModelJson))
          .toList();
      return postModelsList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<PostModel> addPost(PostModel post) async {
    final body = {
      'title': post.title,
      'body': post.body,
    };
    final response = await http.post(Uri.parse("$_BASE_URL/posts"), body: body);
    if (response.statusCode == 201) {
      final decodedJson = json.decode(response.body);
      final addedPost = PostModel.fromJson(decodedJson);
      return addedPost;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> deletePost(String postId) async {
    final response = await http.delete(Uri.parse("$_BASE_URL/posts/$postId"));
    if (response.statusCode == 200) {
      return unit;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<PostModel> updatePost(PostModel post) async {
    final body = {
      'title': post.title,
      'body': post.body,
    };
    final response =
        await http.put(Uri.parse("$_BASE_URL/posts/${post.id}"), body: body);
    if (response.statusCode == 200) {
      final decodedJson = json.decode(response.body);
      final addedPost = PostModel.fromJson(decodedJson);
      return addedPost;
    } else {
      throw ServerException();
    }
  }
}
