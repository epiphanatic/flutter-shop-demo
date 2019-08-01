import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  // final String title;
  // final double price;

  // ProductDetailScreen(this.title, this.price);
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    /// you don't want to rebuild this screen if anything changes to the
    /// product since you can't change it here, and then you'd only see changes
    /// if you were to go elsewhere and come back...you just want to tap into
    /// the provider to get the info, so set listen: false
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      // ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            // if you for some reason decide to control the button yourself:
            // leading: Container(
            //   color: Theme.of(context).primaryColor,
            //   child: IconButton(
            //     icon: Icon(Icons.arrow_back, color: Colors.white),
            //     color: Colors.black,
            //     onPressed: () => Navigator.of(context).pop(),
            //   ),
            // ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title),
              background: Hero(
                tag: loadedProduct.id,
                child: FadeInImage(
                  image: NetworkImage(loadedProduct.imageUrl),
                  fit: BoxFit.cover,
                  placeholder: AssetImage('assets/images/shop.png'),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Column(
                children: <Widget>[
                  SizedBox(height: 10),
                  Text(
                    '\$${loadedProduct.price}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    child: Text(
                      loadedProduct.description,
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                  )
                ],
              )
            ]),
          ),
        ],
      ),
    );
  }
}
