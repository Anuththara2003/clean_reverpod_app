import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/post_repository_impl.dart';
import '../../data/sources/post_remote_data_source.dart';
import '../../domain/usecases/get_posts_usecase.dart';

// 1. Dio Provider
final dioProvider = Provider((ref) => Dio());

// 2. Data Source Provider
final postRemoteDataSourceProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return PostRemoteDataSourceImpl(dio);
});

// 3. Repository Provider
final postRepositoryProvider = Provider((ref) {
  final remoteDataSource = ref.watch(postRemoteDataSourceProvider);
  return PostRepositoryImpl(remoteDataSource);
});

// 4. Use Case Provider
final getPostsUseCaseProvider = Provider((ref) {
  final repository = ref.watch(postRepositoryProvider);
  return GetPostsUseCase(repository);
});

// 5. Final UI Provider
final postsProvider = FutureProvider((ref) async {
  final getPostsUseCase = ref.watch(getPostsUseCaseProvider);
  return await getPostsUseCase();
});