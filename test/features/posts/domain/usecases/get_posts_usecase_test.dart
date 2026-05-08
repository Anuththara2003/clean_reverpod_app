import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:clean_riverpod_app/features/posts/domain/entities/post.dart';
import 'package:clean_riverpod_app/features/posts/domain/repositories/post_repository.dart';
import 'package:clean_riverpod_app/features/posts/domain/usecases/get_posts_usecase.dart';

class MockPostRepository extends Mock implements PostRepository {}

void main() {
  late GetPostsUseCase usecase;
  late MockPostRepository mockPostRepository;

  setUp(() {
    mockPostRepository = MockPostRepository();
    usecase = GetPostsUseCase(mockPostRepository);
  });

  final tPosts = [
    Post(
        id: 1,
        title: 'Test Product',
        price: 20.0,
        description: 'Test Description',
        category: 'electronics', // <--- මෙන්න මේක අඩුවෙලා තිබුණේ
        image: 'https://i.pravatar.cc/150'
    )
  ];

  test('should get posts from the repository', () async {
    when(() => mockPostRepository.getPosts()).thenAnswer((_) async => tPosts);

    final result = await usecase.call();

    expect(result, tPosts);
    verify(() => mockPostRepository.getPosts()).called(1);
  });
}