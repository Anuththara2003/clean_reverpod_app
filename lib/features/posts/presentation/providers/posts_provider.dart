import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/post.dart';


final dioProvider = Provider((ref) => Dio(
  BaseOptions(baseUrl: 'https://jsonplaceholder.typicode.com'),
));


final postsProvider = FutureProvider<List<Post>>((ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get('/posts');


  final List data = response.data;
  return data.map((json) => Post.fromJson(json)).toList();
});