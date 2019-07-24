import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;

  ProductsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showFavs ? productsData.favoriteItems : productsData.items;
    // again
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,

      /// Here we are making sure to get changes in the single product
      /// so you add another changeNotifierProvider whose value is
      /// the current product in the loop/itembuilder
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        // builder: (c) => products[i],
        /// here you are profviding a <Product>, which will then be picked
        /// up by ProductItem as the nearest <Product>
        /// Doing all this in order to be able to toggle favorite status
        value: products[i],
        child: ProductItem(
            // products[i].id,
            // products[i].title,
            // products[i].imageUrl,
            ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
