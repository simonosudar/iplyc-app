import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:login_page/comm/com_helper.dart';
import 'package:login_page/comm/gen_login_singup_field.dart';
import 'package:login_page/comm/gen_text_form.dart';
import 'package:login_page/database_helper/db_helper.dart';
import 'package:login_page/model/user_model.dart';
import 'package:login_page/screens/login_form.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = new GlobalKey<FormState>();

  final _conUserId = TextEditingController();
  final _conUserName = TextEditingController();
  final _conEmail = TextEditingController();
  final _conPassword = TextEditingController();
  final _conCPassword = TextEditingController();
  var dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
  }

  Future<void> signUp() async {
    String uid = _conUserId.text;
    String uname = _conUserName.text;
    String email = _conEmail.text;
    String passwd = _conPassword.text;
    String cpasswd = _conCPassword.text;

    if (_formKey.currentState!.validate()) {
      if (passwd != cpasswd) {
        Fluttertoast.showToast(
            msg: "Las contraseñas ingresadas no coinciden",
            textColor: Colors.white,
            backgroundColor: Color.fromRGBO(43, 78, 116, 1),
            gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG);
      } else {
        _formKey.currentState!.save();

        UserModel uModel = UserModel(uid, uname, email, passwd);
        await dbHelper.saveData(uModel).then((userData) {
          Fluttertoast.showToast(
              msg: "Guardado satisfactoriamente",
              textColor: Colors.white,
              backgroundColor: Color.fromRGBO(43, 78, 116, 1),
              gravity: ToastGravity.CENTER,
              toastLength: Toast.LENGTH_LONG);
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => LoginForm()));
        }).catchError((error) {
          print(error);
          Fluttertoast.showToast(
              msg: error,
              textColor: Colors.white,
              backgroundColor: Color.fromRGBO(43, 78, 116, 1),
              gravity: ToastGravity.CENTER,
              toastLength: Toast.LENGTH_LONG);
        });
      }
    }
  }

  static Color colorAzul = HexColor('29527A');

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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  genLoginSignupHeader('Registrate'),
                  getTextFormField(
                      controller: _conUserId,
                      icon: Icons.person,
                      hintName: 'Número de DNI'),
                  SizedBox(height: 10.0),
                  getTextFormField(
                      controller: _conUserName,
                      icon: Icons.person_outline,
                      inputType: TextInputType.name,
                      hintName: 'Nombre completo'),
                  SizedBox(height: 10.0),
                  getTextFormField(
                      controller: _conEmail,
                      icon: Icons.email,
                      inputType: TextInputType.emailAddress,
                      hintName: 'Email'),
                  SizedBox(height: 10.0),
                  getTextFormField(
                    controller: _conPassword,
                    icon: Icons.lock,
                    hintName: 'Contraseña',
                    isObscureText: true,
                  ),
                  SizedBox(height: 10.0),
                  getTextFormField(
                    controller: _conCPassword,
                    icon: Icons.lock,
                    hintName: 'Repita la contraseña',
                    isObscureText: true,
                  ),
                  Container(
                    margin: EdgeInsets.all(30.0),
                    width: double.infinity,
                    child: TextButton(
                      child: Text(
                        'Registrarme',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: signUp,
                    ),
                    decoration: BoxDecoration(
                      color: colorAzul,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Ya tienes una cuenta?'),
                        TextButton(
                          child: Text('Iniciar sesión',
                              style: TextStyle(color: colorAzul)),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => LoginForm()),
                                (Route<dynamic> route) => false);
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
      ),
    );
  }
}
