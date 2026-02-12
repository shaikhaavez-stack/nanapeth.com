import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import '../controllers/cart_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late CartController cartController;
  String? selectedCategory;
  late List<Product> filteredProducts;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabScaleAnimation;

  final List<String> categories = [
    'All',
    'Automotive',
    'Hardware',
    'Electrical',
    'Construction',
    'Plumbing',
    'Paint & Coating',
  ];

  final List<Product> mockProducts = [
    // Hardware
    Product(
      id: '1',
      name: 'Hardware Screws Assortment (1kg)',
      price: 200,
      vendor: 'Shree Hardware',
      imageUrl:
          'https://images.unsplash.com/photo-1618923186063-20ffd3a6795c?w=500&h=500&fit=crop',
      category: 'Hardware',
      description: 'Stainless steel hardware screws assortment',
      quantity: 120,
    ),
    Product(
      id: '2',
      name: 'Nuts & Bolts Assortment Pack',
      price: 400,
      vendor: 'FastenerWorld',
      imageUrl:
          'https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?w=500&h=500&fit=crop',
      category: 'Hardware',
      description: 'Complete assortment of nuts and bolts',
      quantity: 150,
    ),
    Product(
      id: '3',
      name: 'Nails Assortment (2kg)',
      price: 180,
      vendor: 'ShreeTrade',
      imageUrl:
          'https://images.unsplash.com/photo-1578926078328-123456789012?w=500&h=500&fit=crop',
      category: 'Hardware',
      description: 'Various sizes of steel and iron nails',
      quantity: 200,
    ),
    Product(
      id: '4',
      name: 'Washers & Fasteners (500pcs)',
      price: 250,
      vendor: 'Fastener Hub',
      imageUrl:
          'https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?w=500&h=500&fit=crop',
      category: 'Hardware',
      description: 'Stainless steel washers and fasteners',
      quantity: 100,
    ),
    // Automotive
    Product(
      id: '5',
      name: 'Auto Battery 12V',
      price: 3500,
      vendor: 'Ram Auto Parts',
      imageUrl:
          'https://images.unsplash.com/photo-1609623814075-e51df1bdc82f?w=500&h=500&fit=crop',
      category: 'Automotive',
      description: 'Premium quality auto battery for all vehicles',
      quantity: 45,
    ),
    Product(
      id: '6',
      name: 'Vehicle Tires (17 inch)',
      price: 2500,
      vendor: 'Goodyear Distributor',
      imageUrl:
          'https://images.unsplash.com/photo-1486312338219-ce68d2c6f44d?w=500&h=500&fit=crop',
      category: 'Automotive',
      description: 'High-quality vehicle tires with warranty',
      quantity: 25,
    ),
    Product(
      id: '7',
      name: 'Engine Oil SAE 15W40 (5L)',
      price: 680,
      vendor: 'LubriCare',
      imageUrl:
          'https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?w=500&h=500&fit=crop',
      category: 'Automotive',
      description: 'High-performance industrial machine oil',
      quantity: 40,
    ),
    Product(
      id: '8',
      name: 'Spark Plugs (Pack of 4)',
      price: 450,
      vendor: 'AutoParts Pro',
      imageUrl:
          'https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?w=500&h=500&fit=crop',
      category: 'Automotive',
      description: 'Original equipment spark plugs',
      quantity: 80,
    ),
    // Electrical
    Product(
      id: '9',
      name: 'Electrical Wire 2.5mm (100m)',
      price: 1200,
      vendor: 'ElectroMart',
      imageUrl:
          'https://images.unsplash.com/photo-1581092917692-8dc5d0c11d5d?w=500&h=500&fit=crop',
      category: 'Electrical',
      description: '2.5mm electrical copper wire roll',
      quantity: 60,
    ),
    Product(
      id: '10',
      name: 'Light Switches & Sockets',
      price: 150,
      vendor: 'ElectroPro',
      imageUrl:
          'https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?w=500&h=500&fit=crop',
      category: 'Electrical',
      description: 'Modular electrical switches and sockets',
      quantity: 200,
    ),
    Product(
      id: '11',
      name: 'Junction Boxes (10 units)',
      price: 320,
      vendor: 'ElectroMart',
      imageUrl:
          'https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?w=500&h=500&fit=crop',
      category: 'Electrical',
      description: 'PVC electrical junction boxes',
      quantity: 120,
    ),
    Product(
      id: '12',
      name: 'Cable Glands (20pcs)',
      price: 280,
      vendor: 'CableHub',
      imageUrl:
          'https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?w=500&h=500&fit=crop',
      category: 'Electrical',
      description: 'Brass cable glands assortment',
      quantity: 90,
    ),
    // Construction
    Product(
      id: '13',
      name: 'Cement Bags 50kg',
      price: 350,
      vendor: 'BuildRight Materials',
      imageUrl:
          'https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?w=500&h=500&fit=crop',
      category: 'Construction',
      description: 'Premium construction cement bags',
      quantity: 200,
    ),
    Product(
      id: '14',
      name: 'Steel Rods 12mm (1 ton)',
      price: 45000,
      vendor: 'Steel Hub',
      imageUrl:
          'https://images.unsplash.com/photo-1581092917692-8dc5d0c11d5d?w=500&h=500&fit=crop',
      category: 'Construction',
      description: 'Premium grade steel rods for construction',
      quantity: 10,
    ),
    Product(
      id: '15',
      name: 'Bricks (1000 units)',
      price: 8000,
      vendor: 'BrickWorld',
      imageUrl:
          'https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?w=500&h=500&fit=crop',
      category: 'Construction',
      description: 'Clay bricks for construction',
      quantity: 50,
    ),
    Product(
      id: '16',
      name: 'Plywood 12mm (8x4 ft)',
      price: 2200,
      vendor: 'WoodCraft',
      imageUrl:
          'https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?w=500&h=500&fit=crop',
      category: 'Construction',
      description: 'High-quality plywood sheets',
      quantity: 75,
    ),
    // Plumbing
    Product(
      id: '17',
      name: 'PVC Pipes 1 inch (100m)',
      price: 4500,
      vendor: 'Plumbing Pro',
      imageUrl:
          'https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?w=500&h=500&fit=crop',
      category: 'Plumbing',
      description: 'High-quality PVC plumbing pipes',
      quantity: 40,
    ),
    Product(
      id: '18',
      name: 'Brass Fittings Assortment',
      price: 580,
      vendor: 'PlumbingHub',
      imageUrl:
          'https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?w=500&h=500&fit=crop',
      category: 'Plumbing',
      description: 'Various brass plumbing fittings',
      quantity: 150,
    ),
    // Paint & Coating
    Product(
      id: '19',
      name: 'Wall Paint 20L Bucket',
      price: 1800,
      vendor: 'ColorWorks Paint',
      imageUrl:
          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=500&h=500&fit=crop',
      category: 'Paint & Coating',
      description: 'Premium interior/exterior wall paint',
      quantity: 80,
    ),
    Product(
      id: '20',
      name: 'Primer & Undercoat (20L)',
      price: 1200,
      vendor: 'PaintPro',
      imageUrl:
          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=500&h=500&fit=crop',
      category: 'Paint & Coating',
      description: 'White primer for all surfaces',
      quantity: 60,
    ),
  ];

  @override
  void initState() {
    super.initState();
    cartController = Get.find<CartController>();
    selectedCategory = 'All';
    _updateFilteredProducts();

    // Setup FAB animation
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabScaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _updateFilteredProducts() {
    if (selectedCategory == 'All') {
      filteredProducts = mockProducts;
    } else {
      filteredProducts = mockProducts
          .where((product) => product.category == selectedCategory)
          .toList();
    }
  }

  Future<void> _refreshProducts() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      _updateFilteredProducts();
    });
  }

  void _addToCart(Product product) {
    cartController.addToCart(product);
    _playFabAnimation();

    Get.snackbar(
      'Added to cart!',
      '${product.name}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }

  void _playFabAnimation() {
    _fabAnimationController.forward().then((_) {
      _fabAnimationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('NanaPeth.com'),
        elevation: 0,
        centerTitle: false,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshProducts,
        color: const Color(0xFFFF6200),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Banner
              Container(
                color: const Color(0xFFFF6200),
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'NanaPeth.com',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Wholesale to Your Doorstep',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => Get.toNamed('/vendor-login'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFFFF6200),
                      ),
                      child: const Text('Vendor Login'),
                    ),
                  ],
                ),
              ),
              // Features Grid
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1,
                  children: [
                    _buildFeatureCard(
                      context,
                      '🚚',
                      'Same-Day\nDelivery',
                    ),
                    _buildFeatureCard(
                      context,
                      '💰',
                      'Wholesale\nPrices',
                    ),
                    _buildFeatureCard(
                      context,
                      '🏪',
                      'Direct\nVendors',
                    ),
                    _buildFeatureCard(
                      context,
                      '❤️',
                      'Support\nLocal',
                    ),
                  ],
                ),
              ),
              // Category Filter Chips
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((category) {
                      final isSelected = selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              selectedCategory = selected ? category : null;
                              _updateFilteredProducts();
                            });
                          },
                          selectedColor: const Color(0xFFFF6200),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                          backgroundColor:
                              Colors.grey[100],
                          side: BorderSide(
                            color: isSelected
                                ? const Color(0xFFFF6200)
                                : Colors.grey[300]!,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              // Products Section with Responsive Grid
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Popular Products',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('products')
                          .where('active', isEqualTo: true)
                          .orderBy('createdAt', descending: true)
                          .limit(20)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(
                                        const Color(0xFFFF6200),
                                      ),
                                      strokeWidth: 3,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Loading products...',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Colors.grey[600],
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    size: 64,
                                    color: Colors.red[300],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Error loading products',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Colors.grey[600],
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        final products = snapshot.data?.docs ?? [];
                        final filteredByCategory = selectedCategory == 'All'
                            ? products
                            : products
                                .where((doc) =>
                                    doc['category'] == selectedCategory)
                                .toList();

                        if (filteredByCategory.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.shopping_cart_outlined,
                                    size: 64,
                                    color: Colors.grey[300],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No products in this category',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Colors.grey[600],
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return Column(
                          children: [
                            Text(
                              '${filteredByCategory.length} items',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                            ),
                            const SizedBox(height: 16),
                            GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: isTablet ? 3 : 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: 0.75,
                              ),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: filteredByCategory.length,
                              itemBuilder: (context, index) {
                                final doc = filteredByCategory[index];
                                final productData =
                                    doc.data() as Map<String, dynamic>;
                                return _buildProductCardFromFirestore(
                                  context,
                                  productData,
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Obx(
        () => ScaleTransition(
          scale: _fabScaleAnimation,
          child: FloatingActionButton.extended(
            onPressed: () {
              Get.snackbar(
                'Cart',
                'Total: ₹${cartController.totalPrice.toStringAsFixed(0)}',
                snackPosition: SnackPosition.TOP,
                backgroundColor: const Color(0xFFFF6200),
                colorText: Colors.white,
              );
            },
            label: Text(
              'CART (${cartController.cartItems.length})',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            icon: const Icon(Icons.shopping_cart),
            backgroundColor: const Color(0xFFFF6200),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String icon, String title) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFFF6200).withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              icon,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCardFromFirestore(
    BuildContext context,
    Map<String, dynamic> productData,
  ) {
    final product = Product(
      id: productData['id'] ?? '',
      name: productData['name'] ?? '',
      price: (productData['price'] ?? 0).toDouble(),
      vendor: productData['vendorName'] ?? 'Unknown',
      imageUrl: productData['imageUrl'] ?? '',
      category: productData['category'] ?? '',
      description: productData['description'] ?? '',
      quantity: productData['stock'] ?? 0,
    );

    return GestureDetector(
      onTap: () => _addToCart(product),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: CachedNetworkImage(
                imageUrl: productData['imageUrl'] ?? '',
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.error),
                ),
              ),
            ),
            // Product Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      productData['name'] ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                    ),
                    const SizedBox(height: 4),
                    // Vendor Name
                    Text(
                      'by ${productData['vendorName'] ?? 'Unknown'}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                            fontSize: 10,
                          ),
                    ),
                    const Spacer(),
                    // Price and Category Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Price
                        Text(
                          '₹${(productData['price'] ?? 0).toStringAsFixed(0)}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                                fontSize: 14,
                              ),
                        ),
                        // Category Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6200)
                                .withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: const Color(0xFFFF6200)
                                  .withValues(alpha: 0.3),
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            productData['category'] ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFFFF6200),
                                  fontSize: 9,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }}