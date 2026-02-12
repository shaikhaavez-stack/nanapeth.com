class Vendor {
  final String id;
  final String email;
  final String storeName;
  final String category;
  final String phone;
  final String address;
  final String city;
  final double rating;
  final int totalOrders;
  final double totalRevenue;
  final String status;
  final DateTime createdAt;

  Vendor({
    required this.id,
    required this.email,
    required this.storeName,
    required this.category,
    required this.phone,
    required this.address,
    required this.city,
    this.rating = 0.0,
    this.totalOrders = 0,
    this.totalRevenue = 0.0,
    this.status = 'Active',
    required this.createdAt,
  });

  factory Vendor.fromMap(Map<String, dynamic> map) {
    return Vendor(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      storeName: map['storeName'] ?? '',
      category: map['category'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      city: map['city'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      totalOrders: map['totalOrders'] ?? 0,
      totalRevenue: (map['totalRevenue'] ?? 0.0).toDouble(),
      status: map['status'] ?? 'Active',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'storeName': storeName,
      'category': category,
      'phone': phone,
      'address': address,
      'city': city,
      'rating': rating,
      'totalOrders': totalOrders,
      'totalRevenue': totalRevenue,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class VendorOrder {
  final String orderId;
  final String customerName;
  final int itemCount;
  final double totalAmount;
  final String status;
  final DateTime orderDate;

  VendorOrder({
    required this.orderId,
    required this.customerName,
    required this.itemCount,
    required this.totalAmount,
    required this.status,
    required this.orderDate,
  });
}
