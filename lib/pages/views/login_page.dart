import 'package:WhatsAppClone/services/auth_service.dart';
import 'package:flutter/material.dart';

import 'package:WhatsAppClone/core/constants.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _formKeyAuth;
  String _phoneNum;

  @override
  void initState() {
    _formKeyAuth = GlobalKey<FormState>();
    super.initState();
  }

  // build phone number text field
  Widget _buildTextFormField() {
    return TextFormField(
        autofocus: false,
        initialValue: '0587675744',
        decoration: InputDecoration(
            hintText: 'Enter your phone number',
            prefixIcon: Icon(Icons.phone),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(width: .7)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                    width: .7, color: Theme.of(context).accentColor))),
        keyboardType: TextInputType.phone,
        validator: (String value) {
          if (!value.contains(
              RegExp(r'^\+?(972|0)(\-)?0?(([23489]{1}\d{7})|[5]{1}\d{8})$'))) {
            return 'Invalid phone number';
          }
          return null;
        },
        onSaved: (String value) {
          _phoneNum = value;
        });
  }

  // build continue button
  Widget _buildContinueButton() {
    return FlatButton(
      child: Text(
        'Continue'.toUpperCase(),
        style: TextStyle(color: Colors.white),
      ),
      color: kPrimaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      onPressed: _submitForm,
    );
  }

  // build whatsapp icon
  Widget _buildWhatsAppIcon() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Image.asset(
        iconAssetName,
        fit: BoxFit.contain,
        height: 100,
        width: 100,
      ),
    );
  }

  // submit form function
  void _submitForm() {
    // validate phone num field
    if (_formKeyAuth.currentState.validate()) {
      // save phone num value
      _formKeyAuth.currentState.save();
      // register user auth service call
      AuthService.registerUser(_phoneNum, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Sign Up'),
        ),
        body: Container(
          padding: EdgeInsets.all(8.0),
          child: Form(
            key: _formKeyAuth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 15),
                _buildTextFormField(),
                SizedBox(height: 15),
                _buildContinueButton(),
                Spacer(),
                _buildWhatsAppIcon()
              ],
            ),
          ),
        ),
      ),
    );
  }
}