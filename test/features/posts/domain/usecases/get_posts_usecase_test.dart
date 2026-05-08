import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:clean_riverpod_app/features/posts/domain/entities/post.dart';
import 'package:clean_riverpod_app/features/posts/domain/repositories/post_repository.dart';
import 'package:clean_riverpod_app/features/posts/domain/usecases/get_posts_usecase.dart';

// Repository එක Mock කිරීම සඳහා
class MockPostRepository extends Mock implements PostRepository {}

void main() {
  late GetPostsUseCase usecase;
  late MockPostRepository mockPostRepository;

  setUp(() {
    mockPostRepository = MockPostRepository();
    usecase = GetPostsUseCase(mockPostRepository);
  });

  final tPosts = [
    Post(id: 1, userId: 1, title: 'Test Title', body: 'Test Body')
  ];

  test('should get posts from the repository', () async {
    // Arrange: Repository එකෙන් data එනවා කියලා ලෑස්ති කරනවා
    when(() => mockPostRepository.getPosts()).thenAnswer((_) async => tPosts);

    // Act: Use case එක run කරනවා
    final result = await usecase.call();

    // Assert: ලැබුණු දත්ත නිවැරදිද බලනවා
    expect(result, tPosts);
    verify(() => mockPostRepository.getPosts()).called(1);
    verifyNoMoreInteractions(mockPostRepository);
  });
}