import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/controller/item_controller.dart';
import 'package:todo/view/base/loader.dart';
import 'package:todo/view/base/show_snackbar.dart';
import '../../data/model/response/item_model.dart';
import '../../util/dimensions.dart';
import 'button.dart';

class EditItemDialogBox extends StatefulWidget {
  final ItemModel itemModel;

  const EditItemDialogBox({Key? key, required this.itemModel})
      : super(key: key);

  @override
  State<EditItemDialogBox> createState() => _EditItemDialogBoxState();
}

class _EditItemDialogBoxState extends State<EditItemDialogBox> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  int? unitId;
  String? unitValue;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      nameController.text = widget.itemModel.name ?? "";
      priceController.text = widget.itemModel.price ?? "";
      setState(() {
        Get.find<ItemController>().datePick = widget.itemModel.dueDate!;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: GetBuilder<ItemController>(builder: (itemController) {
        return Container(
          height: 400,
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Get.theme.scaffoldBackgroundColor),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "UPDATE ITEMS",
                style: TextStyle(
                    color: Colors.black, fontSize: Dimensions.fontSizeLarge),
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                    color: Get.theme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.grey[300]!, blurRadius: 3)
                    ]),
                child: TextFormField(
                  maxLines: 1,
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  onChanged: (val) {},
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Item name",
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      )),
                ),
              ),
              const SizedBox(
                height: Dimensions.paddingSizeDefault,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                    color: Get.theme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.grey[300]!, blurRadius: 3)
                    ]),
                child: TextFormField(
                  maxLines: 1,
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  onChanged: (val) {},
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Item Price",
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      )),
                ),
              ),
              const SizedBox(
                height: Dimensions.paddingSizeDefault,
              ),
              InkWell(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      initialEntryMode: DatePickerEntryMode.calendar,
                      context: context,
                      initialDate: DateTime.now(),
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData(
                            colorScheme: ColorScheme.light(
                                onBackground: Colors.black,
                                primary: Colors.red.shade50,
                                primaryContainer: Colors.red,
                                onPrimary: Colors.red,
                                brightness: Brightness.light),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor:
                                    Colors.black, // button text color
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                      //get today's date
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101));
                  if (pickedDate != null) {
                    if (kDebugMode) {
                      print(pickedDate);
                    }
                    itemController.datePick =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    if (kDebugMode) {
                      print(itemController.datePick);
                      setState(() {
                        itemController.datePick =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                      });
                    }
                  } else {
                    if (kDebugMode) {
                      print("Date is not selected");
                    }
                  }
                },
                child: Container(
                  width: Get.width,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Get.theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.grey[300]!, blurRadius: 3)
                      ]),
                  child: Text(
                    itemController.datePick ?? "Choose Due Date",
                    style: TextStyle(
                      color: itemController.datePick != null
                          ? Colors.black
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              !itemController.isLoading
                  ? Button(
                      title: "Update",
                      onTap: () {
                        if (nameController.text.isEmpty) {
                          return showCustomSnackBar("Please enter name",
                              isError: false);
                        }
                        if (priceController.text.isEmpty) {
                          return showCustomSnackBar("Please enter price",
                              isError: false);
                        }
                        if (itemController.datePick == null) {
                          return showCustomSnackBar("Please choose due date",
                              isError: false);
                        }

                        ItemModel itemModel = ItemModel(
                          name: nameController.text,
                          dueDate: itemController.datePick,
                          price: priceController.text,
                          id: widget.itemModel.id,
                        );
                        itemController.updateItem(itemModel);
                        clearData();
                        Get.close(1);
                      },
                      padding: 5,
                      width: 150,
                      height: 40,
                    )
                  : const Loader(),
            ],
          ),
        );
      }),
    );
  }

  clearData() {
    priceController.clear();
    nameController.clear();
    Get.find<ItemController>().datePick = null;
    Get.find<ItemController>().update();
    Get.find<ItemController>().update();
  }
}
