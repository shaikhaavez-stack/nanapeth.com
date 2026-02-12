import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/product.dart';
import '../models/cart_item.dart';

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;
  var totalPrice = 0.0.obs;
  late SharedPreferences _prefs;

  @override
  void onInit() {
    super.onInit();
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _loadCart();
  }

  void addToCart(Product product) {
    final existingIndex = cartItems.indexWhere((item) => item.product.id == product.id);
    
    if (existingIndex != -1) {
      cartItems[existingIndex].quantity++;
    } else {
      cartItems.add(CartItem(product: product, quantity: 1));
    }
    
    _calculateTotal();
    _saveCart();
    update();
    Get.snackbar(
      'Success',
      '${product.name} added to cart!',
      backgroundColor: const Color(0xFF00C853),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void updateQuantity(int index, int quantity) {
    if (quantity <= 0) {
      removeItem(index);
    } else {
      cartItems[index].quantity = quantity;
      _calculateTotal();
      _saveCart();
      update();
    }
  }

  void removeItem(int index) {
    cartItems.removeAt(index);
    _calculateTotal();
    _saveCart();
    update();
  }

  void clearCart() {
    cartItems.clear();
    totalPrice.value = 0.0;
    _saveCart();
    update();
  }

  void _calculateTotal() {
    totalPrice.value = cartItems.fold(0.0, (sum, item) => sum + item.subtotal);
  }

  Future<void> _saveCart() async {
    final jsonList = cartItems.map((item) => jsonEncode(item.toJson())).toList();
    await _prefs.setStringList('cart_items', jsonList);
  }

  Future<void> _loadCart() async {
    final jsonList = _prefs.getStringList('cart_items') ?? [];
    cartItems.clear();
    for (var json in jsonList) {
      cartItems.add(CartItem.fromJson(jsonDecode(json)));
    }
    _calculateTotal();
    update();
  }
}
