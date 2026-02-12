import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controllers/vendor_controller.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late VendorController vendorController;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    vendorController = Get.find<VendorController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User Profile Section
            Container(
              color: const Color(0xFFFF6200).withValues(alpha: 0.1),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6200),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Center(
                      child: Text(
                        _getInitials(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _auth.currentUser?.email ?? 'Guest User',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _auth.currentUser == null ? 'Not logged in' : 'Logged in',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
            // Quick Actions
            if (_auth.currentUser != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: [
                    _buildQuickActionCard(
                      context,
                      Icons.shopping_bag_outlined,
                      'Orders',
                      'View your orders',
                      () {
                        Get.snackbar(
                          'Orders',
                          'Order history coming soon!',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.blue,
                          colorText: Colors.white,
                        );
                      },
                    ),
                    _buildQuickActionCard(
                      context,
                      Icons.favorite_outline,
                      'Wishlist',
                      'Saved items',
                      () {
                        Get.snackbar(
                          'Wishlist',
                          'Wishlist feature coming soon!',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.blue,
                          colorText: Colors.white,
                        );
                      },
                    ),
                    _buildQuickActionCard(
                      context,
                      Icons.location_on_outlined,
                      'Addresses',
                      'Manage addresses',
                      () {
                        Get.snackbar(
                          'Addresses',
                          'Address management coming soon!',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.blue,
                          colorText: Colors.white,
                        );
                      },
                    ),
                    _buildQuickActionCard(
                      context,
                      Icons.payment_outlined,
                      'Payments',
                      'Payment methods',
                      () {
                        Get.snackbar(
                          'Payments',
                          'Payment management coming soon!',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.blue,
                          colorText: Colors.white,
                        );
                      },
                    ),
                  ],
                ),
              ),
            // Menu Items
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_auth.currentUser != null) ...[
                    Text(
                      'Settings',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      context,
                      Icons.notifications_outlined,
                      'Notifications',
                      () {
                        Get.snackbar(
                          'Notifications',
                          'Settings coming soon!',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.blue,
                          colorText: Colors.white,
                        );
                      },
                    ),
                    _buildMenuItem(
                      context,
                      Icons.language_outlined,
                      'Language',
                      () {
                        Get.snackbar(
                          'Language',
                          'Currently set to English',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.blue,
                          colorText: Colors.white,
                        );
                      },
                    ),
                    _buildMenuItem(
                      context,
                      Icons.help_outline,
                      'Help & Support',
                      () {
                        Get.snackbar(
                          'Support',
                          'Contact us at support@nanapeth.com',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.blue,
                          colorText: Colors.white,
                        );
                      },
                    ),
                    _buildMenuItem(
                      context,
                      Icons.info_outline,
                      'About NanaPeth',
                      () {
                        _showAboutDialog(context);
                      },
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Vendor',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await _auth.signOut();
                        if (mounted) {
                          setState(() {});
                        }
                        Get.snackbar(
                          'Logged out',
                          'You have been logged out successfully',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      },
                      icon: const Icon(Icons.store_outlined),
                      label: const Text('Become a Vendor'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6200),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Account',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      context,
                      Icons.security_outlined,
                      'Privacy & Security',
                      () {
                        Get.snackbar(
                          'Privacy',
                          'Our privacy policy is available on our website',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.blue,
                          colorText: Colors.white,
                        );
                      },
                    ),
                    _buildMenuItem(
                      context,
                      Icons.description_outlined,
                      'Terms & Conditions',
                      () {
                        Get.snackbar(
                          'Terms',
                          'Terms available on our website',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.blue,
                          colorText: Colors.white,
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        _showLogoutDialog(context);
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ] else ...[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 32),
                        Icon(
                          Icons.person_outline,
                          size: 80,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Sign in to your account',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Login to access exclusive deals and track your orders',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: Colors.grey[600],
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton.icon(
                          onPressed: () {
                            Get.toNamed('/vendor-login');
                          },
                          icon: const Icon(Icons.login),
                          label: const Text('Sign In'),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: () {
                            Get.snackbar(
                              'Sign Up',
                              'Create a new account on our website',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.blue,
                              colorText: Colors.white,
                            );
                          },
                          icon: const Icon(Icons.person_add_outlined),
                          label: const Text('Create Account'),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials() {
    final email = _auth.currentUser?.email ?? 'G';
    return email.substring(0, 1).toUpperCase();
  }

  Widget _buildQuickActionCard(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFFFF6200).withValues(alpha: 0.1),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: const Color(0xFFFF6200),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFFF6200)),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _auth.signOut();
              if (mounted) {
                setState(() {});
              }
              Get.back();
              Get.snackbar(
                'Logged out',
                'You have been logged out successfully',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About NanaPeth.com'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Version 1.0.0',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              const Text(
                'NanaPeth.com brings Pune\'s premier wholesale market to your doorstep. Shop from 500+ products across 100+ trusted local vendors with same-day delivery.',
              ),
              const SizedBox(height: 16),
              const Text(
                '© 2024 NanaPeth.com. All rights reserved.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
