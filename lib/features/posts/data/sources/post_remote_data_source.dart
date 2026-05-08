import 'package:dio/dio.dart';
import '../models/post_model.dart';

abstract class PostRemoteDataSource {
  Future<List<PostModel>> getPosts();
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final Dio dio;
  PostRemoteDataSourceImpl(this.dio);

  @override
  Future<List<PostModel>> getPosts() async {
    final response = await dio.get('https://jsonplaceholder.typicode.com/posts');
    final List data = response.data;
    return data.map((e) => PostModel.fromJson(e)).toList();
  }
}