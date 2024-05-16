import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/view/screen/profile/widget/profile_data_field.dart';

import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../base/button.dart';
import '../auth/sign_in_screen.dart';
import 'edit_profile_screen.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  User? currentUser = FirebaseAuth.instance.currentUser;

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
          "Profile",
          style: TextStyle(
              color: Colors.white,
              fontSize: Dimensions.fontSizeLarge,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: InkWell(
                onTap: () {
                  Get.to(() => const EditProfileScreen());
                },
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                )),
          ),
        ],
      ),
      backgroundColor: Get.theme.cardColor,
      body: StreamBuilder(
          stream: usersStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
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
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(30),
                            topLeft: Radius.circular(30),
                          )),
                      child: ListView(
                        children: [
                          const SizedBox(
                            height: 40,
                          ),
                          Image.asset(
                            Images.logo,
                            height: 100,
                          ),
                          const SizedBox(
                            height: Dimensions.paddingSizeDefault,
                          ),
                          ProfileDataField(
                              title: "Name", subTitle: data['name']),
                          const SizedBox(
                            height: Dimensions.paddingSizeDefault,
                          ),
                          ProfileDataField(
                              title: "Email", subTitle: data['email']),
                          const SizedBox(
                            height: Dimensions.paddingSizeDefault,
                          ),
                          ProfileDataField(
                              title: "Number", subTitle: data['number'] ?? ""),
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
                            height: Dimensions.paddingSizeDefault,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Button(
                              title: "Logout",
                              onTap: () async {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              20.0)), //this right here
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.white,
                                        ),
                                        height: 280,
                                        width: 100,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: Image.asset(
                                                  Images.logo,
                                                  height: 100,
                                                  width: 100,
                                                ),
                                              ),
                                              const Text(
                                                "Do you want to logout?",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              const SizedBox(
                                                height: 16,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Get.back();
                                                    },
                                                    child: const Center(
                                                      child: Text(
                                                        "Cancel",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      await FirebaseAuth
                                                          .instance
                                                          .signOut();
                                                      Get.offAll(() =>
                                                          const SignInScreen());
                                                    },
                                                    child: const Text(
                                                      "Logout",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 16,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              })
                        ],
                      ),
                    ),
                  );
                }).toList());
          }),
    );
  }
}
