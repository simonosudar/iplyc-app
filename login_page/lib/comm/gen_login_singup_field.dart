import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class genLoginSignupHeader extends StatelessWidget {
  String headerName;

  genLoginSignupHeader(this.headerName);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 50.0),
          Image.asset(
            "assets/images/logo.png",
            height: 170.0,
            width: 170.0,
          ),
          SizedBox(height: 10.0),
          Text(
            headerName,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Quicksand',
                color: HexColor('29527A'),
                fontSize: 30.0),
          ),
          SizedBox(height: 40.0),
        ],
      ),
    );
  }
}
