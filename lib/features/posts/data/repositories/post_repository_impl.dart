import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../sources/post_remote_data_source.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;

  PostRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Post>> getPosts() async {

    return await remoteDataSource.getPosts();
  }

  @override
  Future<Post> getPostById(int id) async {

    throw UnimplementedError();
  }
}