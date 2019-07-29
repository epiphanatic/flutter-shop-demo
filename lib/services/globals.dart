import '../providers/product.dart';

class Global {
  // App Data
  static final String title = 'Shop Demo';

  // Data Models
  static final Map models = {
    Product: (data, documentID) => Product.fromMap(data, documentID)
  };
}
