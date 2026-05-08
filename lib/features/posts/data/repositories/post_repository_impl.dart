import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../sources/post_remote_data_source.dart';
import '../sources/post_local_data_source.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;
  final PostLocalDataSource localDataSource;

  PostRepositoryImpl({required this.remoteDataSource, required this.localDataSource});

  @override
  Future<List<Post>> getPosts() async {
    try {
      final remotePosts = await remoteDataSource.getPosts();
      await localDataSource.cachePosts(remotePosts);
      return remotePosts;
    } catch (e) {
      // Internet නැති වෙලාවට cache එකෙන් පෙන්වයි
      final localPosts = await localDataSource.getLastPosts();
      if (localPosts.isNotEmpty) {
        return localPosts;
      }
      throw Exception("No data available");
    }
  }

  @override
  Future<Post> getPostById(int id) async {
    final posts = await getPosts();
    return posts.firstWhere((post) => post.id == id);
  }
}