import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/controller/item_controller.dart';
import 'package:todo/data/model/response/item_model.dart';
import 'package:todo/view/base/edit_item_dialog_box.dart';

import '../../../util/dimensions.dart';
import '../../base/button.dart';
import '../../base/show_snackbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();

  final ScrollController controller = ScrollController();
  final ScrollController controller2 = ScrollController();
  final ScrollController controller3 = ScrollController();
  final ScrollController controller4 = ScrollController();
  int? unitId;
  String? myDueDate;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ItemController>().getItems();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Get.theme.primaryColor,
          centerTitle: true,
          title: Text(
            "Item",
            style: TextStyle(
                fontSize: Dimensions.fontSizeLarge,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: GetBuilder<ItemController>(builder: (itemController) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
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
                Row(
                  children: [
                    Expanded(
                      child: Container(
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
                    ),
                    const SizedBox(
                      width: Dimensions.paddingSizeDefault,
                    ),
                    Expanded(
                      child: InkWell(
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
                                BoxShadow(
                                    color: Colors.grey[300]!, blurRadius: 3)
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
                    ),
                  ],
                ),
                const SizedBox(
                  height: Dimensions.paddingSizeDefault,
                ),
                Button(
                  title: "Add",
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
                    );
                    itemController
                        .addItem(
                            itemModel, FirebaseAuth.instance.currentUser!.uid)
                        .then((value) {
                      clearData();
                    });
                  },
                  padding: 5,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeDefault),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                                Dimensions.radiusDefault)),
                        child: TextFormField(
                          controller: searchController,
                          focusNode: searchFocus,
                          onChanged: (_) {
                            setState(() {});
                          },
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search Item",
                              hintStyle:
                                  TextStyle(fontSize: 14, color: Colors.grey)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: Dimensions.paddingSizeDefault,
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
                          if (kDebugMode) {
                            print(itemController.datePick);
                            myDueDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                            await itemController.getDueDateItems(
                                DateFormat('yyyy-MM-dd').format(pickedDate));
                          }
                        } else {
                          if (kDebugMode) {
                            print("Date is not selected");
                          }
                        }
                      },
                      child: const Icon(
                        Icons.calendar_month,
                        color: Colors.green,
                        size: 30,
                      ),
                    ),
                    const SizedBox(
                      width: Dimensions.paddingSizeLarge,
                    )
                  ],
                ),
                SizedBox(
                  height: myDueDate != null ? Dimensions.paddingSizeDefault : 0,
                ),
                myDueDate != null
                    ? InkWell(
                        onTap: () async {
                          await itemController.getItems();
                          myDueDate = null;
                        },
                        child: Row(
                          children: [
                            Text(
                              'Remover Filter',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: Dimensions.fontSizeDefault,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: Dimensions.paddingSizeDefault,
                            ),
                            const Icon(
                              Icons.cancel_outlined,
                              color: Colors.black,
                            )
                          ],
                        ),
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 20,
                ),
                itemController.itemList
                        .where((element) => element.name!
                            .toLowerCase()
                            .contains(
                                searchController.text.trim().toLowerCase()))
                        .toList()
                        .isNotEmpty
                    ? Expanded(
                        child: Scrollbar(
                          controller: controller2,
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            controller: controller2,
                            scrollDirection: Axis.horizontal,
                            child: SingleChildScrollView(
                              controller: controller,
                              child: SizedBox(
                                child: DataTable(
                                  columnSpacing: 40,
                                  showBottomBorder: true,
                                  dataRowColor: MaterialStateProperty.all(
                                      Get.theme.cardColor),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(
                                              Dimensions.radiusDefault),
                                          topRight: Radius.circular(
                                              Dimensions.radiusDefault)),
                                      color: Get.theme.primaryColor),
                                  columns: [
                                    DataColumn(
                                        label: Text(
                                      'No.',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: Dimensions.fontSizeDefault,
                                          fontWeight: FontWeight.bold),
                                    )),
                                    DataColumn(
                                        label: Center(
                                      child: Text(
                                        'Item Name',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                Dimensions.fontSizeDefault,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      'Price',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: Dimensions.fontSizeDefault,
                                          fontWeight: FontWeight.bold),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      'Due Date',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: Dimensions.fontSizeDefault,
                                          fontWeight: FontWeight.bold),
                                    )),
                                    DataColumn(
                                        label: Center(
                                      child: Text(
                                        'Action',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                Dimensions.fontSizeDefault,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                                  ],
                                  rows: itemController.itemList
                                      .where((element) => element.name!
                                          .toLowerCase()
                                          .contains(searchController.text
                                              .trim()
                                              .toLowerCase()))
                                      .toList()
                                      .asMap()
                                      .entries
                                      .map((e) {
                                    final index = e.key + 1;
                                    return DataRow(
                                      cells: [
                                        DataCell(
                                          Text(
                                            index.toString(),
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            e.value.name!,
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            e.value.price ?? "",
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                        ),
                                        DataCell(
                                          Center(
                                            child: Text(
                                              e.value.dueDate ?? "",
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                        DataCell(Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return EditItemDialogBox(
                                                      itemModel: e.value,
                                                    );
                                                  },
                                                );
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius: BorderRadius
                                                        .circular(Dimensions
                                                            .radiusDefault)),
                                                child: const Icon(
                                                  Icons.edit,
                                                  color: Colors.white,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            InkWell(
                                              onTap: () {
                                                itemController
                                                    .deleteItem(e.value);
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius: BorderRadius
                                                        .circular(Dimensions
                                                            .radiusDefault)),
                                                child: const Icon(
                                                  Icons.delete,
                                                  color: Colors.white,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          "No Data Found",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: Dimensions.fontSizeLarge,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
              ],
            ),
          );
        }));
  }

  clearData() {
    priceController.clear();
    nameController.clear();
    Get.find<ItemController>().datePick = null;
    Get.find<ItemController>().update();
    Get.find<ItemController>().update();
  }
}
