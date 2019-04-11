import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(LoginAnimationApp());

class LoginAnimationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Animation Sample',
      home: LoginPage()
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  AnimationController _loginButtonAnimationController;
  Animation<double> _loginButtonSizeAnimation;

  bool _isLoading = false;
  bool _completed = false;

  @override
  void initState() {
    super.initState();

    _loginButtonAnimationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this
    );

    _loginButtonSizeAnimation = Tween<double>(begin: 320, end: 64)
      .animate(_loginButtonAnimationController)
      ..addListener(() {
        setState(() {
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Login Animation Sample'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () => _playLoginAnimation(),
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 200),
            opacity: _completed ? 0.0 : 1.0,
            child: Container(
              width: _loginButtonSizeAnimation.value,
              height: 60.0,
              alignment: FractionalOffset.center,
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.all(const Radius.circular(30.0))
              ),
              child: !_isLoading
                ? Text(
                  "Sign In",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.8
                  ),
                )
                : RefreshProgressIndicator(backgroundColor: Colors.white)
            ),
          ),
        ),
      ),
    );
  }

  void _playLoginAnimation() async {
    if (_isLoading)
      return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _loginButtonAnimationController.forward();

      Timer(Duration(milliseconds: 1400), () {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(
              'Successfully',
              textAlign: TextAlign.center
            ),
            duration: Duration(milliseconds: 1200)
          )
        );

        setState(() {
          _isLoading = false;
          _loginButtonAnimationController.reverse();
          _completed = true;
        });

        // replace those lines with your logic
        // e.g. navigation to a new page
        Timer(Duration(milliseconds: 1400), () {
          setState(() {
            _completed = false;
          });
        });
      });
    }
    on TickerCanceled {}
  }

  @override
  void dispose() {
    _loginButtonAnimationController.dispose();
    super.dispose();
  }
}