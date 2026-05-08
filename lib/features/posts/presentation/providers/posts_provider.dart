import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/sources/post_remote_data_source.dart';
import '../../domain/entities/post.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final dioProvider = Provider((ref) => Dio());


final postsProvider = FutureProvider<List<Post>>((ref) async {
  final source = PostRemoteDataSourceImpl(ref.watch(dioProvider));
  return await source.getPosts();
});


final searchQueryProvider = StateProvider<String>((ref) => "");

final filteredPostsProvider = Provider<AsyncValue<List<Post>>>((ref) {
  final postsAsync = ref.watch(postsProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();

  return postsAsync.whenData((posts) {
    if (query.isEmpty) return posts;
    return posts.where((p) => p.title.toLowerCase().contains(query)).toList();
  });
});

// --- 4. Shopping Cart Logic ---
class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addToCart(Post post) {
    final idx = state.indexWhere((item) => item.post.id == post.id);
    if (idx >= 0) {
      state = [for (final item in state) if (item.post.id == post.id) CartItem(post: item.post, quantity: item.quantity + 1) else item];
    } else {
      state = [...state, CartItem(post: post, quantity: 1)];
    }
  }

  void removeFromCart(int id) => state = state.where((item) => item.post.id != id).toList();
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) => CartNotifier());