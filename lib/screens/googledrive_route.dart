import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleDriveRoute extends StatefulWidget {

  @override
  _GoogleDriveRouteState createState() => _GoogleDriveRouteState();
}

class _GoogleDriveRouteState extends State<GoogleDriveRoute > {

  final myUserController = TextEditingController();
  final myPasswordController = TextEditingController();

  _GoogleDriveRouteState(){
    _readCredentials();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Google credentials Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset('assets/images/google-drive.jpg',
                      width: 300,
                      height: 150,)),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: myUserController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter valid email id as abc@gmail.com'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: myPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            SizedBox(
              height: 130,
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () {
                  _saveCredentials();
                  _showToast(context);
                },
                child: Text(
                  'Save credentials',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 130,
            ),
          ],
        ),
      ),
    );
  }

  _saveCredentials() async {

    final prefs = await SharedPreferences.getInstance();
// set value
    prefs.setString('google_user', myUserController.text);
    prefs.setString('google_password', myPasswordController.text);
  }

  _readCredentials() async {
    final prefs = await SharedPreferences.getInstance();

// Try reading data from the counter key. If it doesn't exist, return 0.
    final user = prefs.getString('google_user') ?? "";
    final pass = prefs.getString('google_password') ?? "";

    myUserController.text = user;
    myPasswordController.text = pass;
  }

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('done'),
      ),
    );
  }
}