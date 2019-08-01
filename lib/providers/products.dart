import 'package:flutter/material.dart';
import '../services/services.dart';
import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  // var _showFavoritesOnly = false;

  /// The reason for using a getter here is that if you returned _items you
  /// would have access to the list itself, can mutate it, etc.
  /// returning a copy just get the information stored there.
  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchAndSetProducts({String uid, bool filterByUser}) async {
    // if filterByUser was passed in and is true, then you are getting only
    // their products, ie you are on the manage products page
    _items = [];
    print('filter by user: ' + filterByUser.toString());
    var _products;
    // Collection<Product> _products =
    //     Collection<Product>(path: 'products-shop-demo');
    _products = (filterByUser == true)
        ? CollectionUserProducts<Product>(path: 'products-shop-demo', uid: uid)
        : Collection<Product>(path: 'products-shop-demo');
    Document<Map> _userFavs =
        Document<Map>(path: 'userFavorites-shop-demo/$uid');
    final _resFavs = await _userFavs.getDataNoTyping();

    /// an cleaner solution here would be to figure out how to model a dynamic
    /// product id or model it differently, but this works for now.
    try {
      final res = await _products.getData();
      if (res.length != 0) {
        for (Product prod in res) {
          bool _skipFav = false;
          if (_resFavs == null) {
            // there is no entry for user
            _skipFav = true;
          } else {
            if (_resFavs[prod.id] == null) {
              // either favorites ! exist or the product doesn't exist in favorites if it does
              _skipFav = true;
            }
          }
          _items.add(Product(
              id: prod.id,
              description: prod.description,
              imageUrl: prod.imageUrl,
              price: prod.price,
              title: prod.title,
              isFavorite: _skipFav == true
                  ? false
                  : _resFavs[prod.id]['isFavorite'] ?? false));
        }
        notifyListeners();
      }
    } catch (error) {
      // here is where you would send errors to DB in future.
      print('error: ' + error.toString());
      // throwing the error will let calling function know there was one and passses it
      throw error;
    }
  }

  Future<void> addProduct({Product product, String uid, String email}) async {
    // add to DB
    Collection<Product> _colRef =
        Collection<Product>(path: 'products-shop-demo');
    try {
      final res = await _colRef.addDoc(
        ({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'creatorUid': uid,
          'creatorEmail': email
        }),
      );

      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: res.documentID,
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (error) {
      // here is where you would send errors to DB in future.
      print('error: ' + error.toString());
      // throwing the error will let calling function know there was one and passses it
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    Document<Product> _docRef =
        Document<Product>(path: 'products-shop-demo/$id');
    try {
      await _docRef.upsert(
        ({
          'title': newProduct.title,
          'description': newProduct.description,
          'price': newProduct.price,
          'imageUrl': newProduct.imageUrl,
        }),
      );
      final prodIndex = _items.indexWhere((prod) => prod.id == id);
      if (prodIndex >= 0) {
        _items[prodIndex] = newProduct;
        notifyListeners();
      } else {
        print('could not find local products to update...');
      }
    } catch (error) {
      // here is where you would send errors to DB in future.
      print('error: ' + error.toString());
      // throwing the error will let calling function know there was one and passses it
      throw error;
    }
  }

  void deleteProduct(String id) {
    Document<Product> _docRef =
        Document<Product>(path: 'products-shop-demo/$id');
    _items.removeWhere((prod) => prod.id == id);
    _docRef.delete();
    notifyListeners();
    // Note: firestore doesn't return anything on a delte, so there is no way
    // to catch/handle errors.
    // final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    // var existingProduct = _items[existingProductIndex];
    // try {
    //   _items.removeWhere((prod) => prod.id == id);
    //   await _docRef.delete();
    //   existingProduct = null;
    //   notifyListeners();
    // } catch (error) {
    //   // put back the item if delete failed.
    //   _items.insert(existingProductIndex, existingProduct);
    //   notifyListeners();
    //   // here is where you would send errors to DB in future.
    //   print('error: ' + error.toString());
    //   // throwing the error will let calling function know there was one and passses it
    //   throw error;
    // }
  }
}
