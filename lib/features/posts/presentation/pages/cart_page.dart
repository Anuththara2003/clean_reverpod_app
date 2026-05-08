import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/posts_provider.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("Your Cart")),
      body: cartItems.isEmpty
          ? const Center(child: Text("Empty"))
          : ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          return ListTile(
            leading: Image.network(item.post.image, width: 40),
            title: Text(item.post.title),
            trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => ref.read(cartProvider.notifier).removeFromCart(item.post.id)),
          );
        },
      ),
    );
  }
}