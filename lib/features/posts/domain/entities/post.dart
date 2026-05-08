class Post {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;

  Post({required this.id, required this.title, required this.price, required this.description, required this.category, required this.image});
}

class CartItem {
  final Post post;
  final int quantity;
  CartItem({required this.post, required this.quantity});
}