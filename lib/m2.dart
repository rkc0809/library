import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mrec Library',
      home: BookSelectionPage(),
    );
  }
}

class Book {
  String title;
  String author;
  String imageUrl;

  Book({required this.title, required this.author, required this.imageUrl});
}

class BookSelectionPage extends StatelessWidget {
  final List<Book> books = [
    Book(
      title: 'Book 1',
      author: 'Author 1',
      imageUrl: 'https://media.istockphoto.com/id/1387105124/photo/white-book-blank-cover-mockup-on-a-beige-background-flat-lay-mockup.jpg?s=2048x2048&w=is&k=20&c=Q8E3sIqb-szoGWKIPJaRwfK7Uu0cRpzRetqnUWFU6F0=',
    ),
    Book(
      title: 'Book 2',
      author: 'Author 2',
      imageUrl: 'https://example.com/book2.jpg',
    ),
    // Add more books as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Store'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7, // Adjust this ratio for item width and height
        ),
        itemCount: books.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Handle book selection, e.g., navigate to book details page
              // You can use Navigator to navigate to another page
            },
            child: Card(
              elevation: 5,
              margin: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(books[index].imageUrl),
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
                          books[index].title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          books[index].author,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
