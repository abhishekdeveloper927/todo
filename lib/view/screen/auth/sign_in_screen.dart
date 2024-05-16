import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:todo/controller/auth_controller.dart';
import 'package:todo/view/base/loader.dart';
import 'package:todo/view/screen/auth/sign_up_screen.dart';
import 'package:todo/view/screen/auth/widget/input_field.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../base/button.dart';
import '../../base/show_snackbar.dart';
import '../dashboard/dashboard_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Get.theme.cardColor,
        body: ListView(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          children: [
            const SizedBox(
              height: 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  Images.logo,
                  width: Get.width / 2,
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Center(
              child: Text(
                "Welcome To Sign In!",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: Dimensions.fontSizeExtraLarge),
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            InputField(
              backgroundColor: Get.theme.scaffoldBackgroundColor,
              width: Get.width,
              subTitle: "Enter Email",
              prefixIcon: const Icon(
                Icons.email,
                color: Colors.black,
              ),
              title: "Email",
              controller: emailController,
              focusNode: emailFocusNode,
              nextFocus: passwordFocusNode,
            ),
            const SizedBox(
              height: Dimensions.paddingSizeDefault,
            ),
            InputField(
              obscureText: obscureText,
              backgroundColor: Get.theme.scaffoldBackgroundColor,
              width: Get.width,
              subTitle: "Enter Password",
              maxLine: 1,
              prefixIcon: const Icon(
                Icons.lock,
                color: Colors.black,
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    obscureText = !obscureText;
                  });
                },
                icon: FaIcon(
                  !obscureText
                      ? FontAwesomeIcons.eye
                      : FontAwesomeIcons.eyeSlash,
                  color: Colors.black,
                  size: 16,
                ),
              ),
              title: "Password",
              controller: passwordController,
              focusNode: passwordFocusNode,
            ),
            const SizedBox(
              height: Dimensions.paddingSizeOverLarge,
            ),
            GetBuilder<AuthController>(builder: (authController) {
              return !authController.isLoading
                  ? Button(
                      title: "Login",
                      onTap: () {
                        submit();
                      },
                      radius: 12,
                    )
                  : const Loader();
            }),
            const SizedBox(
              height: Dimensions.paddingSizeDefault,
            ),
            InkWell(
              onTap: () {
                Get.to(() => const SignUpScreen());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Create a new account?",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                  Text(
                    " Sign Up",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  void submit() {
    if (emailController.text.trim().isNotEmpty) {
      if (passwordController.text.trim().isNotEmpty) {
        Get.find<AuthController>()
            .signInWithEmailAndPassword(
                emailController.text, passwordController.text)
            .then((value) {
          Get.to(() => const DashBoardScreen());
        });
      } else {
        showCustomSnackBar('Enter Password', isError: true);
        passwordFocusNode.requestFocus();
      }
    } else {
      showCustomSnackBar('Enter Email', isError: true);
      emailFocusNode.requestFocus();
    }
  }
}
