import 'package:flutter/material.dart';

class MyService extends StatefulWidget {
  final String name;
  MyService({Key key, this.name}) : super(key: key);

  @override
  _MyServiceState createState() => _MyServiceState();
}

class _MyServiceState extends State<MyService> {
  // Field
  String nameLogin;

  // Method
  @override
  void initState(){
    super.initState();
    nameLogin = widget.name;
  }
  
  

  Widget showNameLogin() {
    return Column(
      children: <Widget>[
        Text('Login by'),
        Text(nameLogin),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: <Widget>[showNameLogin()],
        backgroundColor: Colors.orange.shade700,
        title: Text('My Service'),
      ),
    );
  }
}
