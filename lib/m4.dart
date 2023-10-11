import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login & Book Store',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/bookstore': (context) => BookSelectionPage(),
        '/otp': (context) => OTPVerificationPage(),
        '/orderconfirmation': (context) => OrderConfirmationPage(),
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  void _login(BuildContext context) {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username == password) {
      // Username and password are the same, navigate to BookSelectionPage
      Navigator.pushReplacementNamed(context, '/bookstore');
    } else {
      // Username and password are not the same, show error message
      setState(() {
        _errorMessage = 'Incorrect password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Enter Your Name',
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Enter Your Password',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _login(context);
              },
              child: Text('Login'),
            ),
            SizedBox(height: 10),
            Text(
              _errorMessage,
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
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

class BookSelectionPage extends StatefulWidget {
  @override
  _BookSelectionPageState createState() => _BookSelectionPageState();
}

class _BookSelectionPageState extends State<BookSelectionPage> {
  TextEditingController _searchController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _yearController = TextEditingController();
  TextEditingController _branchController = TextEditingController();

  List<Book> books = [
    Book(title: 'Book 1', author: 'Author 1', imageUrl: 'assets/book1.jpg'),
    Book(title: 'Book 2', author: 'Author 2', imageUrl: 'assets/book2.jpg'),
    // Add more books as needed
  ];

  List<Book> filteredBooks = [];
  List<Book> cart = [];
  String _otp = '';

  void _generateOTP() {
    // Generate a random 6-digit OTP
    var rng = Random();
    setState(() {
      _otp = rng.nextInt(1000000).toString().padLeft(6, '0');
    });
  }

  void addToCart(int index) {
    setState(() {
      if (!filteredBooks[index].isAddedToCart && cart.length < 6) {
        filteredBooks[index].isAddedToCart = true;
        cart.add(filteredBooks[index]);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${filteredBooks[index].title} added to cart.')));
      } else if (cart.length >= 6) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You can only book up to 6 books.')));
      }
    }
    );
  }

  void _proceedToCheckout(BuildContext context) {
    String mobile = _mobileController.text;
    String year = _yearController.text;
    String branch = _branchController.text;

    if (mobile.isNotEmpty && year.isNotEmpty && branch.isNotEmpty) {
      // All fields are filled, generate OTP and proceed to OTP Verification Page
      _generateOTP();
      Navigator.pushNamed(
        context,
        '/otp',
        arguments: _otp,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all the fields.')));
    }
  }

  @override
  void initState() {
    super.initState();
    filteredBooks.addAll(books);
  }

  void removeFromCart(int index) {
    setState(() {
      filteredBooks[index].isAddedToCart = false;
      cart.remove(filteredBooks[index]);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${filteredBooks[index].title} removed from cart.')));
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
          Text('You can book up to 6 books.', style: TextStyle(color: Colors.red)),
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
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                TextField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                  ),
                ),
                TextField(
                  controller: _yearController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Year',
                  ),
                ),
                TextField(
                  controller: _branchController,
                  decoration: InputDecoration(
                    labelText: 'Branch',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _proceedToCheckout(context);
                  },
                  child: Text('Proceed to Checkout'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OTPVerificationPage extends StatefulWidget {
  @override
  _OTPVerificationPageState createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  TextEditingController _otpController = TextEditingController();

  String? _correctOTP;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Retrieve the OTP passed from the previous screen
    _correctOTP = ModalRoute.of(context)!.settings.arguments as String;
  }

  void _verifyOTP(BuildContext context) {
    String userOTP = _otpController.text;
    if (userOTP == _correctOTP) {
      // OTP is correct, navigate to Order Confirmation Page
      Navigator.pushReplacementNamed(context, '/orderconfirmation');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Incorrect OTP. Please try again.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter OTP',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _verifyOTP(context);
              },
              child: Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderConfirmationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Confirmation'),
      ),
      body: Center(
        child: Text(
          'Order Placed Successfully!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
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
