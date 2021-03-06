import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthenticationController extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isNewUser = false;
  String? _phoneNumber;
  var timeOut = const Duration(seconds: 30);
  int? _resendingToken;
  bool timedOut = false;

  late String _verificationId;

  Stream<User?> get onAuthStateChanges {
    return auth.authStateChanges();
  }

  void _updateIsNew(bool? value) {
    isNewUser = value ?? false;
    notifyListeners();
  }

  Future<void> resendOTP() async {
    timedOut = false;
    notifyListeners();
    void verificationFailed(FirebaseAuthException authException) {
      log('Phone number verification failed. Code: ${authException.code}. '
          'Message: ${authException.message}');

      Fluttertoast.showToast(
          msg: authException.message!, toastLength: Toast.LENGTH_LONG);
    }

    void codeSent(String verificationId, [int? forceResendingToken]) async {
      log('Please check your phone for the verification code.');

      _verificationId = verificationId;
      _resendingToken = forceResendingToken;
      notifyListeners();
    }

    void codeAutoRetrievalTimeout(String verificationId) {
      _verificationId = verificationId;
      timedOut = true;
      notifyListeners();
    }

    try {
      await auth.verifyPhoneNumber(
        phoneNumber: _phoneNumber!,
        timeout: timeOut,
        verificationCompleted: completed,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
        forceResendingToken: _resendingToken,
      );
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> onFieldSubmitted(String? value) async {
    _phoneNumber ??= value;
    timedOut = false;
    notifyListeners();

    void verificationFailed(FirebaseAuthException authException) {
      log('Phone number verification failed. Code: ${authException.code}. '
          'Message: ${authException.message}');

      Fluttertoast.showToast(
          msg: authException.message!, toastLength: Toast.LENGTH_LONG);
    }

    void codeSent(String verificationId, [int? forceResendingToken]) async {
      log('Please check your phone for the verification code.');

      _verificationId = verificationId;
      _resendingToken = forceResendingToken;
      notifyListeners();
    }

    void codeAutoRetrievalTimeout(String verificationId) {
      timedOut = true;
      _verificationId = verificationId;
      notifyListeners();
    }

    try {
      await auth.verifyPhoneNumber(
        phoneNumber: _phoneNumber ?? value!,
        timeout: timeOut,
        verificationCompleted: completed,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString(), toastLength: Toast.LENGTH_LONG);
    }
  }

  Future<bool> signInWithPhoneNumber(String? smsCode) async {
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: smsCode!,
      );
      final User user =
          await auth.signInWithCredential(credential).then((value) {
        _updateIsNew(value.additionalUserInfo?.isNewUser);
        return value.user!;
      });
      log('Successfully signed in UID: ${user.uid}');
      return true;
    } on FirebaseAuthException catch (e) {
      log("Failed to sign in \nError message : ${e.message}"
          "\nError code : ${e.code}");
      if (e.code == "invalid-verification-code") {
        Fluttertoast.showToast(
          msg: "Invalid Verification Code",
          toastLength: Toast.LENGTH_LONG,
          fontSize: 16.0,
          backgroundColor: Colors.black54,
          gravity: ToastGravity.SNACKBAR,
        );
      }
      return false;
    }
  }

  Future<void> signOut() async {
    if (await FlutterBackgroundService().isServiceRunning()) {
      FlutterBackgroundService().sendData({"action": "stopService"});
    }
    await auth.signOut();
  }

  ///Has to be empty if we don't want automatic sign in
  void completed(PhoneAuthCredential phoneAuthCredential) {}
}
