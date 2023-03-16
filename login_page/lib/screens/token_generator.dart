import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:math';
import 'package:Iplyc/screens/home_form.dart';
import 'package:Iplyc/database_helper/db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CounterScreen extends StatefulWidget {
  CounterScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  late DbHelper dbHelper;

  @override
  void initState() {
    super.initState();
    getId();
    dbHelper = DbHelper();
  }

  Future<void> getId() async {
    final SharedPreferences sp = await _pref;
    var id = sp.getString("user_id")!;
    int seed = int.parse(id);
    var minuto = DateTime.now().minute;
    int numbase = seed * minuto * minuto;
    double lnbase = log(numbase) * 1000000;
    String strbase =
        lnbase.toString().substring(1, 7).split("").reversed.join("");
    _counter = strbase;
  }

  CountDownController _controller = CountDownController();
  String _counter = " ";
  var minutoinicio = DateTime.now().minute; //minuto inicial
  int segundoinicio = DateTime.now().second; //segundo inicial

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
                MaterialPageRoute(builder: (_) => HomeForm()),
                (Route<dynamic> route) => false);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Tu token es:',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.normal,
                fontFamily: 'Quicksand',
                letterSpacing: 1.5,
              ),
            ),
            Text(
              _counter,
              style: const TextStyle(fontSize: 30),
            ),
            CircularCountDownTimer(
              autoStart: false,
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 2,
              duration: 0,
              fillColor: HexColor('#29527A'),
              ringColor: Colors.white,
              controller: _controller,
              backgroundColor: Colors.white54,
              strokeWidth: 15.0,
              strokeCap: StrokeCap.round,
              isTimerTextShown: true,
              isReverse: true,
              onComplete: () {
                _controller.restart(duration: 60);
                getId();
                setState(() {});
              },
            ),
            Container(
              margin: EdgeInsets.all(30.0),
              width: double.infinity,
              child: TextButton(
                child: Text(
                  'Generar Token',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  setState(() {
                    var segundo = DateTime.now().second;
                    _controller.restart(duration: 60 - segundo);
                    getId();
                  });
                },
              ),
              decoration: BoxDecoration(
                color: HexColor('29527A'),
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
