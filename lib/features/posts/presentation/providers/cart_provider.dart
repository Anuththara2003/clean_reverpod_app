import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product.dart';
import 'cart_state.dart';

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(const CartState());

  void addItem(Product product) {
    final existingIndex = state.items.indexWhere((item) => item.product.id == product.id);

    if (existingIndex >= 0) {
      incrementQuantity(product.id);
    } else {
      state = state.copyWith(
        items: [...state.items, CartItem(product: product, quantity: 1)],
      );
      _updateTotals();
    }
  }

  void removeItem(String productId) {
    state = state.copyWith(
      items: state.items.where((item) => item.product.id != productId).toList(),
    );
    _updateTotals();
  }

  void incrementQuantity(String productId) {
    state = state.copyWith(
      items: [
        for (final item in state.items)
          if (item.product.id == productId)
            CartItem(product: item.product, quantity: item.quantity + 1)
          else
            item,
      ],
    );
    _updateTotals();
  }

  void decrementQuantity(String productId) {
    final item = state.items.firstWhere((item) => item.product.id == productId);
    if (item.quantity > 1) {
      state = state.copyWith(
        items: [
          for (final item in state.items)
            if (item.product.id == productId)
              CartItem(product: item.product, quantity: item.quantity - 1)
            else
              item,
        ],
      );
    } else {
      removeItem(productId);
    }
    _updateTotals();
  }

  void _updateTotals() {
    int count = 0;
    double total = 0;
    for (var item in state.items) {
      count += item.quantity;
      total += item.product.price * item.quantity;
    }
    state = state.copyWith(totalCount: count, totalPrice: total);
  }
}