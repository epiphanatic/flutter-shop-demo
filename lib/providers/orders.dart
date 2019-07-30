import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../services/services.dart';
import '../providers/product.dart';
import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final Timestamp dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });

  factory OrderItem.fromMap(Map data, String documentID) {
    return OrderItem(
        id: documentID,
        amount: data['amount'],
        dateTime: data['dateTime'],
        products: (data['products'] as List ?? [])
            .map((v) => CartItem.fromMap(v))
            .toList());
  }
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  final uuid = new Uuid();

  Future fetchAndSetOrders() async {
    Collection<OrderItem> _colRef =
        Collection<OrderItem>(path: 'orders-shop-demo');
    try {
      final res = await _colRef.getData();
      if (res.length != 0) {
        _orders = res;
        // for (OrderItem item in res) {
        //   print(item.id);
        // }
        notifyListeners();
      } else {
        print('there appear to be no orders');
      }
    } catch (error) {
      // here is where you would send errors to DB in future.
      print('error: ' + error.toString());
      // throwing the error will let calling function know there was one and passses it
      throw error;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    // add to DB
    Collection<Product> _colRef = Collection<Product>(path: 'orders-shop-demo');
    final Timestamp dateTime = Timestamp.now();
    try {
      final res = await _colRef.addDoc(
        ({
          'amount': total,
          'dateTime': dateTime,
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price
                  })
              .toList(),
        }),
      );

      // add to local (although this could also be a stream instead)
      /// using insert 0 to add to beginning of list so that most recent
      /// orders are at the beginnning
      _orders.insert(
        0,
        OrderItem(
          id: res.documentID,
          amount: total,
          dateTime: dateTime,
          products: cartProducts,
        ),
      );
      notifyListeners();
      // _items.insert(0, newProduct); // at the start of the list
    } catch (error) {
      // here is where you would send errors to DB in future.
      print('error: ' + error.toString());
      // throwing the error will let calling function know there was one and passses it
      throw error;
    }
  }
}
