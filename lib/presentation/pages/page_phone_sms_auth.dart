import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:locationprojectflutter/core/constants/constants_font_families.dart';
import 'package:locationprojectflutter/presentation/state_management/provider/provider_phone_sms_auth.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';
import 'package:locationprojectflutter/presentation/utils/utils_app.dart';
import 'package:locationprojectflutter/presentation/utils/validations.dart';
import 'package:locationprojectflutter/presentation/widgets/widget_tff_firebase.dart';
import 'package:provider/provider.dart';

class PagePhoneSMSAuth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderPhoneSMSAuth>(
      builder: (context, results, child) {
        return PagePhoneSMSAuthProv();
      },
    );
  }
}

class PagePhoneSMSAuthProv extends StatefulWidget {
  @override
  _PagePhoneSMSAuthProvState createState() => _PagePhoneSMSAuthProvState();
}

class _PagePhoneSMSAuthProvState extends State<PagePhoneSMSAuthProv> {
  ProviderPhoneSMSAuth _provider;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<ProviderPhoneSMSAuth>(context, listen: false);
      _provider.initGetSharedPrefs();
      _provider.isSuccess(null);
      _provider.isLoading(false);
      _provider.textError('');
      _provider.textOk('');
      _provider.sVerificationId(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                _showErrors(),
                UtilsApp.dividerHeight(context, 20),
                _loading(),
                UtilsApp.dividerHeight(context, 20),
                _buttonSendSms(),
                UtilsApp.dividerHeight(context, 20),
                _buttonLogin(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _title() {
    return const Text(
      'Phone Auth',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.greenAccent,
        fontSize: 40,
      ),
    );
  }

  Widget _textFieldsData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Form(
          key: _provider.formKeyPhoneGet,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: ResponsiveScreen().heightMediaQuery(context, 20),
            ),
            child: WidgetTFFFirebase(
              icon: const Icon(Icons.phone),
              hint: "Phone",
              controller: _provider.phoneControllerGet,
              textInputType: TextInputType.phone,
              obSecure: false,
            ),
          ),
        ),
        Form(
          key: _provider.formKeySmsGet,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: ResponsiveScreen().heightMediaQuery(context, 20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _tffSms(_provider.smsController1Get, _provider.focus1Get,
                    _provider.focus2Get, null),
                UtilsApp.dividerWidth(context, 5),
                _tffSms(_provider.smsController2Get, _provider.focus2Get,
                    _provider.focus3Get, _provider.focus1Get),
                UtilsApp.dividerWidth(context, 5),
                _tffSms(_provider.smsController3Get, _provider.focus3Get,
                    _provider.focus4Get, _provider.focus2Get),
                UtilsApp.dividerWidth(context, 5),
                _tffSms(_provider.smsController4Get, _provider.focus4Get,
                    _provider.focus5Get, _provider.focus3Get),
                UtilsApp.dividerWidth(context, 5),
                _tffSms(_provider.smsController5Get, _provider.focus5Get,
                    _provider.focus6Get, _provider.focus4Get),
                UtilsApp.dividerWidth(context, 5),
                _tffSms(_provider.smsController6Get, _provider.focus6Get, null,
                    _provider.focus5Get),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _showErrors() {
    return Container(
      alignment: Alignment.center,
      child: _provider.isSuccessGet == null
          ? null
          : _provider.textErrorGet != ''
              ? Text(
                  _provider.textErrorGet,
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                )
              : _provider.textOkGet != ''
                  ? Text(
                      _provider.textOkGet,
                      style: const TextStyle(
                        color: Colors.lightGreenAccent,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    )
                  : null,
    );
  }

  Widget _loading() {
    return _provider.isLoadingGet == true
        ? CircularProgressIndicator()
        : Container();
  }

  Widget _buttonSendSms() {
    return Padding(
      padding: EdgeInsets.only(
        left: ResponsiveScreen().widthMediaQuery(context, 20),
        right: ResponsiveScreen().widthMediaQuery(context, 20),
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
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
          child: const Text(
            'Send SMS',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          onPressed: () {
            if (_provider.formKeyPhoneGet.currentState.validate()) {
              if (_provider.phoneControllerGet.text.isNotEmpty) {
                if (Validations()
                    .validatePhone(_provider.phoneControllerGet.text)) {
                  _provider.isLoading(true);
                  _provider.textError('');
                  _provider.textOk('');

                  _provider.verifyPhoneNumber();
                } else if (!Validations()
                    .validatePhone(_provider.phoneControllerGet.text)) {
                  _provider.isSuccess(false);
                  _provider.textError('Invalid Phone');
                }
              }
            }
          },
        ),
      ),
    );
  }

  Widget _buttonLogin() {
    return Padding(
      padding: EdgeInsets.only(
        left: ResponsiveScreen().widthMediaQuery(context, 20),
        right: ResponsiveScreen().widthMediaQuery(context, 20),
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
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
          child: const Text(
            'Login after SMS',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          onPressed: () {
            if (_provider.formKeySmsGet.currentState.validate()) {
              if (_provider.smsController1Get.text.isNotEmpty &&
                  _provider.smsController2Get.text.isNotEmpty &&
                  _provider.smsController3Get.text.isNotEmpty &&
                  _provider.smsController4Get.text.isNotEmpty &&
                  _provider.smsController5Get.text.isNotEmpty &&
                  _provider.smsController6Get.text.isNotEmpty) {
                _provider.isLoading(true);
                _provider.textError('');

                _provider.signInWithPhoneNumber(context);
              }
            }
          },
        ),
      ),
    );
  }

  Widget _tffSms(TextEditingController num, FocusNode thisFocusNode,
      FocusNode nextFocusNode, FocusNode previousFocusNode) {
    return Container(
      width: ResponsiveScreen().widthMediaQuery(context, 48),
      height: ResponsiveScreen().widthMediaQuery(context, 48),
      alignment: Alignment.center,
      child: TextFormField(
        focusNode: thisFocusNode,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
        ],
        keyboardType: TextInputType.number,
        onChanged: (v) {
          if (num.text.length == 1) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          } else if (num.text.length == 0) {
            FocusScope.of(context).requestFocus(previousFocusNode);
          }
        },
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Colors.green,
              width: ResponsiveScreen().widthMediaQuery(context, 2),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Colors.green,
              width: ResponsiveScreen().widthMediaQuery(context, 3),
            ),
          ),
        ),
        textAlign: TextAlign.center,
        controller: num,
        validator: (String value) {
          if (value.isEmpty) {
            return '';
          }
          return null;
        },
        style: TextStyle(
          fontFamily: ConstantsFontFamilies.AVENIR,
          color: Colors.greenAccent,
          fontSize: 17,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
        ),
      ),
    );
  }
}
