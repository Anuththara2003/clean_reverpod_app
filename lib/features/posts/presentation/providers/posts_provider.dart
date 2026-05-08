import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:clean_riverpod_app/features/posts/data/repositories/post_repository_impl.dart';
import 'package:clean_riverpod_app/features/posts/data/sources/post_remote_data_source.dart';
import 'package:clean_riverpod_app/features/posts/data/sources/post_local_data_source.dart';
import 'package:clean_riverpod_app/features/posts/domain/repositories/post_repository.dart';
import 'package:clean_riverpod_app/features/posts/domain/usecases/get_posts_usecase.dart';
import 'package:clean_riverpod_app/features/posts/domain/entities/post.dart';

// 1. SharedPreferences Provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

// 2. Dio Provider
final dioProvider = Provider((ref) => Dio());

// 3. Data Sources
final postRemoteDataSourceProvider = Provider<PostRemoteDataSource>((ref) {
  return PostRemoteDataSourceImpl(ref.watch(dioProvider));
});

final postLocalDataSourceProvider = Provider<PostLocalDataSource>((ref) {
  return PostLocalDataSourceImpl(ref.watch(sharedPreferencesProvider));
});

// 4. Repository (දැන් remote සහ local දෙකම inject කරනවා)
final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepositoryImpl(
    remoteDataSource: ref.watch(postRemoteDataSourceProvider),
    localDataSource: ref.watch(postLocalDataSourceProvider),
  );
});

// 5. Use Case
final getPostsUseCaseProvider = Provider((ref) {
  return GetPostsUseCase(ref.watch(postRepositoryProvider));
});

// 6. UI Providers
final postsProvider = FutureProvider<List<Post>>((ref) async {
  return await ref.watch(getPostsUseCaseProvider).call();
});

final postDetailProvider = FutureProvider.family<Post, int>((ref, id) async {
  return await ref.watch(postRepositoryProvider).getPostById(id);
});