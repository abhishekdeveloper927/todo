
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/controller/item_controller.dart';

import '../controller/auth_controller.dart';

Future<void> init() async {

  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);


  //Controller
  Get.lazyPut(() => AuthController());
  Get.lazyPut(() => ItemController());
}
