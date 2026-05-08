import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/posts_provider.dart';
import 'cart_page.dart';
import 'post_detail_page.dart';

class PostsListPage extends ConsumerWidget {
  const PostsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(filteredPostsProvider);
    final cartCount = ref.watch(cartProvider).length;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("PRO STORE", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Badge(label: Text('$cartCount'), child: const Icon(Icons.shopping_cart)),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage())),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search products...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
              ),
              onChanged: (value) => ref.read(searchQueryProvider.notifier).state = value,
            ),
          ),
          Expanded(
            child: postsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
              data: (posts) => GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.7, crossAxisSpacing: 12, mainAxisSpacing: 12,
                ),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PostDetailPage(post: post))),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        children: [
                          Expanded(child: Padding(padding: const EdgeInsets.all(10), child: Image.network(post.image, fit: BoxFit.contain))),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(post.title, maxLines: 1, style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text("\$${post.price}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                                ElevatedButton(onPressed: () => ref.read(cartProvider.notifier).addToCart(post), child: const Text("Add")),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}