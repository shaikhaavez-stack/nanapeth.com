import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/cart_controller.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text('My Cart (${controller.cartItems.length})'),
          centerTitle: true,
        ),
        body: controller.cartItems.isEmpty
            ? _buildEmptyCart(context)
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.cartItems.length,
                      itemBuilder: (context, index) {
                        final cartItem = controller.cartItems[index];
                        return _buildCartItem(context, controller, index, cartItem);
                      },
                    ),
                  ),
                  _buildCheckoutSection(context, controller),
                ],
              ),
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Browse 500+ Nana Peth products!',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6200),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('Continue Shopping', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(context, CartController controller, int index, cartItem) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              color: Colors.grey[300],
              child: const Icon(Icons.image),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'by ${cartItem.product.vendor}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹${cartItem.product.price} x ${cartItem.quantity} = ₹${cartItem.subtotal.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00C853),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      iconSize: 18,
                      onPressed: () => controller.updateQuantity(
                        index,
                        cartItem.quantity - 1,
                      ),
                    ),
                    Text(cartItem.quantity.toString()),
                    IconButton(
                      icon: const Icon(Icons.add),
                      iconSize: 18,
                      onPressed: () => controller.updateQuantity(
                        index,
                        cartItem.quantity + 1,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  iconSize: 18,
                  onPressed: () => controller.removeItem(index),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutSection(BuildContext context, CartController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Subtotal:'),
              Text('₹${controller.totalPrice.toStringAsFixed(0)}'),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Delivery:'),
              Text('FREE (Pune Same-Day)', style: TextStyle(color: Color(0xFF00C853))),
            ],
          ),
          const Divider(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TOTAL:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                '₹${controller.totalPrice.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF00C853),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6200), Color(0xFFFF8C42)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ElevatedButton(
              onPressed: () => _placeOrder(context, controller),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Place Order',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _placeOrder(BuildContext context, CartController controller) {
    final orderNum = DateTime.now().millisecondsSinceEpoch.toString().substring(7);
    final itemsList = controller.cartItems
        .map((item) => '${item.product.name} (Qty: ${item.quantity})')
        .join('\n');
    
    final whatsappText = Uri.encodeComponent(
      'New nanapeth.com order #$orderNum\n\n$itemsList\n\nTotal: ₹${controller.totalPrice.toStringAsFixed(0)}\n\nDelivery: Pune Same-Day'
    );

    Get.dialog(
      AlertDialog(
        title: const Text('Order Placed! 🎉'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Order #$orderNum'),
            const SizedBox(height: 16),
            const Text('Delivery in 2 hours! 📦'),
            const SizedBox(height: 16),
            Text('Total: ₹${controller.totalPrice.toStringAsFixed(0)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.clearCart();
              Get.back();
              Get.back();
            },
            child: const Text('Continue Shopping'),
          ),
          ElevatedButton(
            onPressed: () => _openWhatsApp(whatsappText),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF25D366)),
            child: const Text('WhatsApp', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _openWhatsApp(String text) {
    final url = 'https://wa.me/919876543210?text=${Uri.encodeComponent(text)}';
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}
