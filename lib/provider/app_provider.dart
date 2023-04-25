import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce1/firebase_helper/firebase_firestore_helper.dart';
import 'package:e_commerce1/models/product/product_model.dart';
import 'package:e_commerce1/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../const/utils.dart';
import '../firebase_helper/firebase_storage_helper.dart';

class AppProvider extends ChangeNotifier {
  List<ProductModel> _cartProductList = [];
  List<ProductModel> _byProductList = [];
  UserModel? _userModel;
  UserModel get getUserInformation => _userModel!;

  /////// CArt

  void addCartProduct(ProductModel productModel) {
    _cartProductList.add(productModel);
  }

  void removeCartProduct(ProductModel productModel) {
    _cartProductList.remove(productModel);
    notifyListeners();
  }

////// Favorite
  List<ProductModel> get getProductList => _cartProductList;
  List<ProductModel> _favoriteProductList = [];

  void addFavoriteProduct(ProductModel productModel) {
    _cartProductList.add(productModel);
  }

  void removeFavoriteProduct(ProductModel productModel) {
    _cartProductList.remove(productModel);
    notifyListeners();
  }

  List<ProductModel> get getFavoriteProductList => _favoriteProductList;

  ///////User Information
  ///
  ///
  void getUserInfoFirebase() async {
    _userModel = await FirebaseFirestoreHelper.instanse.getUserInformation();
    notifyListeners();
  }

  void updateUserInfoFirebase(
      BuildContext context, UserModel userModel, File? file) async {
    if (file == null) {
      showLoaderDialog(context);

      _userModel = userModel;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(_userModel!.id)
          .set(_userModel!.toJson());
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context).pop();
    } else {
      showLoaderDialog(context);

      String imageUrl =
          await FirebaseStorageHelper.instance.uploadUserImage(file);
      _userModel = userModel.copyWith(image: imageUrl);
      await FirebaseFirestore.instance
          .collection("users")
          .doc(_userModel!.id)
          .set(_userModel!.toJson());
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context).pop();
    }
    showMessage("Successfully updated profile");

    notifyListeners();
  }

  ///TOTAL PRICE////

  double totalPrice() {
    double totalPrice = 0.0;
    for (var element in _cartProductList) {
      totalPrice += element.price * element.qty!;
    }
    return totalPrice;
  }

  double totalPriceBuyProductList() {
    double totalPrice = 0.0;
    for (var element in _byProductList) {
      totalPrice += element.price * element.qty!;
    }
    return totalPrice;
  }

  void updateQty(ProductModel productModel, int qty) {
    int index = _cartProductList.indexOf(productModel);
    _cartProductList[index].qty = qty;
    notifyListeners();
  }

  ///By Product ///
  void addByProduct(ProductModel productModel) {
    _byProductList.add(productModel);
  }

  void addBuyProductCartList() {
    _byProductList.addAll(_cartProductList);
    notifyListeners();
  }

  void clearCart() {
    _cartProductList.clear();
    notifyListeners();
  }

  void clearBuyProduct() {
    _byProductList.clear();
    notifyListeners();
  }

  List<ProductModel> get getByProductList => _byProductList;
}
