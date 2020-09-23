import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../locator.dart';
import '../local_storage/user_service.dart';

class AuthService {
  final _prefsService = locator<UserService>();

  /// register user with phone number [FirebaseAuth]
  Future registerUser(String mobile, BuildContext context) async {
    var _auth = FirebaseAuth.instance;

    await _auth.verifyPhoneNumber(
      phoneNumber: mobile,
      timeout: Duration(minutes: 1),
      verificationCompleted: (authCredential) {
        print('verificationCompleted');
        _auth.signInWithCredential(authCredential).then((_) {
          // save authentication in prefs service
          _prefsService.saveAuthentication(auth: true);
        }).catchError(print);
      },
      verificationFailed: (authException) {
        print('verificationFailed');
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Failed to verify phone number'),
              content: Text(authException.message),
            );
          },
        );
      },
      codeSent: (verificationId, forceResendingToken) {
        print('codeSent');
        var _codeController = TextEditingController();
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text('Enter SMS Code'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _codeController,
                  )
                ],
              ),
              actions: [
                FlatButton(
                  child: Text('DONE'),
                  onPressed: () {
                    var auth = FirebaseAuth.instance;
                    var smsCode = _codeController.text.trim();
                    var _credential = PhoneAuthProvider.credential(
                        verificationId: verificationId, smsCode: smsCode);
                    auth
                        .signInWithCredential(_credential)
                        .then((_) {})
                        .catchError(print);
                  },
                )
              ],
            );
          },
        );
      },
      codeAutoRetrievalTimeout: (verificationId) {
        print('codeAutoRetrievalTimeout');
        print('Timeout $verificationId');
      },
    );
  }

  /// mock register user
  Future mockRegisterUser({int delay = 3, bool auth = true}) async {
    await Future.delayed(Duration(seconds: delay), () {
      _prefsService.saveAuthentication(auth: auth);
    });
  }
}
