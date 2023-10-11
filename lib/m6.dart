import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const MyApp());

class User {
  String name;
  String mobile;
  String rollNumber;
  String section;
  String department;
  User({
    required this.name,
    required this.mobile,
    required this.rollNumber,
    required this.section,
    required this.department,
  });
}

class DataStorage {
  static List<User> users = [
    User(
      name: 'John Doe',
      mobile: '1234567890',
      rollNumber: 'A12345',
      section: 'A',
      department: 'Computer Science',
    ),
    // Add more users if needed
  ];
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login & Book Store',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/bookstore': (context) => BookSelectionPage(user: DataStorage.users[0]),
        '/registration': (context) => RegistrationPage(),
        '/otp': (context) => OTPVerificationPage(),
        '/orderconfirmation': (context) => OrderConfirmationPage(),
        '/cart': (context) => CartPage(cart: []),
        '/chatbot': (context) => ChatBotPage(),
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

    if (username.isNotEmpty && password.isNotEmpty) {
      // Check credentials, navigate to BookStorePage if valid
      Navigator.pushReplacementNamed(context, '/bookstore');
    } else {
      setState(() {
        _errorMessage = 'Please enter valid credentials';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mrec Login Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Enter Your Id',
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
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Navigate to registration page
                Navigator.pushNamed(context, '/registration');
              },
              child: Text('Don\'t have an account? Register here'),
            ),
          ],
        ),
      ),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _rollNumberController = TextEditingController();
  TextEditingController _sectionController = TextEditingController();
  TextEditingController _departmentController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  String _errorMessage = '';

  void _register(BuildContext context) {
    String name = _nameController.text;
    String mobile = _mobileController.text;
    String rollNumber = _rollNumberController.text;
    String section = _sectionController.text;
    String department = _departmentController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (name.isNotEmpty &&
        mobile.isNotEmpty &&
        rollNumber.isNotEmpty &&
        section.isNotEmpty &&
        department.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        password == confirmPassword) {
      // Registration logic
      // Display account registered message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Account Registered'),
            content: Text('Your account has been successfully registered.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  // Navigate to login page
                  Navigator.pushReplacementNamed(context, '/');
                },
              ),
            ],
          );
        },
      );
    } else if (password != confirmPassword) {
      setState(() {
        _errorMessage = 'Passwords do not match. Please re-enter.';
      });
    } else {
      setState(() {
        _errorMessage = 'Please fill in all the fields';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Enter Your Name',
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _mobileController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Enter Your Mobile Number*',
              ),
            ),
            TextField(
              controller: _rollNumberController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Enter Your Roll Number*',
              ),
            ),
            TextField(
              controller: _sectionController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Enter Your Section*',
              ),
            ),
            TextField(
              controller: _departmentController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Enter Your Department*',
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Enter Password*',
              ),
            ),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm Password*',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _register(context);
              },
              child: Text('Register'),
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
  final User user;

  BookSelectionPage({required this.user});

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
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: () {
              Navigator.pushNamed(context, '/chatbot', arguments: cart);
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
              decoration: const InputDecoration(
                labelText: 'Search Books',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Text('You can book up to 6 books.', style: TextStyle(color: Colors.red)),
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
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              filteredBooks[index].author,
                              style: const TextStyle(
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
    _correctOTP = ModalRoute.of(context)!.settings.arguments as String;
  }

  void _verifyOTP(BuildContext context) {
    String userOTP = _otpController.text;
    if (userOTP == _correctOTP) {
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
          mainAxisAlignment: MainAxisAlignment.center
