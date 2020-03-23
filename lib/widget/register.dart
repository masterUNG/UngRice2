import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ungrice/utility/normal_dialog.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Field
  File file;
  String name, user, password, urlPath;

  // Method
  Widget nameForm() {
    Color color = Colors.green[700];
    String title = 'Name :';
    String help = 'Type Your Name In Blank';
    return TextField(
      onChanged: (value) => name = value.trim(),
      decoration: InputDecoration(
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: color)),
        helperStyle: TextStyle(color: color),
        helperText: help,
        labelStyle: TextStyle(color: color),
        labelText: title,
        icon: Icon(
          Icons.account_box,
          size: 36.0,
          color: color,
        ),
      ),
    );
  }

  Widget userForm() {
    Color color = Colors.purple[700];
    String title = 'User :';
    String help = 'Type Your User In Blank';
    return TextField(
      onChanged: (value) => user = value.trim(),
      decoration: InputDecoration(
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: color)),
        helperStyle: TextStyle(color: color),
        helperText: help,
        labelStyle: TextStyle(color: color),
        labelText: title,
        icon: Icon(
          Icons.email,
          size: 36.0,
          color: color,
        ),
      ),
    );
  }

  Widget passwordForm() {
    Color color = Colors.orange[800];
    String title = 'Password :';
    String help = 'Type Your Password In Blank';
    return TextField(
      onChanged: (value) => password = value.trim(),
      decoration: InputDecoration(
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: color)),
        helperStyle: TextStyle(color: color),
        helperText: help,
        labelStyle: TextStyle(color: color),
        labelText: title,
        icon: Icon(
          Icons.lock,
          size: 36.0,
          color: color,
        ),
      ),
    );
  }

  Widget showAvartar() {
    return GestureDetector(
      onTap: () {
        print('You Click Image');
        cameraThread();
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width,
        child:
            file == null ? Image.asset('images/avartar.png') : Image.file(file),
      ),
    );
  }

  Future<void> cameraThread() async {
    try {
      var object = await ImagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800.0,
        maxHeight: 800.0,
      );

      setState(() {
        file = object;
      });
    } catch (e) {}
  }

  Widget registerButton() {
    return IconButton(
      icon: Icon(Icons.cloud_upload),
      onPressed: () {
        if (file == null) {
          normalDialog(context, 'Non Choose Avatar',
              'Please Click Image For Open Camera');
        } else if (name == null ||
            name.isEmpty ||
            user == null ||
            user.isEmpty ||
            password == null ||
            password.isEmpty) {
          normalDialog(context, 'Have Space', 'Please Fill Every Blank');
        } else {
          uploadImageToServer();
        }
      },
    );
  }

  //  นี่คือตัวอย่างการ อัพโหลดรูป ไป Server เว้ยเห้ย
  Future<void> uploadImageToServer()async{

    try {

      String url = 'https://www.androidthai.in.th/rice/saveFileUng.php';

      Map<String, dynamic> map = Map();

      Random random = Random();
      int i = random.nextInt(100000);

      map['file'] = UploadFileInfo(file, 'user$i.jpg');
      FormData formData = FormData.from(map);

      var response = await Dio().post(url, data: formData);
      print('response = ${response.toString()}');

      urlPath = 'https://www.androidthai.in.th/rice/Ung/user$i.jpg';
      insertDataToMySQL();
      
    } catch (e) {
      print('error ==> ${e.toString()}');
    }

  }

  Future<void> insertDataToMySQL()async{

    try {

      String url = 'https://www.androidthai.in.th/rice/addUserUng.php?isAdd=true&Name=$name&User=$user&Password=$password&Avatar=$urlPath';
      var response = await Dio().get(url);

      if (response.toString() == 'true') {
        Navigator.of(context).pop();
      } else {
        normalDialog(context, 'Cannot Register', 'Please Try Agains');
      }

    } catch (e) {
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(40.0),
        children: <Widget>[
          showAvartar(),
          nameForm(),
          userForm(),
          passwordForm(),
        ],
      ),
      appBar: AppBar(
        actions: <Widget>[registerButton()],
        title: Text('Register'),
        backgroundColor: Colors.orange.shade400,
      ),
    );
  }
}
