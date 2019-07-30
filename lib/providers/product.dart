import 'package:flutter/foundation.dart';
import '../services/services.dart';

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

  Future<void> toggleFavoriteStatus() async {
    /// NOTE: again, is kind of thing will never throw an error since setData
    /// doesn't return anything from firestore
    bool oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    Document<Product> _docRef =
        Document<Product>(path: 'products-shop-demo/$id');
    try {
      await _docRef.upsert(({'isFavorite': isFavorite}));
    } catch (error) {
      isFavorite = oldStatus;
      notifyListeners();
      // here is where you would send errors to DB in future.
      print('error: ' + error.toString());
      // throwing the error will let calling function know there was one and passses it
      throw error;
    }
  }
}
