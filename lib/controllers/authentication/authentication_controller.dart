import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationController extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isNewUser = true;
  String? _phoneNumber;
  var timeOut = const Duration(seconds: 30);
  int? _resendingToken;

  late String _verificationId;

  Stream<User?> get onAuthStateChanges {
    return auth.authStateChanges();
  }

  void updateIsNew(bool? value) {
    isNewUser = value!;
    notifyListeners();
  }

  Future<void> resendOTP() async {
    void verificationFailed(FirebaseAuthException authException) {
      log('Phone number verification failed. Code: ${authException.code}. '
          'Message: ${authException.message}');
    }

    void codeSent(String verificationId, [int? forceResendingToken]) async {
      log('Please check your phone for the verification code.$forceResendingToken');

      _verificationId = verificationId;
      _resendingToken = forceResendingToken;
      notifyListeners();
    }

    void codeAutoRetrievalTimeout(String verificationId) {
      _verificationId = verificationId;
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
    }
  }

  Future<void> onFieldSubmitted(String? value) async {
    _phoneNumber ?? value;
    notifyListeners();

    // Future<void> verificationCompleted(
    //     PhoneAuthCredential phoneAuthCredential) async {
    //   await auth.signInWithCredential(phoneAuthCredential);
    //   log(
    //     'Phone number automatically verified and user signed in: $phoneAuthCredential',
    //   );
    //   return;
    // }

    void verificationFailed(FirebaseAuthException authException) {
      log('Phone number verification failed. Code: ${authException.code}. '
          'Message: ${authException.message}');
    }

    void codeSent(String verificationId, [int? forceResendingToken]) async {
      log('Please check your phone for the verification code.$forceResendingToken');

      _verificationId = verificationId;
      _resendingToken = forceResendingToken;
      notifyListeners();
    }

    void codeAutoRetrievalTimeout(String verificationId) {
      _verificationId = verificationId;
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
        log(value.additionalUserInfo!.isNewUser.toString());
        updateIsNew(value.additionalUserInfo?.isNewUser);
        return value.user!;
      });
      log('Successfully signed in UID: ${user.uid}');
      return true;
    } catch (e) {
      log(e.toString() + 'Failed to sign in');
      return false;
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  ///Has to be empty if we don't want automatic sign in
  void completed(PhoneAuthCredential phoneAuthCredential) {}
}
