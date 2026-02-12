import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vendor.dart';

class VendorController extends GetxController {
  final Rx<Vendor?> currentVendor = Rx<Vendor?>(null);
  final RxList<VendorOrder> orders = <VendorOrder>[].obs;
  final RxList<Map<String, dynamic>> vendorProducts =
      <Map<String, dynamic>>[].obs;
  final RxInt totalOrders = 0.obs;
  final RxDouble totalRevenue = 0.0.obs;
  final RxInt productCount = 0.obs;
  final RxDouble rating = 4.5.obs;
  final RxMap<String, dynamic> analytics = <String, dynamic>{}.obs;
  final RxString currentVendorEmail = ''.obs;
  final RxBool isLoading = false.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    _initializeVendor();
  }

  Future<void> _initializeVendor() async {
    try {
      isLoading.value = true;
      final user = _auth.currentUser;
      if (user != null) {
        currentVendorEmail.value = user.email ?? '';
        await _loadVendorData();
        await _initializeTestData();
        _loadOrders();
        _loadAnalytics();
      }
    } catch (e) {
      // Log error if needed
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _initializeTestData() async {
    try {
      final vendorEmail = currentVendorEmail.value;
      final querySnapshot = await _firestore
          .collection('products')
          .where('vendorEmail', isEqualTo: vendorEmail)
          .get();

      // Only add test data if vendor has no products
      if (querySnapshot.docs.isEmpty) {
        final testProducts = [
          {
            'name': 'Premium Hardware Screws (1kg)',
            'price': 250,
            'category': 'Hardware',
            'description': 'Stainless steel screws assortment for various applications',
            'imageUrl':
                'https://images.unsplash.com/photo-1618923186063-20ffd3a6795c?w=500&h=500&fit=crop',
            'stock': 100,
          },
          {
            'name': 'Industrial Nuts & Bolts Pack',
            'price': 450,
            'category': 'Hardware',
            'description': 'Complete assortment of industrial grade nuts and bolts',
            'imageUrl':
                'https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?w=500&h=500&fit=crop',
            'stock': 80,
          },
          {
            'name': 'High-Quality Steel Nails (2kg)',
            'price': 200,
            'category': 'Hardware',
            'description': 'Various sizes of hardened steel nails for construction',
            'imageUrl':
                'https://images.unsplash.com/photo-1578926078328-123456789012?w=500&h=500&fit=crop',
            'stock': 150,
          },
          {
            'name': 'Brass Washers & Fasteners (500pcs)',
            'price': 320,
            'category': 'Hardware',
            'description': 'Premium brass washers for corrosion resistance',
            'imageUrl':
                'https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?w=500&h=500&fit=crop',
            'stock': 200,
          },
          {
            'name': 'Professional Garden Tool Set',
            'price': 1200,
            'category': 'Household',
            'description': 'Complete gardening tools with ergonomic handles',
            'imageUrl':
                'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=500&h=500&fit=crop',
            'stock': 45,
          },
        ];

        for (var product in testProducts) {
          await _firestore.collection('products').add({
            ...product,
            'vendorEmail': vendorEmail,
            'vendorName': currentVendor.value?.storeName ?? 'Unknown Vendor',
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
            'active': true,
            'rating': 0.0,
            'reviews': 0,
          });
        }
      }
    } catch (e) {
      // Log error if needed
    }
  }

  Future<void> _loadVendorData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final vendorDoc = await _firestore
            .collection('vendors')
            .doc(user.uid)
            .get();

        if (vendorDoc.exists) {
          final vendorData = vendorDoc.data() as Map<String, dynamic>;
          currentVendor.value = Vendor(
            id: user.uid,
            email: user.email ?? '',
            storeName: vendorData['storeName'] ?? 'My Store',
            category: vendorData['category'] ?? 'Hardware',
            phone: vendorData['phone'] ?? '+91 0000000000',
            address: vendorData['address'] ?? '',
            city: vendorData['city'] ?? 'Pune',
            rating: (vendorData['rating'] ?? 4.5).toDouble(),
            totalOrders: vendorData['totalOrders'] ?? 0,
            totalRevenue: (vendorData['totalRevenue'] ?? 0.0).toDouble(),
            status: vendorData['status'] ?? 'Active',
            createdAt: vendorData['createdAt'] != null
                ? (vendorData['createdAt'] as Timestamp).toDate()
                : DateTime.now(),
          );
        } else {
          // Create new vendor profile
          currentVendor.value = Vendor(
            id: user.uid,
            email: user.email ?? '',
            storeName: 'My Hardware Store',
            category: 'Hardware',
            phone: '+91 0000000000',
            address: '123 Nana Peth Market',
            city: 'Pune',
            rating: 4.5,
            totalOrders: 0,
            totalRevenue: 0.0,
            status: 'Active',
            createdAt: DateTime.now(),
          );
          await _firestore.collection('vendors').doc(user.uid).set(
                currentVendor.value!.toMap(),
              );
        }
      }
    } catch (e) {
      // Log error if needed
    }
  }

  void _loadOrders() {
    orders.assignAll([
      VendorOrder(
        orderId: 'ORD001',
        customerName: 'Rajesh Kumar',
        itemCount: 5,
        totalAmount: 2500,
        status: 'Pending',
        orderDate: DateTime.now(),
      ),
      VendorOrder(
        orderId: 'ORD002',
        customerName: 'Priya Singh',
        itemCount: 3,
        totalAmount: 1800,
        status: 'Confirmed',
        orderDate: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      VendorOrder(
        orderId: 'ORD003',
        customerName: 'Amit Patel',
        itemCount: 8,
        totalAmount: 4200,
        status: 'Shipped',
        orderDate: DateTime.now().subtract(const Duration(days: 1)),
      ),
      VendorOrder(
        orderId: 'ORD004',
        customerName: 'Sneha Verma',
        itemCount: 2,
        totalAmount: 950,
        status: 'Delivered',
        orderDate: DateTime.now().subtract(const Duration(days: 2)),
      ),
      VendorOrder(
        orderId: 'ORD005',
        customerName: 'Vikram Desai',
        itemCount: 6,
        totalAmount: 3100,
        status: 'Delivered',
        orderDate: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ]);
  }

  Stream<List<Map<String, dynamic>>> getVendorProductsStream() {
    if (currentVendorEmail.value.isEmpty) {
      return Stream.value([]);
    }
    return _firestore
        .collection('products')
        .where('vendorEmail', isEqualTo: currentVendorEmail.value)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data(),
              })
          .toList();
    });
  }

  void _loadAnalytics() {
    analytics.assignAll({
      'monthlyRevenue': 28500.0,
      'revenueGrowth': 12.5,
      'conversionRate': 3.8,
      'avgOrderValue': 1820.0,
      'customerRetention': 68.5,
      'returnRate': 2.3,
    });
  }

  Future<void> addProductToFirestore({
    required String name,
    required double price,
    required String category,
    required String description,
    required String imageUrl,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      final productData = {
        'vendorId': currentVendor.value?.id ?? user.uid,
        'vendorEmail': user.email,
        'vendorName': currentVendor.value?.storeName ?? 'Unknown Vendor',
        'name': name,
        'price': price,
        'category': category,
        'description': description,
        'imageUrl': imageUrl,
        'stock': 100,
        'rating': 0.0,
        'reviews': 0,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'active': true,
      };

      // Save to Firestore
      await _firestore.collection('products').add(productData);
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  Future<void> deleteProductFromFirestore(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
      Get.snackbar(
        'Success',
        'Product deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete product: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> updateProductInFirestore(
    String productId,
    String name,
    double price,
    int stock,
  ) async {
    try {
      await _firestore.collection('products').doc(productId).update({
        'name': name,
        'price': price,
        'stock': stock,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      Get.snackbar(
        'Success',
        'Product updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update product: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void updateOrderStatus(String orderId, String newStatus) {
    final orderIndex = orders.indexWhere((o) => o.orderId == orderId);
    if (orderIndex != -1) {
      final order = orders[orderIndex];
      orders[orderIndex] = VendorOrder(
        orderId: order.orderId,
        customerName: order.customerName,
        itemCount: order.itemCount,
        totalAmount: order.totalAmount,
        status: newStatus,
        orderDate: order.orderDate,
      );
      Get.snackbar(
        'Success',
        'Order status updated to $newStatus',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  void addProduct({
    required String name,
    required double price,
    required int stock,
    required String category,
  }) {
    vendorProducts.add({
      'id': 'P${vendorProducts.length + 1}',
      'name': name,
      'price': price,
      'stock': stock,
      'category': category,
    });
    productCount.value = vendorProducts.length;
    Get.snackbar(
      'Success',
      'Product added successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void updateProduct(
    String productId,
    String name,
    double price,
    int stock,
  ) {
    final index = vendorProducts.indexWhere((p) => p['id'] == productId);
    if (index != -1) {
      vendorProducts[index] = {
        'id': productId,
        'name': name,
        'price': price,
        'stock': stock,
        'category': vendorProducts[index]['category'],
      };
      Get.snackbar(
        'Success',
        'Product updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  void deleteProduct(String productId) {
    deleteProductFromFirestore(productId);
  }

  void logout() {
    currentVendor.value = null;
    vendorProducts.clear();
    currentVendorEmail.value = '';
    FirebaseAuth.instance.signOut();
  }
}
