import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../util/images.dart';
import '../auth/sign_in_screen.dart';
import '../dashboard/dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser != null) {
      Future.delayed(const Duration(seconds: 3), () {
        Get.off(() => const DashBoardScreen());
      });
    } else {
      Future.delayed(const Duration(seconds: 3), () {
        Get.off(() => const SignInScreen());
      });
    }

    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: Center(
        child: Image.asset(
          Images.logo,
          width: 250,
          height: 250,
        ),
      ),
    );
  }
}
