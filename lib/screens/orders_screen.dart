import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';
import '../widgets/loader.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

//   @override
//   _OrdersScreenState createState() => _OrdersScreenState();
// }

// class _OrdersScreenState extends State<OrdersScreen> {
  // bool _isLoading = false;
  // bool _isInit = true;

  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     Provider.of<Orders>(context).fetchAndSetOrders().then((_) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     });
  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  // @override
  // void initState() {
  //   /// using future delayed here to contrast with using didChangeDependencies in overview
  //   Future.delayed(Duration.zero).then((_) {
  //     // setState(() {
  //     //   _isLoading = true;
  //     // });
  //     Provider.of<Orders>(context).fetchAndSetOrders().then((_) {
  //       // setState(() {
  //       //   _isLoading = false;
  //       // });
  //     });
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    FirebaseUser _user = Provider.of<FirebaseUser>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false)
            .fetchAndSetOrders(_user.uid),
        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Loader(),
            );
          } else {
            if (snapshot.error != null) {
              // do error handling stuff
              return Center(
                child: Text('An error occurred!'),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                ),
              );
            }
          }
          // switch (snapshot.connectionState) {
          //   case ConnectionState.active:
          //     return Center(
          //       child: Text('Connection is active'),
          //     );
          //   case ConnectionState.waiting:
          //     return Center(child: Text('Awaiting result...'));
          //   case ConnectionState.done:
          //     if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          //     return Center(child: Text('Result: ${snapshot.data}'));
          //   case ConnectionState.none:
          //     return null;
          // }
        },
      ),
    );
  }
}
