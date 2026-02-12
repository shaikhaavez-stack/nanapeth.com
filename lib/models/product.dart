class Product {
  final String id;
  final String name;
  final double price;
  final String vendor;
  final String imageUrl;
  final String category;
  final String description;
  final int quantity;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.vendor,
    required this.imageUrl,
    required this.category,
    required this.description,
    required this.quantity,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      vendor: map['vendor'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ?? '',
      description: map['description'] ?? '',
      quantity: map['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'vendor': vendor,
      'imageUrl': imageUrl,
      'category': category,
      'description': description,
      'quantity': quantity,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      vendor: json['vendor'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      quantity: json['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'vendor': vendor,
      'imageUrl': imageUrl,
      'category': category,
      'description': description,
      'quantity': quantity,
    };
  }
}
