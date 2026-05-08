import 'package:dio/dio.dart';
import 'package:clean_riverpod_app/features/posts/data/models/post_model.dart';

abstract class PostRemoteDataSource {
  Future<List<PostModel>> getPosts();
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final Dio dio;
  PostRemoteDataSourceImpl(this.dio);

  @override
  Future<List<PostModel>> getPosts() async {
    final response = await dio.get('https://jsonplaceholder.typicode.com/posts');

    if (response.statusCode == 200) {
      final List data = response.data;
      return data.map((json) => PostModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }
}