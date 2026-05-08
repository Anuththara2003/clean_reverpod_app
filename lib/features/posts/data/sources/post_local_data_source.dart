import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post_model.dart';

abstract class PostLocalDataSource {
  Future<void> cachePosts(List<PostModel> postsToCache);
  Future<List<PostModel>> getLastPosts();
}

class PostLocalDataSourceImpl implements PostLocalDataSource {
  final SharedPreferences sharedPreferences;
  PostLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cachePosts(List<PostModel> postsToCache) {
    final List<String> postJsonList = postsToCache
        .map((post) => json.encode({
      'id': post.id,
      'userId': post.userId,
      'title': post.title,
      'body': post.body,
    }))
        .toList();
    return sharedPreferences.setStringList('CACHED_POSTS', postJsonList);
  }

  @override
  Future<List<PostModel>> getLastPosts() {
    final jsonList = sharedPreferences.getStringList('CACHED_POSTS');
    if (jsonList != null) {
      return Future.value(jsonList
          .map((post) => PostModel.fromJson(json.decode(post)))
          .toList());
    }
    return Future.value([]);
  }
}