import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  factory Product.fromMap(Map data, String documentID) {
    return Product(
        id: documentID,
        title: data['title'],
        description: data['description'],
        price: data['price'],
        imageUrl: data['imageUrl'],
        isFavorite: data['isFavorite']);
  }

  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
