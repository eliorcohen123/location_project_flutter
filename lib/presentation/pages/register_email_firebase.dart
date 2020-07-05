import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:locationprojectflutter/presentation/state_management/provider/register_email_firebase_provider.dart';
import 'package:locationprojectflutter/presentation/utils/validations.dart';
import 'package:locationprojectflutter/presentation/pages/sign_in_firebase.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';
import 'package:locationprojectflutter/presentation/widgets/tff_firebase.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'list_map.dart';

class RegisterEmailFirebase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterEmailFirebaseProvider>(
      builder: (context, results, child) {
        return RegisterEmailFirebaseProv();
      },
    );
  }
}

class RegisterEmailFirebaseProv extends StatefulWidget {
  @override
  _RegisterEmailFirebaseProvState createState() =>
      _RegisterEmailFirebaseProvState();
}

class _RegisterEmailFirebaseProvState extends State<RegisterEmailFirebaseProv> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _userEmail;
  var _provider;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider =
          Provider.of<RegisterEmailFirebaseProvider>(context, listen: false);
      _provider.success(null);
      _provider.loading(false);
      _provider.textError('');
    });

    _initGetSharedPrefs();
  }

  @override
  void dispose() {
    super.dispose();

    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Form(
        key: _formKey,
        child: Container(
          color: Colors.blueGrey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Register',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent,
                      fontSize: 40,
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveScreen().heightMediaQuery(context, 70),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: ResponsiveScreen().heightMediaQuery(context, 20),
                    ),
                    child: TFFFirebase(
                      icon: Icon(Icons.email),
                      hint: "Email",
                      controller: _emailController,
                      textInputType: TextInputType.emailAddress,
                      obSecure: false,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: ResponsiveScreen().heightMediaQuery(context, 20),
                    ),
                    child: TFFFirebase(
                      icon: Icon(Icons.lock),
                      hint: "Password",
                      controller: _passwordController,
                      textInputType: TextInputType.text,
                      obSecure: true,
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveScreen().heightMediaQuery(context, 20),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: ResponsiveScreen().widthMediaQuery(context, 20),
                        right: ResponsiveScreen().widthMediaQuery(context, 20),
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Container(
                      height: ResponsiveScreen().heightMediaQuery(context, 50),
                      width: MediaQuery.of(context).size.width,
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
                          'Register',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            if (Validations()
                                    .validateEmail(_emailController.text) &&
                                Validations().validatePassword(
                                    _passwordController.text)) {
                              _provider.loading(true);
                              _provider.textError('');

                              _registerEmailFirebase();
                            } else if (!Validations()
                                .validateEmail(_emailController.text)) {
                              _provider.success(false);
                              _provider.textError('Invalid Email');
                            } else if (!Validations()
                                .validatePassword(_passwordController.text)) {
                              _provider.success(false);
                              _provider.textError(
                                  'Password must be at least 8 characters');
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveScreen().heightMediaQuery(context, 5),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      _provider.successGet == null
                          ? ''
                          : _provider.successGet ? '' : _provider.textErrorGet,
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignInFirebase(),
                        ),
                      );
                    },
                    child: Text(
                      'Have an account? click here to login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ResponsiveScreen().heightMediaQuery(context, 20),
                  ),
                  _provider.loadingGet == true
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

  void _registerEmailFirebase() async {
    final FirebaseUser user = (await _auth
            .createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    )
            .catchError(
      (error) {
        _provider.success(false);
        _provider.loading(false);
        _provider.textError(error.message);
      },
    ))
        .user;
    if (user != null) {
      _provider.success(true);
      _provider.loading(false);
      _provider.textError('');

      final QuerySnapshot result = await _firestore
          .collection('users')
          .where('id', isEqualTo: user.uid)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        _firestore.collection('users').document(user.uid).setData(
          {
            'nickname': user.displayName,
            'photoUrl': user.photoUrl,
            'id': user.uid,
            'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
            'chattingWith': null
          },
        );

        await _provider.sharedGet.setString('id', user.uid);
        await _provider.sharedGet.setString('nickname', user.displayName);
        await _provider.sharedGet.setString('photoUrl', user.photoUrl);
      } else {
        await _provider.sharedGet.setString('id', documents[0]['id']);
        await _provider.sharedGet
            .setString('nickname', documents[0]['nickname']);
        await _provider.sharedGet.setString('aboutMe', documents[0]['aboutMe']);
        await _provider.sharedGet
            .setString('photoUrl', documents[0]['photoUrl']);
      }

      _userEmail = user.email;
      print(_userEmail);
      _addUserEmail(_userEmail);
      _addIdEmail(user.uid);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ListMap(),
        ),
      );
    } else {
      _provider.success(false);
      _provider.loading(false);
    }
  }

  void _initGetSharedPrefs() {
    SharedPreferences.getInstance().then(
      (prefs) {
        _provider.sharedPref(prefs);
      },
    );
  }

  void _addUserEmail(String value) async {
    _provider.sharedGet.setString('userEmail', value);
  }

  void _addIdEmail(String value) async {
    _provider.sharedGet.setString('userIdEmail', value);
  }
}
