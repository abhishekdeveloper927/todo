import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:todo/controller/auth_controller.dart';
import 'package:todo/view/base/loader.dart';
import 'package:todo/view/screen/auth/sign_in_screen.dart';
import 'package:todo/view/screen/auth/widget/input_field.dart';
import '../../../data/model/response/user_model.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../base/button.dart';
import '../../base/show_snackbar.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool obscureText = true;
  bool obscureText1 = true;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode numberFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Get.theme.cardColor,
        body: ListView(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          children: [
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  Images.logo,
                  width: 100,
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Text(
                "Welcome To Sign Up!",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: Dimensions.fontSizeExtraLarge),
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InputField(
              backgroundColor: Get.theme.scaffoldBackgroundColor,
              width: Get.width,
              subTitle: "Enter Name",
              prefixIcon: const Icon(
                Icons.person,
                color: Colors.black,
              ),
              title: "Name",
              controller: nameController,
              focusNode: nameFocusNode,
              nextFocus: emailFocusNode,
            ),
            const SizedBox(
              height: Dimensions.paddingSizeDefault,
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
              nextFocus: numberFocusNode,
            ),
            const SizedBox(
              height: Dimensions.paddingSizeDefault,
            ),
            InputField(
              backgroundColor: Get.theme.scaffoldBackgroundColor,
              width: Get.width,
              subTitle: "Enter Number",
              prefixIcon: const Icon(
                Icons.call,
                color: Colors.black,
              ),
              title: "Number",
              controller: numberController,
              focusNode: numberFocusNode,
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
              prefixIcon: const Icon(
                Icons.lock,
                color: Colors.black,
              ),
              title: "Password",
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
              maxLine: 1,
              controller: passwordController,
              focusNode: passwordFocusNode,
              nextFocus: confirmPasswordFocusNode,
            ),
            const SizedBox(
              height: Dimensions.paddingSizeDefault,
            ),
            InputField(
              obscureText: obscureText1,
              backgroundColor: Get.theme.scaffoldBackgroundColor,
              width: Get.width,
              subTitle: "Enter Confirm Password",
              prefixIcon: const Icon(
                Icons.lock,
                color: Colors.black,
              ),
              title: "Confirm Password",
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    obscureText1 = !obscureText1;
                  });
                },
                icon: FaIcon(
                  !obscureText1
                      ? FontAwesomeIcons.eye
                      : FontAwesomeIcons.eyeSlash,
                  color: Colors.black,
                  size: 16,
                ),
              ),
              maxLine: 1,
              controller: confirmPasswordController,
              focusNode: confirmPasswordFocusNode,
            ),
            const SizedBox(
              height: Dimensions.paddingSizeOverLarge,
            ),
            GetBuilder<AuthController>(builder: (authController) {
              return !authController.isLoading
                  ? Button(
                      title: "Register",
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
                Get.to(() => const SignInScreen());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                  Text(
                    " Sign In",
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
    if (nameController.text.trim().isNotEmpty) {
      if (numberController.text.trim().isNotEmpty) {
        if (emailController.text.trim().isNotEmpty) {
          if (passwordController.text.trim().isNotEmpty) {
            if (confirmPasswordController.text.trim().isNotEmpty) {
              if (passwordController.text == confirmPasswordController.text) {
                UserModel user = UserModel(
                  name: nameController.text.trim().toString(),
                  number: numberController.text.trim().toString(),
                  email: emailController.text.trim().toString(),
                );
                Get.find<AuthController>().createUserWithEmailAndPassword(
                    user, passwordController.text);
              } else {
                showCustomSnackBar('Password Mismatch', isError: true);
                confirmPasswordFocusNode.requestFocus();
              }
            } else {
              showCustomSnackBar('Enter Confirm Password', isError: true);
              confirmPasswordFocusNode.requestFocus();
            }
          } else {
            showCustomSnackBar('Enter Password', isError: true);
            passwordFocusNode.requestFocus();
          }
        } else {
          showCustomSnackBar('Enter Email', isError: true);
          emailFocusNode.requestFocus();
        }
      } else {
        showCustomSnackBar('Enter Number', isError: true);
        numberFocusNode.requestFocus();
      }
    } else {
      showCustomSnackBar('Enter Name', isError: true);
      nameFocusNode.requestFocus();
    }
  }
}
