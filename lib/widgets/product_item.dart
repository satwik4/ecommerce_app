import 'package:flutter/material.dart';
import '../screens/product_details_screen.dart';
import '../models/product.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final Product product;

  ProductItem(this.id, this.title, this.imageUrl, this.product);

  void selectProduct(BuildContext context) {
    Navigator.of(context).pushNamed(
      ProductDetailsScreen.routeName,
      arguments: product,  // Pass the product data to the details screen
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => selectProduct(context),
      child: GridTile(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
