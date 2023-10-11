// ignore_for_file: unused_import

import 'package:fluto/user_profile.dart';
import 'package:flutter/material.dart';
import 'path_to_user_profile.dart'; // Import the UserProfile model

class RegistrationPage extends StatefulWidget {
  final Function(UserProfile) onRegistrationComplete;

  RegistrationPage({required this.onRegistrationComplete});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _yearController = TextEditingController();
  TextEditingController _branchController = TextEditingController();
  // Add more controllers for other registration fields if needed

  void _register() {
    String name = _nameController.text;
    String mobile = _mobileController.text;
    String year = _yearController.text;
    String branch = _branchController.text;

    // Validate the input fields
    if (name.isNotEmpty && mobile.isNotEmpty && year.isNotEmpty && branch.isNotEmpty) {
      // Create a UserProfile object with the registration data
      UserProfile userProfile = UserProfile(
        name: name,
        mobile: mobile,
        year: year,
        branch: branch, profilePicUrl: '', takenBooks: [],
        // Add more properties as needed
      );

      // Call the callback function to notify the parent widget about registration completion
      widget.onRegistrationComplete(userProfile);
    } else {
      // Handle validation errors or show a message to the user
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
            TextField(
              controller: _mobileController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Enter Your Mobile Number',
              ),
            ),
            TextField(
              controller: _yearController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Your Year',
              ),
            ),
            TextField(
              controller: _branchController,
              decoration: InputDecoration(
                labelText: 'Enter Your Branch',
              ),
            ),
            // Add more text fields for other registration fields

            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _register();
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
