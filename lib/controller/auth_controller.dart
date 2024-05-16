import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../data/model/response/user_model.dart';
import '../view/base/show_snackbar.dart';
import '../view/screen/dashboard/dashboard_screen.dart';

class AuthController extends GetxController implements GetxService {
  AuthController();

  bool isLoading = false;
  UserModel? userModel;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    isLoading = true;
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      isLoading = false;
      final user = userCredential.user;
      if (user != null) {
        getData(user.uid).then((value) {});
      }
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      if (e.code == 'user-not-found') {
        if (kDebugMode) {
          showCustomSnackBar("No user found for that email", isError: true);
        }
      } else if (e.code == 'wrong-password') {
        if (kDebugMode) {
          showCustomSnackBar("Wrong password provided for that user.",
              isError: true);
        }
      }
    }
    update();
  }

  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> getData(String id) async {
    isLoading = true;
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          isLoading = false;
          final data = documentSnapshot.data();
          if (data != null && data is Map<String, dynamic>) {
            userModel = UserModel.fromJson(data);
            if (kDebugMode) {
              print(jsonEncode(userModel));
            }
          } else {
            showCustomSnackBar("User data is invalid or null");
          }
        } else {
          showCustomSnackBar("User data not found");
        }
      }).catchError((error) {
        isLoading = false;
        showCustomSnackBar("An error occurred while checking status");
        if (kDebugMode) {
          print("Error checking status: $error");
        }
      });
    } catch (e) {
      isLoading = false;
      if (kDebugMode) {
        print(e);
      }
    }
    update();
  }

  Future<void> createUserWithEmailAndPassword(
      UserModel userModel, String password) async {
    try {
      isLoading = true;

      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: userModel.email!,
        password: password,
      )
          .then((value) {
        isLoading = false;
        userModel.createdAt = DateTime.now().millisecondsSinceEpoch;
        userModel.uid = value.user!.uid;
        addUser(userModel);
      });
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      if (e.code == 'weak-password') {
        if (kDebugMode) {
          showCustomSnackBar("The password provided is too weak.",
              isError: true);
        }
      } else if (e.code == 'email-already-in-use') {
        if (kDebugMode) {
          showCustomSnackBar("The account already exists for that email.",
              isError: true);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    update();
  }

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(UserModel userModel) async {
    isLoading = true;
    users.doc(userModel.uid).set(userModel.toJson()).then((value) {
      isLoading = false;
      Get.offAll(() => const DashBoardScreen());
    }).catchError((error) {
      isLoading = false;
      return null;
    });
    update();
  }
}
