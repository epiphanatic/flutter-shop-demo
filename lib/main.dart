import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/cart_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/auth.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './helpers/custom_route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        StreamProvider<FirebaseUser>.value(
          value: Auth().user,
        ),
        ChangeNotifierProvider.value(
          // set products to empty every time there is a change / load page
          value: Products(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: Orders(),
        ),
      ],
      child: Consumer<FirebaseUser>(
        builder: (ctx, user, child) => MaterialApp(
            title: 'My Shop',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
              // note here in builders you can have different transitions for different OSs
              // right now just using the same but could make another in custom_route
              pageTransitionsTheme: PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: CustomPageTransitionBuilder(),
                  TargetPlatform.iOS: CustomPageTransitionBuilder(),
                },
              ),
            ),

            /// this only works 100% if not logged in or already logged in, purpose being
            /// to not flicker by going to one page and then forwarding if already logged
            /// in. Therefore, if logging in and successful, forward to products overview
            /// from login page as this for whatever reason doesn't work. Without forwarding
            /// sometimes the screen changes and sometimes it doesn't.
            /// However, if you change the above primary swatch, for example, that will
            /// work 100% of the time. So maybe it's a Flutter (or firebase) but. In any case
            /// it's not really hurting anything to have both these things in place.
            ///
            /// Also, you're going to end up wrappign this in UserData in other apps with
            /// a more complex conditional to find out if they have completed setup. At least
            /// that's what I'd like to do, however, you may end up with the same problem
            /// since it's basically the same thing (changing home based on state). If setup
            /// check works but firebaseuser doesn't then you know it's a but and you
            /// should report it.
            /// ...however if it doesn't work, then you'll have to have at least one forward
            /// with possible flicker if setup has not been completed.
            home: user == null ? AuthScreen() : ProductsOverviewScreen(),
            routes: {
              AuthScreen.routeName: (ctx) => AuthScreen(),
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
              ProductsOverviewScreen.routeName: (ctx) =>
                  ProductsOverviewScreen()
            }),
      ),
    );
  }
}
