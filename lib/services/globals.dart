import '../providers/product.dart';
import '../providers/orders.dart';
import '../providers/cart.dart';

class Global {
  // App Data
  static final String title = 'Shop Demo';

  // Data Models
  static final Map models = {
    Product: (data, documentID) => Product.fromMap(data, documentID),
    OrderItem: (data, documentID) => OrderItem.fromMap(data, documentID),
    CartItem: (data) => CartItem.fromMap(data)
  };
}
