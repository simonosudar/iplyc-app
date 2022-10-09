import 'package:flutter/material.dart';
import 'package:login_page/screens/login_form.dart';
import 'package:hexcolor/hexcolor.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Color _primaryColor = HexColor('#2B4E74');
  Color _accentColor = HexColor('#DA3641');
  Color _secondaryColor = HexColor('#Ffffff');
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IPLyC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: _primaryColor,
          scaffoldBackgroundColor: _secondaryColor,
          primarySwatch: Colors.grey,
          fontFamily: 'Quicksand',
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: _accentColor)),
      home: LoginForm(),
    );
  }
}
