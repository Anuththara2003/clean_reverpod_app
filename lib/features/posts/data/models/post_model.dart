import '../../domain/entities/post.dart';

class PostModel extends Post {
  PostModel({required super.id, required super.title, required super.price, required super.description, required super.category, required super.image});

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      category: json['category'],
      image: json['image'],
    );
  }
}