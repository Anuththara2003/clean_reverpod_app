import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/post.dart';

final dioProvider = Provider((ref) => Dio(BaseOptions(baseUrl: 'https://jsonplaceholder.typicode.com')));

// Posts List
final postsProvider = FutureProvider.autoDispose<List<Post>>((ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get('/posts');
  final List data = response.data;
  return data.map((e) => Post.fromJson(e)).toList();
});

// Search Notifier
class SearchNotifier extends StateNotifier<AsyncValue<List<Post>>> {
  final Ref ref;
  SearchNotifier(this.ref) : super(const AsyncValue.data([]));

  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }
    state = const AsyncValue.loading();
    try {
      final dio = ref.read(dioProvider);
      final response = await dio.get('/posts?title_like=$query');
      final List data = response.data;
      state = AsyncValue.data(data.map((e) => Post.fromJson(e)).toList());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final searchProvider = StateNotifierProvider.autoDispose<SearchNotifier, AsyncValue<List<Post>>>((ref) {
  return SearchNotifier(ref);
});

// Detail & Comments
final postDetailProvider = FutureProvider.autoDispose.family<Post, int>((ref, id) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get('/posts/$id');
  return Post.fromJson(response.data);
});

final commentsProvider = FutureProvider.autoDispose.family<List<dynamic>, int>((ref, postId) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get('/posts/$postId/comments');
  return response.data as List;
});