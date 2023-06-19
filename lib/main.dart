import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductList(),
    );
  }
}

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<Product> products = [
    Product(name: 'Pen', price: 10),
    Product(name: 'Pencil', price: 20),
    Product(name: 'Eraser', price: 15),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: SingleChildScrollView(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: products.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(products[index].name),
              subtitle: Text('Price: \$${products[index].price}'),
              trailing: CounterButton(
                product: products[index],
                onBuyNowPressed: (product) {
                  setState(() {
                    product.incrementCounter();
                    if (product.counter == 5) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Congratulations!'),
                            content: Text('You\'ve bought 5 ${product.name}!'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  });
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CartPage(products: products)),
          );
        },
        child: Icon(Icons.shopping_cart),
      ),
    );
  }
}

class Product {
  String name;
  double price;
  int counter;

  Product({required this.name, required this.price, this.counter = 0});

  void incrementCounter() {
    counter++;
  }
}

class CounterButton extends StatelessWidget {
  final Product product;
  final Function(Product) onBuyNowPressed;

  CounterButton({required this.product, required this.onBuyNowPressed});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text('Counter: ${product.counter}'),
          ElevatedButton(
            onPressed: () {
              onBuyNowPressed(product);
            },
            child: Text('Buy Now'),
          ),
        ],
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  final List<Product> products;

  CartPage({required this.products});

  @override
  Widget build(BuildContext context) {
    int totalProductsBought = 0;
    for (var product in products) {
      totalProductsBought += product.counter;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Center(
        child: Text('Total products bought: $totalProductsBought'),
      ),
    );
  }
}
