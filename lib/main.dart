import 'package:fluto/ChatBotPage.dart';
import 'package:fluto/profile_page.dart';
import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login & Book Store',
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/bookstore': (context) => const BookSelectionPage(),
        '/otp': (context) => const OTPVerificationPage(),
        '/orderconfirmation': (context) => const OrderConfirmationPage(),
        '/profile': (context) => ProfilePage(),
        '/chatbot': (context) => const ChatScreen(),
      },
    );
  }
}

class BookSelectionPage extends StatefulWidget {
  const BookSelectionPage({super.key});

  @override
  _BookSelectionPageState createState() => _BookSelectionPageState();
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  void _login(BuildContext context) {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username == password) {
      Navigator.pushReplacementNamed(context, '/bookstore');
    } else {
      setState(() {
        _errorMessage = 'Incorrect password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Enter Your Name',
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Enter Your Password',
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _login(context);
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 10),
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red),
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

  Book(
      {required this.title,
      required this.author,
      required this.imageUrl,
      this.isAddedToCart = false});
}

// class BookSelectionPage extends StatefulWidget {
//   @override
//   _BookSelectionPageState createState() => _BookSelectionPageState();
// }

class _BookSelectionPageState extends State<BookSelectionPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();

  List<Book> books = [
    Book(title: 'Book 1', author: 'Author 1', imageUrl: 'assets/book1.jpg'),
    Book(title: 'Book 2', author: 'Author 2', imageUrl: 'assets/book2.jpg'),
    // Add more books as needed
  ];

  List<Book> filteredBooks = [];
  List<Book> cart = [];
  String _otp = '';

  void _generateOTP() {
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('${filteredBooks[index].title} added to cart.')));
      } else if (cart.length >= 6) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You can only book up to 6 books.')));
      }
    });
  }

  void _proceedToCheckout(BuildContext context) {
    String mobile = _mobileController.text;
    String year = _yearController.text;
    String branch = _branchController.text;

    if (mobile.isNotEmpty && year.isNotEmpty && branch.isNotEmpty) {
      _generateOTP();
      Navigator.pushNamed(context, '/otp', arguments: _otp);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all the fields.')));
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${filteredBooks[index].title} removed from cart.')));
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
        title: const Text('Book Store'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage(cart: cart)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () {
              // redirect to ChatBotPage.dart file
              Navigator.pushNamed(context, '/chatbot');
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _searchController,
              onChanged: filterBooks,
              decoration: const InputDecoration(
                labelText: 'Search Books',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          const Text('You can book up to 6 books.',
              style: TextStyle(color: Colors.red)),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
              ),
              itemCount: filteredBooks.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.all(10),
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
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              filteredBooks[index].title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              filteredBooks[index].author,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            if (filteredBooks[index].isAddedToCart)
                              IconButton(
                                icon: const Icon(Icons.remove_shopping_cart),
                                onPressed: () {
                                  removeFromCart(index);
                                },
                              ),
                            if (!filteredBooks[index].isAddedToCart)
                              IconButton(
                                icon: const Icon(Icons.add_shopping_cart),
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
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                TextField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Mobile Number',
                  ),
                ),
                TextField(
                  controller: _yearController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Year',
                  ),
                ),
                TextField(
                  controller: _branchController,
                  decoration: const InputDecoration(
                    labelText: 'Branch',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _proceedToCheckout(context);
                  },
                  child: const Text('Proceed to Checkout'),
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
  const OTPVerificationPage({super.key});

  @override
  _OTPVerificationPageState createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final TextEditingController _otpController = TextEditingController();
  String? _correctOTP;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _correctOTP = ModalRoute.of(context)!.settings.arguments as String;
  }

  void _verifyOTP(BuildContext context) {
    String userOTP = _otpController.text;

    String correctOTP = '123456';

    if (userOTP == correctOTP) {
      Navigator.pushReplacementNamed(context, '/orderconfirmation');
    } else {
      Navigator.pushReplacementNamed(context, '/orderconfirmation');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter OTP',
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _verifyOTP(context);
              },
              child: const Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderConfirmationPage extends StatelessWidget {
  const OrderConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmation'),
      ),
      body: const Center(
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

  CartPage({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: ListView.builder(
        itemCount: cart.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(cart[index].title),
            subtitle: Text(cart[index].author),
            leading: Image.asset(cart[index].imageUrl,
                width: 50, height: 50, fit: BoxFit.cover),
          );
        },
      ),
    );
  }
}
