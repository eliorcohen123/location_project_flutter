import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:locationprojectflutter/presentation/utils/validations.dart';
import 'package:locationprojectflutter/presentation/pages/register_email_firebase.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';
import 'package:locationprojectflutter/presentation/widgets/tff_firebase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'list_map.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _success, _loading = false, _isLoggedIn = false;
  String _userEmail, _textError = "";
  SharedPreferences _sharedPrefs;

  @override
  void initState() {
    super.initState();

    _initGetSharedPrefs();
    _checkUserLogin();
  }

  @override
  void dispose() {
    super.dispose();

    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn
        ? ListMap()
        : Scaffold(
            resizeToAvoidBottomPadding: false,
            backgroundColor: Colors.blueGrey,
            body: Form(
              key: _formKey,
              child: Container(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Login',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.greenAccent,
                              fontSize: 40),
                        ),
                        SizedBox(
                          height:
                              ResponsiveScreen().heightMediaQuery(context, 70),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: ResponsiveScreen()
                                .heightMediaQuery(context, 20),
                          ),
                          child: TFFFirebase(
                              key: Key('emailLogin'),
                              icon: Icon(Icons.email),
                              hint: "Email",
                              controller: _emailController,
                              obSecure: false),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: ResponsiveScreen()
                                .heightMediaQuery(context, 20),
                          ),
                          child: TFFFirebase(
                              key: Key('passwordLogin'),
                              icon: Icon(Icons.lock),
                              hint: "Password",
                              controller: _passwordController,
                              obSecure: true),
                        ),
                        SizedBox(
                          height:
                              ResponsiveScreen().heightMediaQuery(context, 20),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: ResponsiveScreen()
                                  .widthMediaQuery(context, 20),
                              right: ResponsiveScreen()
                                  .widthMediaQuery(context, 20),
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Container(
                            child: RaisedButton(
                              highlightElevation: 0.0,
                              splashColor: Colors.greenAccent,
                              highlightColor: Colors.lightGreenAccent,
                              elevation: 0.0,
                              color: Colors.greenAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Text(
                                'Login',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 20),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  if (Validations().validateEmail(
                                          _emailController.text) &&
                                      Validations().validatePassword(
                                          _passwordController.text)) {
                                    setState(() {
                                      _loading = true;
                                      _textError = '';
                                    });
                                    Future.delayed(
                                      const Duration(milliseconds: 5000),
                                      () {
                                        setState(() {
                                          _success = false;
                                          _loading = false;
                                          _textError =
                                              'Something wrong with connection';
                                        });
                                      },
                                    );
                                    _loginFirebase();
                                  } else if (!Validations()
                                      .validateEmail(_emailController.text)) {
                                    setState(() {
                                      _success = false;
                                      _textError = 'Invalid Email';
                                    });
                                  } else if (!Validations().validatePassword(
                                      _passwordController.text)) {
                                    setState(() {
                                      _success = false;
                                      _textError =
                                          'Password must be at least 8 characters';
                                    });
                                  }
                                }
                              },
                            ),
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                        SizedBox(
                          height:
                              ResponsiveScreen().heightMediaQuery(context, 5),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            _success == null ? '' : _success ? '' : _textError,
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterPage(),
                              ),
                            );
                          },
                          child: Text(
                            'Don' +
                                "'" +
                                't Have an account? click here to register',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                        SizedBox(
                          height:
                              ResponsiveScreen().heightMediaQuery(context, 20),
                        ),
                        _loading == true
                            ? CircularProgressIndicator()
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  void _checkUserLogin() {
    _auth.currentUser().then((user) => user != null
        ? setState(() {
            _isLoggedIn = true;
          })
        : null);
  }

  Future _loginFirebase() async {
    final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    ))
        .user;
    if (user != null) {
      setState(() {
        _success = true;
        _loading = false;

        _userEmail = user.email;
        print(_userEmail);
        _addUserEmail(_userEmail).then(
          (value) => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ListMap(),
            ),
          ),
        );
      });
    } else {
      setState(() {
        _success = false;
        _loading = false;
      });
    }
  }

  void _initGetSharedPrefs() {
    SharedPreferences.getInstance().then(
      (prefs) {
        setState(() => _sharedPrefs = prefs);
      },
    );
  }

  Future _addUserEmail(String value) async {
    _sharedPrefs.setString('userEmail', value);
  }
}
