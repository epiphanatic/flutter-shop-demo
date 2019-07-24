import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  final uuid = new Uuid();

  void addOrder(List<CartItem> cartProducts, double total) {
    /// using insert 0 to add to beginning of list so that most recent
    /// orders are at the beginnning
    _orders.insert(
      0,
      OrderItem(
        id: uuid.v1(),
        amount: total,
        dateTime: DateTime.now(),
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
}
