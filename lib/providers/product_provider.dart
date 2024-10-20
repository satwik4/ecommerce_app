import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  Future<void> fetchProducts() async {
    final snapshot = await FirebaseFirestore.instance.collection('products').get();
    final products = snapshot.docs.map((doc) {
      return Product(
        id: doc.id,
        title: doc['title'],
        description: doc['description'],
        price: doc['price'],
        imageUrl: doc['imageUrl'],
      );
    }).toList();
    _items = products;
    notifyListeners();
  }
}
