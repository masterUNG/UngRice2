import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ungrice/utility/normal_dialog.dart';
import 'package:ungrice/widget/my_service.dart';
import 'package:ungrice/widget/register.dart';

class Authen extends StatefulWidget {
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  // Field
  String user, password;

  // Method
  Widget singInButton() {
    return RaisedButton(
      color: Colors.purple,
      child: Text(
        'Sign In',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        if (user == null ||
            user.isEmpty ||
            password == null ||
            password.isEmpty) {
          normalDialog(context, 'มีช่องว่าง ?', 'กรุณากรอกทุกช่อง สิค่าาา');
        } else {
          checkAuthen();
        }
      },
    );
  }

  Future<void> checkAuthen() async {
    try {
      String url =
          'https://www.androidthai.in.th/rice/getUserWhereUserUng.php?isAdd=true&User=$user';
      var response = await Dio().get(url);
      print('response ===>> $response');

      if (response.toString() == 'null') {
        normalDialog(context, 'User False', 'No $user in my Databaser');
      } else {
        var result = json.decode(response.data);
        print('result ===>>> $result');

        for (var map in result) {
          String truePassword = map['Password'];
          String nameLogin = map['Name'];

          if (password == truePassword) {
            MaterialPageRoute route = MaterialPageRoute(
              builder: (context) => MyService(
                name: nameLogin,
              ),
            );
            Navigator.of(context).pushAndRemoveUntil(route, (value) => false);
          } else {
            normalDialog(
                context, 'Password False', 'Please Try Agains Password False');
          }
        }
      }
    } catch (e) {}
  }

  Widget singUpButton() {
    return OutlineButton(
      child: Text('Sign Up'),
      onPressed: () {
        MaterialPageRoute route =
            MaterialPageRoute(builder: (value) => Register());
        Navigator.of(context).push(route);
      },
    );
  }

  Widget showButton() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        singInButton(),
        mySizeBox(),
        singUpButton(),
      ],
    );
  }

  Widget mySizeBox() {
    return SizedBox(
      height: 16.0,
      width: 8.0,
    );
  }

  Widget userForm() {
    return Container(
      width: 250.0,
      child: TextField(
        onChanged: (value) => user = value.trim(),
        decoration: InputDecoration(
          labelText: 'User :',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget passwordForm() {
    return Container(
      width: 250.0,
      child: TextField(
        onChanged: (value) => password = value.trim(),
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Password :',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget showAppName() {
    return Text(
      'Ung Rice',
      style: GoogleFonts.liuJianMaoCao(
          textStyle: TextStyle(
        color: Colors.pink.shade900,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
        fontSize: 40.0,
      )),
    );
  }

  Widget showLogo() {
    return Container(
      width: 120.0,
      child: Image.asset('images/logo.png'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
              colors: <Color>[Colors.white, Colors.orange.shade400],
              radius: 1.0,
              center: Alignment(0, -0.2)),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                showLogo(),
                showAppName(),
                mySizeBox(),
                userForm(),
                mySizeBox(),
                passwordForm(),
                mySizeBox(),
                showButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
