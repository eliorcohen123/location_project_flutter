import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:locationprojectflutter/presentation/utils/shower_pages.dart';
import 'package:locationprojectflutter/presentation/utils/validations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderRegisterEmailFirebase extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  SharedPreferences _sharedPrefs;
  bool _isSuccess, _isLoading = false;
  String _textError = '';

  GlobalKey<FormState> get formKeyGet => _formKey;

  TextEditingController get emailControllerGet => _emailController;

  TextEditingController get passwordControllerGet => _passwordController;

  SharedPreferences get sharedGet => _sharedPrefs;

  bool get isSuccessGet => _isSuccess;

  bool get isLoadingGet => _isLoading;

  String get textErrorGet => _textError;

  void sharedPref(SharedPreferences sharedPrefs) {
    _sharedPrefs = sharedPrefs;
    notifyListeners();
  }

  void isSuccess(bool isSuccess) {
    _isSuccess = isSuccess;
    notifyListeners();
  }

  void isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void textError(String textError) {
    _textError = textError;
    notifyListeners();
  }

  void checkClickBtnRegister(BuildContext context) {
    if (_formKey.currentState.validate()) {
      if (Validations().validateEmail(_emailController.text) &&
          Validations().validatePassword(_passwordController.text)) {
        isLoading(true);
        textError('');

        _addToFirebase(context);
      } else if (!Validations().validateEmail(_emailController.text)) {
        isSuccess(false);
        textError('Invalid Email');
      } else if (!Validations().validatePassword(_passwordController.text)) {
        isSuccess(false);
        textError('Password must be at least 8 characters');
      }
    }
  }

  void _addToFirebase(BuildContext context) async {
    final User user = (await _auth
            .createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    )
            .catchError(
      (error) {
        isSuccess(false);
        isLoading(false);
        textError(error.message);
      },
    ))
        .user;
    if (user != null) {
      isSuccess(true);
      isLoading(false);
      textError('');

      final QuerySnapshot result = await _firestore
          .collection('users')
          .where('id', isEqualTo: user.uid)
          .get();
      final List<DocumentSnapshot> documents = result.docs;
      if (documents.length == 0) {
        _firestore.collection('users').doc(user.uid).set(
          {
            'nickname': user.displayName,
            'photoUrl': user.photoURL,
            'id': user.uid,
            'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
            'chattingWith': null
          },
        );

        await sharedGet.setString('id', user.uid);
        await sharedGet.setString('nickname', user.displayName);
        await sharedGet.setString('photoUrl', user.photoURL);
      } else {
        await sharedGet.setString('id', documents[0]['id']);
        await sharedGet.setString('nickname', documents[0]['nickname']);
        await sharedGet.setString('photoUrl', documents[0]['photoUrl']);
      }

      print(user.email);
      _addUserEmail(user.email);
      _addIdEmail(user.uid);
      ShowerPages.pushRemoveReplacementPageListMap(context);
    } else {
      isSuccess(false);
      isLoading(false);
    }
  }

  void initGetSharedPrefs() {
    SharedPreferences.getInstance().then(
      (prefs) {
        sharedPref(prefs);
      },
    );
  }

  void _addUserEmail(String value) async {
    sharedGet.setString('userEmail', value);
  }

  void _addIdEmail(String value) async {
    sharedGet.setString('userIdEmail', value);
  }
}
