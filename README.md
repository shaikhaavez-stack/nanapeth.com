# NanaPeth.com - Flutter Marketplace App

Nana Peth at Your Doorstep – Same-Day Delivery! Shop from 500+ products across 100+ trusted local vendors from Pune's premier wholesale market.

## 🎯 Features

✅ **Orange Theme** (#FF6200) with Material Design 3
✅ **Hero Banner** - "NanaPeth.com - Wholesale to Your Doorstep"
✅ **Features Grid** - Same-Day Delivery, Wholesale Prices, Direct Vendors, Support Local
✅ **20 Nana Peth Products** - Hardware, Automotive, Electrical, Construction, Plumbing, Paint
✅ **Responsive Grid** - 2 columns on mobile, 3 on tablets
✅ **Category Filters** - Filter by Auto Parts, Hardware, Electrical, Construction, Plumbing, Paint & Coating
✅ **GetX Cart Controller** - State management with real-time cart count
✅ **FloatingActionButton** - Shows "CART (0)" and increments on product tap
✅ **Pull-to-Refresh** - Swipe down to refresh products
✅ **Smooth Animations** - Scale animations on FAB tap
✅ **Product Cards** - Image, name, vendor, price (green bold), category badge
✅ **Firebase Auth Integration** - Vendor login/signup (stubbed)
✅ **Vendor Login Screen** - Email/password authentication

## 🚀 Quick Start

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK 3.0+

### Installation

1. Install dependencies:
```bash
flutter pub get
```

2. Run the app on mobile preview:
```bash
flutter run
```

Or run with chrome for web preview:
```bash
flutter run -d chrome
```

### Configure Firebase (Optional)
1. Create Firebase project: https://firebase.google.com
2. Add Android app and download `google-services.json` → `android/app/`
3. Add iOS app and download `GoogleService-Info.plist` → `ios/Runner/`

## 📁 Project Structure

```
lib/
├── main.dart                  # App entry with GetX & Material theme
├── controllers/
│   └── cart_controller.dart   # GetX cart state management
├── models/
│   └── product.dart           # Product data model
└── screens/
    ├── homepage.dart          # Main marketplace (categories, products, FAB)
    └── vendor_login.dart      # Vendor authentication
```

## 🎨 Key Features Breakdown

### 1. **Responsive Product Grid**
- 2 columns on mobile (width < 600)
- 3 columns on tablet (width >= 600)
- Auto-responsive card sizing

### 2. **Category Filtering**
- Horizontal scrollable chips: All | Automotive | Hardware | Electrical | Construction | Plumbing | Paint & Coating
- Real-time product filtering
- Count display: "Popular Products (12 items)"

### 3. **Cart Management**
- GetX controller tracks cart items and count
- FloatingActionButton shows "CART (X)" with real-time updates
- Scale animation on FAB when product added
- Green snackbar confirmation on add
- Total price calculation

### 4. **Pull-to-Refresh**
- Swipe down to refresh products
- 800ms fake delay to simulate network
- Smooth RefreshIndicator with orange color

### 5. **Product Cards**
- Cached network images with placeholders
- Product name (2 lines max)
- Vendor name with "by" prefix
- Price in bold green (₹)
- Category badge with orange background
- Tap to add to cart

## 📦 Dependencies

```yaml
get: ^4.6.6                      # State management & navigation
firebase_core: ^2.24.0           # Firebase initialization
cloud_firestore: ^4.13.0         # Database (ready for integration)
firebase_auth: ^4.15.0           # Authentication (stubbed)
cached_network_image: ^3.3.1     # Efficient image caching
intl: ^0.19.0                    # Internationalization
```

## 🎨 Theme Colors

- **Primary Orange**: #FF6200
- **Success Green**: #00C853 (prices)
- **AppBar**: Orange with white text
- **FAB**: Orange with white icon/text
- **Chips**: Selected orange, unselected gray

## ✨ Animation Effects

- FAB scale animation (1.0 → 1.1 → 1.0) on product tap
- Smooth FilterChip transitions
- RefreshIndicator spinner
- Snackbar slide-in animations

## 📱 Testing

### Mobile Preview
```bash
flutter run
# Swipe down to refresh
# Tap category chips to filter
# Tap any product to add to cart
# Tap FAB to see cart total
```

### Web Preview
```bash
flutter run -d chrome
# Full responsive testing
# Test tablet view (1200px width)
```

### Tablet Layout
The app automatically switches to 3-column grid on devices with width >= 600px.

## 🔄 Next Steps

1. **Backend Integration**
   - Connect Firestore for real products
   - Implement real-time product updates
   - Add Firebase Auth validation

2. **Enhanced Features**
   - Product detail page with full description
   - Shopping cart page with quantity adjustment
   - Checkout flow with address & payment
   - Order history and tracking

3. **Performance**
   - Pagination/infinite scroll for products
   - Offline support with local caching
   - Analytics tracking

4. **Deployment**
   - Build APK: `flutter build apk --release`
   - Build iOS: `flutter build ios --release`
   - Submit to Play Store & App Store

## 📝 License

Proprietary to NanaPeth.com
