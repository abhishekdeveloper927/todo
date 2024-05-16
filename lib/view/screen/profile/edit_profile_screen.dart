import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/controller/auth_controller.dart';
import 'package:todo/util/images.dart';
import 'package:todo/view/screen/profile/widget/profile_data_field.dart';

import '../../../data/model/response/user_model.dart';
import '../../../util/dimensions.dart';
import '../../base/button.dart';
import '../../base/show_snackbar.dart';
import '../auth/widget/input_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Get.find<AuthController>()
          .getData(currentUser!.uid)
          .then((value) {});
      if (Get.find<AuthController>().userModel != null) {
        nameController.text = Get.find<AuthController>().userModel!.name ?? "";
        emailController.text =
            Get.find<AuthController>().userModel!.email ?? "";
        numberController.text =
            Get.find<AuthController>().userModel!.number ?? "";
      }
      super.initState();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance
        .collection('users')
        .where("uid", isEqualTo: currentUser!.uid)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Get.theme.primaryColor,
        title: Text(
          "Edit Profile",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: Dimensions.fontSizeLarge),
        ),
      ),
      backgroundColor: Get.theme.cardColor,
      body: StreamBuilder(
          stream: usersStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeDefault),
                      decoration: BoxDecoration(
                        color: Get.theme.scaffoldBackgroundColor,
                      ),
                      child: ListView(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Image.asset(
                            Images.logo,
                            height: 60,
                            width: 60,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InputField(
                            title: "Name",
                            controller: nameController,
                            subTitle: 'Enter Name',
                          ),
                          const SizedBox(
                            height: Dimensions.paddingSizeDefault,
                          ),
                          InputField(
                            title: "Email",
                            controller: emailController,
                            subTitle: 'Enter Number',
                          ),
                          const SizedBox(
                            height: Dimensions.paddingSizeDefault,
                          ),
                          InputField(
                            title: "Number",
                            controller: numberController,
                            subTitle: 'Enter Number',
                          ),
                          const SizedBox(
                            height: Dimensions.paddingSizeDefault,
                          ),
                          ProfileDataField(
                            title: "Joined ",
                            subTitle: DateFormat('EEE, d MMM').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    data['createdAt'] * 1000)),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          !isLoading
                              ? Button(
                                  title: "Update",
                                  onTap: () {
                                    submit();
                                  })
                              : const Center(child: CircularProgressIndicator())
                        ],
                      ),
                    ),
                  );
                }).toList());
          }),
    );
  }

  void submit() {
    if (nameController.text.trim().isNotEmpty) {
      if (emailController.text.trim().isNotEmpty) {
        if (numberController.text.trim().isNotEmpty) {
          UserModel userModel = UserModel(
            uid: currentUser!.uid,
            name: nameController.text,
            email: emailController.text,
            number: numberController.text,
          );
          isLoading = true;
          setState(() {});
          updateUser(userModel);
        } else {
          showCustomSnackBar("Enter Number", isError: true);
        }
      } else {
        showCustomSnackBar("Enter Email", isError: true);
      }
    } else {
      showCustomSnackBar("Enter Name", isError: true);
    }
  }

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> updateUser(UserModel userModel) async {
    final updates = <String, dynamic>{
      "name": userModel.name,
      "email": userModel.email,
      "number": userModel.number,
    };
    await users.doc(userModel.uid).update(updates).then((value) {
      isLoading = false;
      setState(() {});
      showCustomSnackBar("Updated");
    }).catchError((error) {
      showCustomSnackBar("Update Field $error");
    });
  }
}
