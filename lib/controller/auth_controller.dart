import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sapienpantry/utils/constants.dart';
import 'package:sapienpantry/view/dashboard.dart';
import 'package:sapienpantry/view/login_view.dart';

import '../view/onboarding_page.dart';
import '../widgets/image_loader.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();
  final Rx<User?> _user = Rx<User?>(firebaseAuth.currentUser);
  User? get user => _user.value;
  final Rx<bool> _isAuthenticating = Rx<bool>(false);
  bool get isAuthenticating => _isAuthenticating.value;

  final Rx<bool> _isReset = Rx<bool>(false);
  bool get isReset => _isReset.value;
  @override
  void onReady() {
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, onAuthStateChanged);
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _isAuthenticating.value = true;
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      _isAuthenticating.value = false;
      return true;
    } catch (e) {
      _isAuthenticating.value = false;
      debugPrint('$e');
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    try {
      _isAuthenticating.value = true;
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      _isAuthenticating.value = false;
      return true;
    } catch (e) {
      _isAuthenticating.value = false;
      debugPrint('$e');
      return false;
    }
  }
  Future<bool> resetPassword(String email) async {
    try {
      _isReset.value = true;
      await firebaseAuth.sendPasswordResetEmail(email: email);
      _isReset.value = false;
      return true;
    } catch (e) {
      _isReset.value = false;
      debugPrint('$e');
      return false;
    }
  }

  signOut() async {
    await firebaseAuth.signOut();
  }

  onAuthStateChanged(User? userx) {
    if (userx == null) {
      Get.offAll(() =>  LoginScreen());
    } else {
      Get.offAll(() =>  Dashboard());
    }
  }
}
