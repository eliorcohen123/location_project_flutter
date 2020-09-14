import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:locationprojectflutter/presentation/state_management/provider/provider_register_email_firebase.dart';
import 'package:locationprojectflutter/presentation/utils/shower_pages.dart';
import 'package:locationprojectflutter/presentation/utils/utils_app.dart';
import 'package:locationprojectflutter/presentation/utils/validations.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';
import 'package:locationprojectflutter/presentation/widgets/widget_btn_firebase.dart';
import 'package:locationprojectflutter/presentation/widgets/widget_tff_firebase.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageRegisterEmailFirebase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderRegisterEmailFirebase>(
      builder: (context, results, child) {
        return PageRegisterEmailFirebaseProv();
      },
    );
  }
}

class PageRegisterEmailFirebaseProv extends StatefulWidget {
  @override
  _PageRegisterEmailFirebaseProvState createState() =>
      _PageRegisterEmailFirebaseProvState();
}

class _PageRegisterEmailFirebaseProvState
    extends State<PageRegisterEmailFirebaseProv> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  ProviderRegisterEmailFirebase _provider;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider =
          Provider.of<ProviderRegisterEmailFirebase>(context, listen: false);
      _provider.isSuccess(null);
      _provider.isLoading(false);
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
      body: Form(
        key: _formKey,
        child: Container(
          color: Colors.blueGrey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _title(),
                  UtilsApp.dividerHeight(context, 70),
                  _textFieldsData(),
                  UtilsApp.dividerHeight(context, 20),
                  _buttonRegister(),
                  UtilsApp.dividerHeight(context, 5),
                  _showErrors(),
                  _buttonToLogin(),
                  UtilsApp.dividerHeight(context, 20),
                  _loading(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _title() {
    return const Text(
      'Register',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.greenAccent,
        fontSize: 40,
      ),
    );
  }

  Widget _textFieldsData() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            bottom: ResponsiveScreen().heightMediaQuery(context, 20),
          ),
          child: WidgetTFFFirebase(
            icon: const Icon(Icons.email),
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
          child: WidgetTFFFirebase(
            icon: const Icon(Icons.lock),
            hint: "Password",
            controller: _passwordController,
            textInputType: TextInputType.text,
            obSecure: true,
          ),
        ),
      ],
    );
  }

  Widget _buttonRegister() {
    return Padding(
      padding: EdgeInsets.only(
          left: ResponsiveScreen().widthMediaQuery(context, 20),
          right: ResponsiveScreen().widthMediaQuery(context, 20),
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: WidgetBtnFirebase(
        text: 'Register',
        onTap: () => _checkClickBtnRegister(),
      ),
    );
  }

  void _checkClickBtnRegister() {
    if (_formKey.currentState.validate()) {
      if (Validations().validateEmail(_emailController.text) &&
          Validations().validatePassword(_passwordController.text)) {
        _provider.isLoading(true);
        _provider.textError('');

        _registerEmailFirebase();
      } else if (!Validations().validateEmail(_emailController.text)) {
        _provider.isSuccess(false);
        _provider.textError('Invalid Email');
      } else if (!Validations().validatePassword(_passwordController.text)) {
        _provider.isSuccess(false);
        _provider.textError('Password must be at least 8 characters');
      }
    }
  }

  Widget _showErrors() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        _provider.isSuccessGet == null
            ? ''
            : _provider.isSuccessGet ? '' : _provider.textErrorGet,
        style: const TextStyle(
          color: Colors.redAccent,
          fontSize: 15,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buttonToLogin() {
    return GestureDetector(
      onTap: () {
        ShowerPages.pushPageSignInFirebase(context);
      },
      child: const Text(
        'Have an account? click here to login',
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _loading() {
    return _provider.isLoadingGet == true
        ? const CircularProgressIndicator()
        : Container();
  }

  void _registerEmailFirebase() async {
    final FirebaseUser user = (await _auth
            .createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    )
            .catchError(
      (error) {
        _provider.isSuccess(false);
        _provider.isLoading(false);
        _provider.textError(error.message);
      },
    ))
        .user;
    if (user != null) {
      _provider.isSuccess(true);
      _provider.isLoading(false);
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

      print(user.email);
      _addUserEmail(user.email);
      _addIdEmail(user.uid);
      ShowerPages.pushRemoveReplacementPageListMap(context);
    } else {
      _provider.isSuccess(false);
      _provider.isLoading(false);
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
