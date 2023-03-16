import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:Iplyc/comm/comm.dart';
import 'package:Iplyc/database_helper/db_helper.dart';
import 'package:Iplyc/screens/login_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = new GlobalKey<FormState>();
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  late DbHelper dbHelper;
  final _conUserId = TextEditingController();
  final _conPassword = TextEditingController();

  @override
  void initState() {
    super.initState();

    dbHelper = DbHelper();
  }

  updatePassword() async {
    String uid = _conUserId.text.trim();
    String passwd = _conPassword.text.trim();

    if (uid.isEmpty || passwd.isEmpty) {
      Fluttertoast.showToast(
        msg: "Por favor llenar los campos",
        textColor: Colors.white,
        backgroundColor: Color.fromRGBO(43, 78, 116, 1),
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG,
      );
      return;
    }

    var dbClient = await dbHelper.db;

    // Use parameters to avoid SQL injection attacks
    var existingUser = await dbClient
        .rawQuery('SELECT user_id FROM user WHERE user_id = ?', [uid]);

    // Use parameters to avoid SQL injection attacks
    try {
      var update = await dbClient.rawQuery(
          'UPDATE user SET password = \'$passwd\' WHERE user_id = \'$uid\'');
      Fluttertoast.showToast(
        msg: "Contraseña cambiada",
        textColor: Colors.white,
        backgroundColor: Color.fromRGBO(43, 78, 116, 1),
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG,
      );
      print(update);
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error al guardar la nueva contraseña",
        textColor: Colors.white,
        backgroundColor: Colors.red,
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG,
      );
      print(e.toString());
    }

    // Use parameters to avoid SQL injection attacks
    var res = await dbClient.rawQuery('SELECT * FROM user');
    print(res);

    if (existingUser.isEmpty) {
      Fluttertoast.showToast(
        msg: "El usuario ingresado no existe",
        textColor: Colors.white,
        backgroundColor: Color.fromRGBO(43, 78, 116, 1),
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG,
      );
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginForm()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IPLYC se',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: 'Quicksand',
                letterSpacing: 1.5,
                color: HexColor('29527A'))),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          color: HexColor('29527A'),
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginForm()),
                (Route<dynamic> route) => false);
          },
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10.0),
          getTextFormField(
              controller: _conUserId,
              icon: Icons.person,
              hintName: 'Número de registro'),
          SizedBox(height: 10.0),
          getTextFormField(
            controller: _conPassword,
            icon: Icons.lock,
            hintName: 'Nueva contraseña',
            isObscureText: true,
          ),
          SizedBox(height: 10.0),
          Container(
            margin: EdgeInsets.fromLTRB(30, 10, 30, 0),
            width: double.infinity,
            child: TextButton(
                child: Text(
                  'Actualizar contraseña',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  updatePassword();
                }),
            decoration: BoxDecoration(
              color: HexColor('29527A'),
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        ],
      ),
    );
  }
}
