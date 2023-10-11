import 'package:fluto/m5.dart';

class UserProfile {
  String name;
  String mobile;
  String year;
  String branch;
  String profilePicUrl;
  List<Book> takenBooks;

  UserProfile({
    required this.name,
    required this.mobile,
    required this.year,
    required this.branch,
    required this.profilePicUrl,
    required this.takenBooks,
  });

  String get profilePictureUrl => null;
}
