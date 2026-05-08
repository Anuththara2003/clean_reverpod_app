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
  return data.map((e) => Post.fromJson(e)).toList();
});


final postDetailProvider = FutureProvider.family<Post, int>((ref, id) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get('/posts/$id');
  return Post.fromJson(response.data);
});


final commentsProvider = FutureProvider.family<List<dynamic>, int>((ref, postId) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get('/posts/$postId/comments');
  return response.data as List;
});