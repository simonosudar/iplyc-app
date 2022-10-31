import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:login_page/comm/comm.dart';
import 'package:login_page/database_helper/db_helper.dart';
import 'package:login_page/model/user_model.dart';
import 'package:login_page/screens/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  final _formKey = new GlobalKey<FormState>();

  final _conUserId = TextEditingController();
  final _conPassword = TextEditingController();
  var dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
  }

  login() async {
    String uid = _conUserId.text;
    String passwd = _conPassword.text;

    if (uid.isEmpty) {
      Fluttertoast.showToast(
          msg: "Por favor, ingrese su DNI",
          textColor: Colors.white,
          backgroundColor: Color.fromRGBO(43, 78, 116, 1),
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_LONG,
          fontSize: 16);
    } else if (passwd.isEmpty) {
      Fluttertoast.showToast(
          msg: "Por favor, ingrese su contraseña",
          textColor: Colors.white,
          backgroundColor: Color.fromRGBO(43, 78, 116, 1),
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_LONG);
      ;
    } else {
      await dbHelper.getLoginUser(uid, passwd).then((userData) {
        if (userData != null) {
          setSP(userData).whenComplete(() {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => HomeForm()),
                (Route<dynamic> route) => false);
          });
        } else {
          Fluttertoast.showToast(
              msg: "El usuario ingresado no existe",
              textColor: Colors.white,
              backgroundColor: Color.fromRGBO(43, 78, 116, 1),
              gravity: ToastGravity.CENTER,
              toastLength: Toast.LENGTH_LONG);
        }
      }).catchError((error) {
        print(error);
        Fluttertoast.showToast(
            msg: "Fallo la autenticación",
            textColor: Colors.white,
            backgroundColor: Color.fromRGBO(43, 78, 116, 1),
            gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG);
      });
    }
  }

  Future setSP(UserModel user) async {
    final SharedPreferences sp = await _pref;

    sp.setString("user_id", user.user_id);
    sp.setString("user_name", user.user_name);
    sp.setString("email", user.email);
    sp.setString("password", user.password);
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
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                genLoginSignupHeader('Inicio de sesión'),
                getTextFormField(
                    controller: _conUserId,
                    icon: Icons.person,
                    hintName: 'Número de DNI'),
                SizedBox(height: 10.0),
                getTextFormField(
                  controller: _conPassword,
                  icon: Icons.lock,
                  hintName: 'Contraseña',
                  isObscureText: true,
                ),
                Container(
                  margin: EdgeInsets.all(30.0),
                  width: double.infinity,
                  child: TextButton(
                    child: Text(
                      'Iniciar sesión',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: login,
                  ),
                  decoration: BoxDecoration(
                    color: HexColor('29527A'),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('¿No tienes una cuenta?'),
                      TextButton(
                        child: Text('Registrarse',
                            style: TextStyle(color: HexColor('29527A'))),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => SignupForm()));
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
