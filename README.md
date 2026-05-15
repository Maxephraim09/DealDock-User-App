# customer

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.





You are a senior Flutter architect and codebase refactoring expert.

Analyze my entire Flutter project and implement the following requirements in a SAFE, NON-BREAKING, and PRODUCTION-READY way.

⚠️ RULES:

* Do NOT remove existing logic unless necessary
* Do NOT break current navigation or Firebase integration
* Maintain current architecture (GetX / MVC / Provider — detect and follow existing pattern)
* Write clean, modular, reusable code
* Add comments explaining every critical change
* Ensure null safety and error handling
* All changes must compile without errors

---

## ✅ STEP 1: LOCATION SKIP FEATURE (CONTROLLED BYPASS)

CURRENT LOGIC:
Users without saved address are forced to LocationPermissionScreen.

REQUIREMENT:
Allow users to SKIP location setup and proceed to ServiceListScreen.

IMPLEMENTATION DETAILS:

1. Add persistent flag:
   key: "skip_location"
   storage: SharedPreferences (or existing local storage system)

2. Update SplashController / Initial Navigation Logic:
   IF (user has address OR skip_location == true)
   → navigate to ServiceListScreen
   ELSE
   → navigate to LocationPermissionScreen

3. Modify LocationPermissionScreen UI:
   Add a visible "Skip for now" button

4. On Skip क्लिक:

   * Save skip_location = true
   * Navigate to ServiceListScreen

5. Add SERVICE GUARD:
   Before any service action (Food, Cab, Parcel, etc):
   IF user has NO address:
   → Redirect to LocationPermissionScreen

⚠️ Do NOT remove address validation entirely. Only bypass entry.

---

## ✅ STEP 2: SUCCESS FEEDBACK (LOGIN & SIGNUP)

REQUIREMENT:
Show a clean success message after:

* Login
* Account creation

IMPLEMENT:

1. After successful login:
   Show Snackbar/Toast:
   "Login successful"

2. After successful signup:
   Show Snackbar/Toast:
   "Account created successfully"

3. Delay navigation by ~800ms to allow message visibility

4. Ensure:

   * No duplicate navigation triggers
   * No UI blocking
   * Proper error handling remains intact

---

## ✅ STEP 3: GLOBAL BRAND COLOR SYSTEM

APPLY THESE COLORS EVERYWHERE:

static const Color brandPrimaryBlue = Color(0xFF30588C);
static const Color brandDeepBlue = Color(0xFF2E608C);
static const Color brandMutedSteelBlue = Color(0xFF3D5A73);

TASKS:

1. Create centralized theme file:
   e.g. AppColors.dart or theme.dart

2. Replace ALL hardcoded colors across:

   * AppBars
   * Buttons
   * Text styles
   * Cards
   * Bottom navigation

3. Ensure consistency:

   * Primary actions → brandPrimaryBlue
   * Headers/navigation → brandDeepBlue
   * Secondary text/icons → brandMutedSteelBlue

---

## ✅ STEP 4: SERVICE LIST SCREEN (MAIN DASHBOARD UI)

GOAL:
Redesign ServiceListScreen to match a modern fintech dashboard style similar to Opay.

STRUCTURE:

1. HEADER SECTION:

   * Greeting (Hi, User)
   * Wallet balance (optional placeholder)
   * Notification icon

2. QUICK ACTION GRID:

   * Food
   * E-commerce
   * Cab
   * Parcel
   * Rental
   * On-Demand

   Use:

   * Rounded cards
   * Icons
   * Soft shadows
   * Grid layout (2 or 3 columns)

3. PROMO / BANNER SECTION:

   * Horizontal scroll cards

4. RECENT ACTIVITY SECTION:

   * Orders / bookings preview

5. BOTTOM NAVIGATION:

   * Home
   * Orders
   * Wallet
   * Profile

6. UI STYLE:

   * Clean spacing
   * Soft elevation
   * Consistent padding (16px standard)
   * Rounded corners (12–20 radius)

7. Use ONLY brand colors

---

## ✅ STEP 5: CODE QUALITY CHECK

* Remove redundant navigation calls
* Ensure no memory leaks
* Ensure controllers are properly disposed (if applicable)
* Validate Firebase calls are safe
* Ensure app runs without runtime exceptions

---

## OUTPUT FORMAT:

1. Show all modified files
2. Explain each change briefly
3. Highlight any assumptions made
4. Ensure code is ready to run immediately

---

Start with STEP 1 only.
Do NOT jump ahead.

Wait for confirmation before continuing to next step.




















Based on my comprehensive codebase analysis, here are all the services provided by this fintech/multi-service app:

🎯 Core Services (6 Main Categories)
1. 🚕 Cab Service
Cab booking & ride sharing
Live tracking
Driver reviews & ratings
Coupon codes
Order history
Booking confirmation
2. 🍔 Food Delivery & Dine-in
Restaurant browsing
Food ordering & delivery
Dine-in restaurant booking
Category-based filtering
Discount tracking
Order details & history
3. 📦 Parcel Delivery Service
Parcel booking & tracking
Weight-based pricing
Parcel categories
Coupon codes for delivery
Order confirmation
Delivery history
4. 🚗 Vehicle Rental
Vehicle rental booking
Rental package selection
Vehicle type options
Rental order confirmation
Booking history & reviews
5. 🛒 E-Commerce & Shopping
Product browsing by category & brand
Shopping cart management
Favorites/Wishlist
Product ratings & reviews
Order placement & tracking
6. 🛍️ On-Demand Services
General on-demand service bookings
Service categories
Booking details & history
Review & rating system
💳 Financial & Wallet Services
Wallet Management - Top-up & balance checking
Cashback System - Earn & redeem cashback rewards
Gift Cards - Purchase, gifting, & redemption
Referral Program - Earn rewards for referrals
Transaction History - View wallet transactions
Multiple Payment Methods:
Stripe
Razorpay
PayPal
Midtrans
MercadoPago
PayFast
PayStack
Xendit
Orange Money
FlutterWave
👤 User Account & Profile Services
User Authentication - Login, sign-up, OTP verification
Profile Management - Edit user information
Address Management - Multiple address storage
Language Selection - Multi-language support
Theme Customization - Dark/Light mode toggle
Preferences Settings - Notifications, language, theme
📱 Communication & Engagement
Chat Service - Real-time messaging
Push Notifications - Order updates & promotions
Complaint Management - Report issues
Live Tracking - Real-time order/ride tracking
Reviews & Ratings - Rate services & providers
Search Functionality - Find services/products/addresses
📊 Shopping & Discount Features
Coupon Codes - Apply discounts across services
Promotional Banners - Latest offers & deals
Favorites/Wishlist - Save preferred items
Categories & Filters - Browse by category
Special Discounts - Time-limited offers
Advertisements - Promotions & marketing
🗺️ Location & Navigation Services
Address Search - OSM-based place search
Manual Location Entry - Custom address input
Zone Management - Service availability by location
Map Integration - View locations on map
Location Enabling - Geolocation services
📦 Additional Features
Multi-Vendor Support - Browse multiple vendors
Tax Calculation - Automatic tax computation
Currency Support - Multiple currency handling
Subscription Plans - Recurring service options
Email Notifications - Transactional emails
Working Hours - Vendor availability tracking
QR Code Scanning - Quick checkout/booking
🏗️ Admin & Business Features
Commission Management - Track admin commissions
Vendor Management - Multiple vendor support
Worker Management - Service provider handling
Category Management - Dynamic categories
Settings Configuration - Global app settings
This is a comprehensive multi-service super-app (similar to Opay/Uber Eats) supporting cab rides, food delivery, parcel shipping, vehicle rentals, e-commerce, and on-demand services—all with integrated wallet, payments, loyalty programs, and real-time tracking.



// build apk
flutter clean
flutter pub get
flutter build apk --release





Alias name: my-key-alias
Creation date: Apr 24, 2026
Entry type: PrivateKeyEntry
Certificate chain length: 1
Certificate[1]:
Owner: CN=Maxwell Ephraim Halilu, OU=MGTechs, O=MGTechs, L=Yola, ST=Adamawa, C=NG
Issuer: CN=Maxwell Ephraim Halilu, OU=MGTechs, O=MGTechs, L=Yola, ST=Adamawa, C=NG
Serial number: f9e3c87824f463aa
Valid from: Fri Apr 24 13:34:58 PDT 2026 until: Tue Sep 09 13:34:58 PDT 2053
Certificate fingerprints:
         SHA1: 32:C6:4D:21:9E:6D:13:CA:60:D9:48:DD:37:79:1F:4B:03:B6:72:CD
         SHA256: FF:D7:67:CC:96:C6:47:36:06:43:F7:38:03:23:85:A2:DA:6A:83:BC:2D:9A:3E:C9:1A:92:D4:1C:41:87:8D:24
Signature algorithm name: SHA384withRSA
Subject Public Key Algorithm: 2048-bit RSA key
Version: 3
