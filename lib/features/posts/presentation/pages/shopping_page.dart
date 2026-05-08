import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product.dart';
import '../providers/cart_provider.dart';

class ShoppingPage extends ConsumerWidget {
  const ShoppingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final products = [
      Product(id: '1', name: 'Laptop', price: 250000),
      Product(id: '2', name: 'Phone', price: 150000),
      Product(id: '3', name: 'Keyboard', price: 5000),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping Mall"),
        actions: [
          IconButton(
            icon: Badge(
              label: Text('${cart.totalCount}'),
              child: const Icon(Icons.shopping_cart),
            ),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final p = products[index];
          return ListTile(
            title: Text(p.name),
            subtitle: Text('Rs. ${p.price}'),
            trailing: ElevatedButton(
              onPressed: () => ref.read(cartProvider.notifier).addItem(p),
              child: const Text("Add to Cart"),
            ),
          );
        },
      ),
    );
  }
}

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("My Cart")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final item = cart.items[index];
                return ListTile(
                  title: Text(item.product.name),
                  subtitle: Text('Rs. ${item.product.price} x ${item.quantity}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.remove), onPressed: () => ref.read(cartProvider.notifier).decrementQuantity(item.product.id)),
                      IconButton(icon: const Icon(Icons.add), onPressed: () => ref.read(cartProvider.notifier).incrementQuantity(item.product.id)),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text("Total: Rs. ${cart.totalPrice}", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}