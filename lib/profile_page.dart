class User {
  String name;
  String profilePic;
  List<Book> booksTaken;

  User({
    required this.name,
    required this.profilePic,
    required this.booksTaken,
  });
}

class Book {
  String title;
  String author;
  String imageUrl;
  bool isAddedToCart;
  DateTime takenDate;
  DateTime submissionDate;

  Book({
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.takenDate,
    required this.submissionDate,
    this.isAddedToCart = false,
  });
}