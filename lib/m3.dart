import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Store',
      home: BookSelectionPage(),
    );
  }
}

class Book {
  String title;
  String author;
  String imageUrl;
  bool isAddedToCart;

  Book({required this.title, required this.author, required this.imageUrl, this.isAddedToCart = false});
}

class CartPage extends StatelessWidget {
  final List<Book> cart;

  CartPage({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: ListView.builder(
        itemCount: cart.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(cart[index].title),
            subtitle: Text(cart[index].author),
            leading: Image.asset(cart[index].imageUrl, width: 50, height: 50, fit: BoxFit.cover),
          );
        },
      ),
    );
  }
}

class BookSelectionPage extends StatefulWidget {
  @override
  _BookSelectionPageState createState() => _BookSelectionPageState();
}

class _BookSelectionPageState extends State<BookSelectionPage> {
  TextEditingController _searchController = TextEditingController();
  List<Book> books = [
    Book(title: 'Book 1', author: 'Author 1', imageUrl: 'assets/book1.jpg'),
    Book(title: 'Book 2', author: 'Author 2', imageUrl: 'assets/book2.jpg'),
    // Add more books as needed
  ];
  List<Book> filteredBooks = [];
  List<Book> cart = [];

  String _cartMessage = '';

  @override
  void initState() {
    super.initState();
    filteredBooks.addAll(books);
  }

  void addToCart(int index) {
    setState(() {
      if (!filteredBooks[index].isAddedToCart) {
        filteredBooks[index].isAddedToCart = true;
        cart.add(filteredBooks[index]);
        _cartMessage = '${filteredBooks[index].title} added to cart.';
        // Book is selected, show "added to cart" message and navigate to CartPage.
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_cartMessage)));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CartPage(cart: cart)),
        );
      } else {
        _cartMessage = '${filteredBooks[index].title} is already in cart.';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_cartMessage)));
      }
    });
  }

  void removeFromCart(int index) {
    setState(() {
      if (filteredBooks[index].isAddedToCart) {
        filteredBooks[index].isAddedToCart = false;
        cart.remove(filteredBooks[index]);
        _cartMessage = '${filteredBooks[index].title} removed from cart.';
        // Book is deselected, show "removed from cart" message.
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_cartMessage)));
      } else {
        _cartMessage = '${filteredBooks[index].title} is not in cart.';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_cartMessage)));
      }
    });
  }

  void filterBooks(String query) {
    setState(() {
      filteredBooks.clear();
      if (query.isEmpty) {
        filteredBooks.addAll(books);
      } else {
        filteredBooks.addAll(books.where((book) =>
            book.title.toLowerCase().contains(query.toLowerCase()) ||
            book.author.toLowerCase().contains(query.toLowerCase())));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Store'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage(cart: cart)),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: _searchController,
              onChanged: filterBooks,
              decoration: InputDecoration(
                labelText: 'Search Books',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Text(_cartMessage, style: TextStyle(color: Colors.green)),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
              ),
              itemCount: filteredBooks.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(filteredBooks[index].imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              filteredBooks[index].title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              filteredBooks[index].author,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            if (filteredBooks[index].isAddedToCart)
                              IconButton(
                                icon: Icon(Icons.remove_shopping_cart),
                                onPressed: () {
                                  removeFromCart(index);
                                },
                              ),
                            if (!filteredBooks[index].isAddedToCart)
                              IconButton(
                                icon: Icon(Icons.add_shopping_cart),
                                onPressed: () {
                                  addToCart(index);
                                },
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
