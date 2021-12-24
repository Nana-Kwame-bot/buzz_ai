import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum VerificationStatus { loading, codeSent, successFul, failed }

class AuthenticationController extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final numberAuthFormKey = GlobalKey<FormState>();

  late String _verificationId;

  Stream<User?> get onAuthStateChanges {
    return auth.authStateChanges();
  }

  bool validatenumberForm(String? number) {
    if (numberAuthFormKey.currentState!.validate()) {
      _onFieldSubmitted(number);
      return true;
    } else {
      numberAuthFormKey.currentState!.reset();
      return false;
    }
  }

  Future<void> _onFieldSubmitted(String? value) async {
    Future<void> verificationCompleted(
        PhoneAuthCredential phoneAuthCredential) async {
      await auth.signInWithCredential(phoneAuthCredential);
      log(
        'Phone number automatically verified and user signed in: $phoneAuthCredential',
      );
      return;
    }

    void verificationFailed(FirebaseAuthException authException) {
      log('Phone number verification failed. Code: ${authException.code}. '
          'Message: ${authException.message}');
    }

    void codeSent(String verificationId, [int? forceResendingToken]) async {
      log('Please check your phone for the verification code.');

      _verificationId = verificationId;
    }

    void codeAutoRetrievalTimeout(String verificationId) {
      _verificationId = verificationId;
    }

    try {
      await auth.verifyPhoneNumber(
        phoneNumber: value!,
        timeout: const Duration(seconds: 120),
        verificationCompleted: verificationCompleted,
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
      final User user = (await auth.signInWithCredential(credential)).user!;
      log('Successfully signed in UID: ${user.uid}');
      return true;
    } catch (e) {
      debugPrint(e.toString() + 'Failed to sign in');
      return false;
    }
  }
}
