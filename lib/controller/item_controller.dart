import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:todo/view/base/show_snackbar.dart';

import '../data/model/response/item_model.dart';

class ItemController extends GetxController implements GetxService {
  ItemController();

  bool isLoading = false;

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference items = FirebaseFirestore.instance.collection('items');

  String? datePick;
  List<ItemModel> itemList = [];

  Future<void> addItem(ItemModel itemModel, String userId) async {
    isLoading = true;

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentReference itemRef = firestore.collection('items').doc();
      await itemRef.set({
        "name": itemModel.name,
        "price": itemModel.price,
        "due_date": itemModel.dueDate,
        "id": itemRef.id,
        "user_id": userId,
      });
      isLoading = false;

      showCustomSnackBar(
        "Item added Successfully",
      );
      getItems();
    } catch (e) {
      isLoading = false;
      showCustomSnackBar("Item added Failed", isError: true);
    }

    update();
  }

  Future<List<ItemModel>> getItems() async {
    itemList.clear();
    try {
      isLoading = true;
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('items')
            .where("user_id", isEqualTo: user.uid)
            .get();
        for (var documentSnapshot in querySnapshot.docs) {
          if (documentSnapshot.exists) {
            isLoading = false;
            Map<String, dynamic> data =
                documentSnapshot.data() as Map<String, dynamic>;
            isLoading = false;
            itemList.add(ItemModel.fromJson(data));
          }
        }
      }
    } catch (e) {
      isLoading = false;
      if (kDebugMode) {
        print('Error getting user data: $e');
      }
    }
    update();

    return itemList;
  }

  Future<List<ItemModel>> getDueDateItems(String dueDate) async {
    itemList.clear();
    isLoading = true;
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('items')
            .where("user_id", isEqualTo: user.uid)
            .where("due_date", isEqualTo: dueDate)
            .get();
        for (var documentSnapshot in querySnapshot.docs) {
          if (documentSnapshot.exists) {
            Map<String, dynamic> data =
                documentSnapshot.data() as Map<String, dynamic>;
            isLoading = false;
            itemList.add(ItemModel.fromJson(data));
          }
        }
      }
    } catch (e) {
      isLoading = false;
      if (kDebugMode) {
        print('Error getting user data: $e');
      }
    }

    update();

    return itemList;
  }

  Future<void> updateItem(ItemModel itemModel) async {
    isLoading = true;
    try {
      isLoading = false;
      final updates = <String, dynamic>{
        "name": itemModel.name,
        "price": itemModel.price,
        "due_date": itemModel.dueDate,
      };
      await items.doc(itemModel.id).update(updates).then((value) {
        showCustomSnackBar(
          "Item Update Successfully",
        );
        getItems();
      }).catchError((error) {
        showCustomSnackBar("Update Field $error");
      });
    } catch (e) {
      isLoading = false;
      showCustomSnackBar("Item update Failed", isError: true);
    }
    update();
  }

  Future<void> deleteItem(ItemModel itemModel) async {
    isLoading = true;
    try {
      isLoading = false;
      await items.doc(itemModel.id).delete().then((value) {
        showCustomSnackBar(
          "Item Delete Successfully",
        );
        getItems();
      }).catchError((error) {
        showCustomSnackBar("Delete  Field $error");
      });
    } catch (e) {
      isLoading = false;
      showCustomSnackBar("Item Detele Failed", isError: true);
    }
    update();
  }
}
