// Copyright 2022 Manas Malla ©. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// The dart file that includes the code for a simple MVC controller that handles every product related workflow

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:nandikrushi_farmer/nav_items/profile_provider.dart';
import 'package:nandikrushi_farmer/onboarding/login_provider.dart';
import 'package:nandikrushi_farmer/product/product_provider.dart';
import 'package:nandikrushi_farmer/reusable_widgets/snackbar.dart';
import 'package:nandikrushi_farmer/reusable_widgets/success_screen.dart';
import 'package:nandikrushi_farmer/utils/server.dart';
import 'package:provider/provider.dart';

class ProductController extends ControllerMVC {
  List<XFile?> productImage = [];
  dynamic uid = FirebaseAuth.instance.currentUser?.uid;
  var formControllers = {
    'product-name': TextEditingController(),
    'quantity': TextEditingController(),
    'price': TextEditingController(),
    'description': TextEditingController()
  };

  String? selectedCategory;
  String? selectedUnits;
  String? selectedSubCategory;

  addProduct(
      context,
      List<String> image,
      List<String> unitsList,
      Function(String) showMessage,
      ProductProvider productProvider,
      ProfileProvider profileProvider) async {
    LoginProvider loginProvider = Provider.of(context);
    var data = {
      "name": formControllers['product-name']?.text,
      "category": selectedCategory,
      "subcategory": selectedSubCategory,
      "unit": selectedUnits,
      "quantity": formControllers['quantity']?.text,
      "price": formControllers['price']?.text,
      "description": formControllers['description']?.text
    };
    var isValidData = true;
    for (MapEntry<String, String?> dataValue in data.entries) {
      if ((dataValue.value != null && dataValue.value!.isNotEmpty) ||
          ((productProvider
                      .subcategories[
                          productProvider.categories[selectedCategory]]
                      ?.isEmpty ??
                  true) &&
              dataValue.key == "subcategory")) {
      } else {
        isValidData = false;
        snackbar(context, "Please enter a valid ${dataValue.key}");
      }
    }
    if (!isValidData) {
      profileProvider.hideLoader();
      return false;
    }
    var name = formControllers['product-name']?.text ?? "";
    var category = selectedCategory ?? "";

    var quantity = formControllers['quantity']?.text ?? "";
    var price = formControllers['price']?.text ?? "";
    var description = formControllers['description']?.text ?? "";
    // var product = Product(
    //     productName: name,
    //     category: category,
    //     subcategory: subcategory,
    //     units: units,
    //     price: double.tryParse(price) ?? 0.0,
    //     quantity: int.tryParse(quantity) ?? 0,
    //     description: description,
    //     productImage: image[0]);

    //TODO: Remind sir to add subcategories
    Map<String, String> body = {
      "user_id": uid.toString(),
      "name": name.toString(),
      "quantity": (int.tryParse(quantity) ?? 0).toString(),
      "price": (double.tryParse(price) ?? 0.0).toString(),
      "description": description.toString(),
      "units": (productProvider.units[selectedCategory]?.entries
              .firstWhere((element) => element.value == selectedUnits)
              .key)
          .toString(),
      //"category_id": product.category.toString(),
      "category_id": productProvider.categories[category].toString(),
      "sub_category_id": productProvider
              .subcategories[productProvider.categories[category]]
              ?.where((element) => element.keys.first == selectedSubCategory)
              .toString() ??
          "",
      "seller_id": profileProvider.sellerID,
    };
    if (!loginProvider.isFarmer) {
      body.addAll({"ingredients[]": "ingredient"});
    }
    image.asMap().entries.forEach((_) {
      body.addAll({"product_image[${_.key}]": _.value});
    });
    log(image.asMap().entries.toString());
    log(body.toString());
    Server()
        .postFormData(
            body: body,
            url:
                "https://nkweb.sweken.com/index.php?route=extension/account/purpletree_multivendor/api/addsellerproduct")
        .then((response) async {
      if (response == null) {
        showMessage("Failed to get a response from the server!");
        profileProvider.hideLoader();
        return;
      }
      if (response.statusCode == 200) {
        log("sucess");
        log(response.body);
        productProvider.getAllProducts(
            showMessage: showMessage, profileProvider: profileProvider);

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SuccessScreen(
                      body: body,
                      isSuccess: response.statusCode == 200,
                    )));
      } else if (response.statusCode == 400) {
        snackbar(context, "Undefined Parameter when calling API");
        profileProvider.hideLoader();
        log("Undefined Parameter");
      } else if (response.statusCode == 404) {
        snackbar(context, "API Not found");
        profileProvider.hideLoader();
        log("Not found");
      } else {
        log(response.statusCode.toString());
        snackbar(context,
            "Unable to connect to the server! Error code: ${response.statusCode}");
        profileProvider.hideLoader();
        log("failure");
      }
    });
    log(body.toString());
  }
}
