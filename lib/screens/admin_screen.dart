import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminScreen extends StatelessWidget {
  final CollectionReference products = FirebaseFirestore.instance.collection('products');
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  void addProduct(BuildContext context) {
    final String name = nameController.text;
    final double? price = double.tryParse(priceController.text);

    if (name.isNotEmpty && price != null) {
      products.add({
        'name': name,
        'price': price,
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product added')));
        nameController.clear();
        priceController.clear();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add product: $error')));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid input')));
    }
  }

  void updateProduct(BuildContext context, DocumentSnapshot product) {
    final String newName = nameController.text;
    final double? newPrice = double.tryParse(priceController.text);

    if (newName.isNotEmpty && newPrice != null) {
      products.doc(product.id).update({
        'name': newName,
        'price': newPrice,
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product updated')));
        nameController.clear();
        priceController.clear();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update product: $error')));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid input')));
    }
  }

  void deleteProduct(BuildContext context, DocumentSnapshot product) {
    products.doc(product.id).delete().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product deleted')));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete product: $error')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Product Price'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => addProduct(context),
              child: Text('Add Product'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<QuerySnapshot>(
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
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                nameController.text = product['name'];
                                priceController.text = product['price'].toString();
                                updateProduct(context, product);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => deleteProduct(context, product),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
