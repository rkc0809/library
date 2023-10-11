import 'package:flutter/material.dart';
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

  String _errorMessage = '';

  void _register(BuildContext context) {
    String name = _nameController.text;
    String mobile = _mobileController.text;
    String rollNumber = _rollNumberController.text;
    String section = _sectionController.text;
    String department = _departmentController.text;

    if (name.isNotEmpty && mobile.isNotEmpty && rollNumber.isNotEmpty && section.isNotEmpty && department.isNotEmpty) {
      // Registration logic, navigate to BookStorePage if successful
      Navigator.pushReplacementNamed(context, '/bookstore');
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
