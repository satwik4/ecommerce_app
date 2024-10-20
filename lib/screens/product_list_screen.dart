import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'product_details_screen.dart';
import 'admin_screen.dart';

class ProductListScreen extends StatelessWidget {
  final CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        actions: [
          IconButton(
            icon: Icon(Icons.admin_panel_settings),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AdminScreen()));
            },
          ),
        ],
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: products.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No products found'));
          }

          final productList = snapshot.data!.docs;
          return ListView.builder(
            itemCount: productList.length,
            itemBuilder: (context, index) {
              final product = productList[index];
              return ListTile(
                title: Text(product['name']),
                subtitle: Text('\$${product['price']}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailsScreen(product: product),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
