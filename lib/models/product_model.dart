import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  static const ID = 'id';
  static const CREATED_AT = 'created_at';
  static const UPDATED_AT = 'updated_at';
  static const NAME = 'name';
  static const DESCRIPTION = 'description';
  static const IMAGE_URL = 'image_url';
  static const PRICE = 'price';
  static const CATEGORY = 'category';

  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String name;
  final String description;
  final String imageUrl;
  final String category;
  final String price;

  Product({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ID: id,
      CREATED_AT: FieldValue.serverTimestamp(),
      UPDATED_AT: FieldValue.serverTimestamp(),
      NAME: name,
      DESCRIPTION: description,
      IMAGE_URL: imageUrl,
      CATEGORY: category,
      PRICE: price,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map[ID] as String,
      createdAt: (map[CREATED_AT] as Timestamp).toDate(),
      updatedAt: (map[UPDATED_AT] as Timestamp).toDate(),
      name: map[NAME] as String,
      description: map[DESCRIPTION] as String,
      imageUrl: map[IMAGE_URL] as String,
      category: map[CATEGORY] as String,
      price: map[PRICE] as String,
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, name: $name, description: $description, imageUrl: $imageUrl,  price: $price)';
  }
}
