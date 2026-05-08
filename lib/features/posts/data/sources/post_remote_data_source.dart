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
    final response = await dio.get('https://fakestoreapi.com/products');
    final List data = response.data;
    return data.map((json) => PostModel.fromJson(json)).toList();
  }
}