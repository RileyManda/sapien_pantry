import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sapienpantry/utils/constants.dart';
import 'package:sapienpantry/view/dashboard.dart';
import 'package:sapienpantry/view/login_view.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();
  final Rx<User?> _user = Rx<User?>(firebaseAuth.currentUser);
  User? get user => _user.value;
  final Rx<bool> _isAuthenticating = Rx<bool>(false);
  bool get isAuthenticating => _isAuthenticating.value;
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

  signOut() async {
    await firebaseAuth.signOut();
  }

  onAuthStateChanged(User? userx) {
    if (userx == null) {
      Get.offAll(() => const LoginScreen());
    } else {
      Get.offAll(() =>  Dashboard());
    }
  }
}
