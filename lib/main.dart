import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'screens/homepage.dart';
import 'screens/vendor_login.dart';
import 'screens/vendor_dashboard.dart';
import 'screens/add_product_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/profile_screen.dart';
import 'controllers/cart_controller.dart';
import 'controllers/vendor_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  
  // Initialize GetX controllers
  Get.put(CartController());
  Get.put(VendorController());
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'NanaPeth.com',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFFFF6200),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFF6200),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFFF6200),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF6200),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFFFF6200),
          unselectedItemColor: Colors.grey,
          elevation: 8,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      home: const MainNavWrapper(),
      getPages: [
        GetPage(name: '/', page: () => const HomePage()),
        GetPage(name: '/vendor-login', page: () => const VendorLoginScreen()),
        GetPage(name: '/vendor-dashboard', page: () => const VendorDashboardScreen()),
        GetPage(name: '/add-product', page: () => const AddProductScreen()),
        GetPage(name: '/cart', page: () => const CartScreen()),
        GetPage(name: '/profile', page: () => const ProfileScreen()),
      ],
    );
  }
}

class MainNavWrapper extends StatefulWidget {
  const MainNavWrapper({Key? key}) : super(key: key);

  @override
  State<MainNavWrapper> createState() => _MainNavWrapperState();
}

class _MainNavWrapperState extends State<MainNavWrapper> {
  int _currentIndex = 0;
  late CartController cartController;

  @override
  void initState() {
    super.initState();
    cartController = Get.find<CartController>();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const HomePage(),
      const CartScreen(),
      const ProfileScreen(),
    ];

    return GetBuilder<CartController>(
      builder: (_) => Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                label: Text(cartController.cartItems.length.toString()),
                isLabelVisible: cartController.cartItems.isNotEmpty,
                backgroundColor: const Color(0xFFFF6200),
                child: const Icon(Icons.shopping_cart_outlined),
              ),
              activeIcon: Badge(
                label: Text(cartController.cartItems.length.toString()),
                isLabelVisible: cartController.cartItems.isNotEmpty,
                backgroundColor: const Color(0xFFFF6200),
                child: const Icon(Icons.shopping_cart),
              ),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
