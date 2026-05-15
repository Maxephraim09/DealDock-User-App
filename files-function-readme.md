# Codebase Structure and Functions Summary

## Project Overview
**Project Name:** Customer  
**Framework:** Flutter (Dart)  
**Type:** Multi-service marketplace mobile application  
**Services:** E-commerce, Food delivery/Dining, Cab booking, Parcel delivery, Rental services, On-demand services

---

## 📁 Root Level Files

### Configuration & Setup Files
| File | Function |
|------|----------|
| `pubspec.yaml` | Flutter project configuration file containing all package dependencies, project metadata, and asset declarations. Includes Firebase, payment gateways, maps, and UI libraries. |
| `firebase.json` | Firebase configuration for Firebase services integration (Firestore, Authentication, Storage, Messaging). |
| `analysis_options.yaml` | Dart linter and analyzer configuration for code quality checks. |
| `devtools_options.yaml` | DevTools configuration for debugging settings. |
| `BRAND_COLOR_CODE_REFERENCE.md` | Documentation of brand color codes used throughout the application. |
| `BRAND_COLOR_UPDATE_SUMMARY.md` | Summary of color scheme updates and changes. |
| `COMPLETION_REPORT.md` | Project completion status and milestone tracking. |
| `generate_app_icons.py` | Python script to automatically generate app icons for different sizes and platforms. |

---

## 📂 Folder Structure and Functions

### **lib/** - Main Application Source Code

#### **lib/main.dart**
- **Function:** Application entry point
- **Responsibilities:**
  - Initializes Flutter and Firebase
  - Sets up theme management (light/dark mode)
  - Initializes SharedPreferences for local storage
  - Configures GetX state management
  - Sets up localization (multi-language support)
  - Configures EasyLoading for loading dialogs
  - Starts the app with splash screen

---

### **lib/constant/**
Directory containing application constants and configuration values.

| File | Function |
|------|----------|
| `constant.dart` | Global constants including API endpoints, timeout values, string constants, and configuration parameters used throughout the app. |
| `collection_name.dart` | Firebase Firestore collection names centralized in one location for consistency. |
| `assets.dart` | Path constants for all asset files (images, icons, fonts) used in the app. |

---

### **lib/models/**
Data models representing the structure of objects used in the application.

#### **Authentication & User**
- `user_model.dart` - User profile data structure
- `worker_model.dart` - Service provider/worker information

#### **E-commerce Models**
- `product_model.dart` - Product information (name, price, images, description)
- `brands_model.dart` - Brand information and branding details
- `category_model.dart` - Product categories and subcategories
- `attributes_model.dart` - Product attributes (size, color, etc.)
- `variant_info.dart` - Product variants and options
- `cart_product_model.dart` - Shopping cart item structure

#### **Food Service Models**
- `restaurant_details_controller.dart` - Restaurant information structure (in models context)
- `dine_in_booking_model.dart` - Dining reservation booking details
- `category_restaurant_controller.dart` - Restaurant category structure

#### **Cab/Ride Service Models**
- `cab_order_model.dart` - Cab ride booking details
- `vehicle_type.dart` - Available vehicle types (economy, premium, etc.)
- `rental_order_model.dart` - Car rental booking information
- `rental_package_model.dart` - Rental package and pricing
- `rental_vehicle_type.dart` - Types of rental vehicles

#### **Parcel/Delivery Models**
- `parcel_order_model.dart` - Parcel delivery order details
- `parcel_category.dart` - Parcel delivery categories
- `parcel_weight_model.dart` - Weight-based pricing for parcels

#### **On-Demand Services Models**
- `provider_serivce_model.dart` - Service provider and service information
- `favorite_ondemand_service_model.dart` - Favorited on-demand services

#### **Commerce & Transactions**
- `order_model.dart` - General order structure for all services
- `cart_product_model.dart` - Shopping cart items
- `coupon_model.dart` - Discount coupon information
- `special_discount_model.dart` - Special discount offers
- `cashback_model.dart` - Cashback reward structure
- `cashback_redeem_model.dart` - Cashback redemption history
- `gift_cards_model.dart` - Gift card information
- `gift_cards_order_model.dart` - Gift card purchase orders
- `wallet_transaction_model.dart` - User wallet transactions

#### **Payment & Tax**
- `payment_model/` - Payment-related models (Stripe, Razorpay, etc.)
- `tax_model.dart` - Tax calculation and information
- `currency_model.dart` - Multi-currency support

#### **Location & Zones**
- `zone_model.dart` - Delivery/service zones
- `popular_destination.dart` - Popular destinations for quick booking

#### **Content & Communication**
- `banner_model.dart` - Promotional banners
- `advertisement_model.dart` - Advertisement data
- `story_model.dart` - Stories/carousel content
- `notification_model.dart` - Push notification data
- `conversation_model.dart` - Chat/messaging conversation
- `inbox_model.dart` - User inbox messages
- `email_template_model.dart` - Email notification templates

#### **Metadata & Settings**
- `vendor_model.dart` - Vendor/merchant information
- `vendor_category_model.dart` - Vendor categories
- `section_model.dart` - UI sections and layout
- `admin_commission_model.dart` - Commission calculation
- `language_model.dart` - Multi-language support
- `mail_setting.dart` - Email configuration
- `subscription_plan_model.dart` - Subscription plans
- `working_hours_model.dart` - Business working hours
- `review_attribute_model.dart` - Review rating attributes
- `rating_model.dart` - User ratings
- `referral_model.dart` - Referral program data
- `on_boarding_model.dart` - Onboarding screens data

---

### **lib/controllers/**
State management controllers using GetX framework. Each controller manages business logic and state for specific features.

#### **Authentication Controllers**
- `login_controller.dart` - Email/password login logic
- `mobile_login_controller.dart` - Phone number login logic
- `otp_verification_controller.dart` - OTP verification process
- `forgot_password_controller.dart` - Password recovery flow
- `sign_up_controller.dart` - User registration logic
- `edit_profile_controller.dart` - User profile editing
- `my_profile_controller.dart` - User profile viewing

#### **Dashboard & Navigation**
- `dash_board_controller.dart` - Main dashboard logic
- `dash_board_ecommarce_controller.dart` - E-commerce dashboard
- `on_boarding_controller.dart` - Onboarding flow
- `global_setting_controller.dart` - Global app settings and routing
- `theme_controller.dart` - Dark/light mode switching
- `change_language_controller.dart` - Multi-language switching

#### **E-commerce Controllers**
- `home_e_commerce_controller.dart` - E-commerce home screen
- `all_brand_product_controller.dart` - Brand product filtering
- `all_category_product_controller.dart` - Category product filtering
- `view_all_category_controller.dart` - Display all categories
- `cart_controller.dart` - Shopping cart management
- `order_controller.dart` - Order management
- `order_details_controller.dart` - Order details viewing
- `order_placing_controller.dart` - Order checkout process
- `rate_product_controller.dart` - Product rating and review
- `review_list_controller.dart` - Display product reviews

#### **Food Delivery & Dining Controllers**
- `food_home_controller.dart` - Food ordering home screen
- `restaurant_list_controller.dart` - Restaurant listing
- `restaurant_details_controller.dart` - Restaurant details and menu
- `discount_restaurant_list_controller.dart` - Filter restaurants by discounts
- `category_restaurant_controller.dart` - Restaurant category filtering
- `dine_in_controller.dart` - Dine-in functionality
- `dine_in_restaurant_details_controller.dart` - Dine-in restaurant details
- `dine_in_booking_controller.dart` - Dine-in table booking
- `dine_in_booking_details_controller.dart` - Booking confirmation details

#### **Cab/Ride Service Controllers**
- `cab_home_controller.dart` - Cab booking home screen
- `cab_dashboard_controller.dart` - Cab service dashboard
- `cab_booking_controller.dart` - Cab ride booking logic
- `my_cab_booking_controller.dart` - User's cab bookings history
- `cab_order_details_controller.dart` - Cab ride details
- `cab_review_controller.dart` - Rate cab ride experience
- `cab_coupon_code_controller.dart` - Cab ride coupon application
- `live_tracking_controller.dart` - Real-time ride tracking
- `map_view_controller.dart` - Map viewing and navigation

#### **Rental Service Controllers**
- `rental_home_controller.dart` - Car rental home screen
- `cab_rental_dashboard_controllers.dart` - Rental service dashboard
- `rental_conformation_controller.dart` - Rental booking confirmation
- `rental_coupon_controller.dart` - Rental discount coupons
- `rental_order_details_controller.dart` - Rental booking details
- `rental_review_controller.dart` - Rate rental experience

#### **Parcel/Delivery Controllers**
- `parcel_dashboard_controller.dart` - Parcel service dashboard
- `parcel_my_booking_controller.dart` - User's parcel bookings
- `book_parcel_controller.dart` - Book parcel delivery
- `parcel_coupon_controller.dart` - Parcel delivery coupons
- `parcel_order_confirmation_controller.dart` - Delivery confirmation
- `parcel_order_details_controller.dart` - Parcel tracking details
- `parcel_review_controller.dart` - Rate delivery service

#### **On-Demand Service Controllers**
- `on_demand_home_controller.dart` - On-demand services home
- `on_demand_dashboard_controller.dart` - On-demand dashboard
- `on_demand_category_controller.dart` - Service category filtering
- `on_demand_booking_controller.dart` - Service booking
- `on_demand_details_controller.dart` - Service details viewing
- `my_booking_on_demand_controller.dart` - User's service bookings
- `on_demand_order_details_controller.dart` - Booking details
- `on_demand_review_controller.dart` - Service rating
- `0n_demand_payment_controller.dart` - On-demand service payment
- `view_all_popular_service_controller.dart` - Popular services display
- `view_category_service_controller.dart` - Category service viewing
- `service_list_controller.dart` - Service provider listing

#### **Location & Search**
- `osm_search_place_controller.dart` - OpenStreetMap place search
- `enter_manually_location_controller.dart` - Manual location entry
- `Intercity_home_controller.dart` - Inter-city service home

#### **User Engagement Controllers**
- `address_list_controller.dart` - Saved addresses management
- `favourite_controller.dart` - Favorite products/restaurants
- `favourite_ondemmand_controller.dart` - Favorite on-demand services
- `splash_controller.dart` - App startup/splash screen
- `search_controller.dart` - Global search functionality
- `provider_controller.dart` - Service provider management
- `chat_controller.dart` - Chat/messaging functionality
- `complain_controller.dart` - Complaint/issue reporting

#### **Loyalty & Rewards**
- `cashback_controller.dart` - Cashback rewards management
- `gift_card_controller.dart` - Gift card purchasing
- `history_gift_card_controller.dart` - Gift card usage history
- `redeem_gift_card_controller.dart` - Redeem gift cards
- `refer_friend_controller.dart` - Referral program
- `wallet_controller.dart` - Digital wallet management
- `advertisement_list_controller.dart` - Advertisement viewing

#### **Scanning & QR**
- `scan_qr_code_controller.dart` - QR code scanning functionality

---

### **lib/screen_ui/**
User interface screens organized by service type.

#### **auth_screens/**
- Login, signup, OTP verification, password recovery, and profile screens

#### **service_home_screen/**
- Main dashboard and service selection screens

#### **ecommarce/**
- Product listing, product details, shopping cart, checkout, order history, and product reviews

#### **food_service/** (implied in structure)
- Restaurant listing, menu browsing, food ordering, cart, checkout

#### **cab_service_screens/**
- Cab home, booking, live tracking, booking history, ratings

#### **rental_service/**
- Vehicle selection, rental booking, confirmation, tracking

#### **parcel_service/**
- Parcel booking, tracking, confirmation, history

#### **on_demand_service/**
- Service browsing, booking, tracking, ratings

#### **location_enable_screens/**
- Location permission requests and maps

#### **on_boarding_screen/**
- Initial app onboarding experience

#### **splash_screen/**
- App startup splash screen

#### **maintenance_mode_screen/**
- Server maintenance notification screen

#### **multi_vendor_service/**
- Multi-vendor marketplace features

---

### **lib/service/**
Core business logic and backend services.

| File | Function |
|------|----------|
| `fire_store_utils.dart` | Firestore database operations, CRUD functions for all collections, queries, and data synchronization. |
| `localization_service.dart` | Multi-language support implementation. Contains translations and locale management. |
| `notification_service.dart` | Push notification handling and local notification setup. |
| `send_notification.dart` | Logic to send notifications to users. |
| `cart_provider.dart` | Shopping cart state management (Provider pattern). |
| `database_helper.dart` | Local SQLite database operations for offline functionality. |

---

### **lib/themes/**
Application theming and UI styling.

| File | Function |
|------|----------|
| `app_them_data.dart` | Centralized theme data including colors, typography, spacing, and dark/light mode configurations. |
| `easy_loading_config.dart` | Configuration for loading dialogs and progress indicators. |
| `responsive.dart` | Responsive design utilities for different screen sizes. |
| `styles.dart` | Reusable text styles, button styles, and component styling. |
| `custom_dialog_box.dart` | Custom dialog components and modal styling. |
| `show_toast_dialog.dart` | Toast notification UI and display logic. |
| `text_field_widget.dart` | Reusable text input field component with validation. |
| `round_button_border.dart` | Outlined button component styling. |
| `round_button_fill.dart` | Filled button component styling. |

---

### **lib/utils/**
Utility functions and helpers.

| File | Function |
|------|----------|
| `preferences.dart` | SharedPreferences wrapper for local data persistence (tokens, user info, settings). |
| `utils.dart` | General utility functions (formatting, validation, calculations, date/time handling). |
| `network_image_widget.dart` | Cached network image widget with error handling and loading states. |
| `notification_service.dart` | Notification permissions and setup utilities. |

---

### **lib/widget/**
Reusable custom widgets and components.

#### **Custom Widgets**
- `video_widget.dart` - Video player component
- `gradiant_text.dart` - Text with gradient effect
- `my_separator.dart` - Divider/separator component
- `permission_dialog.dart` - Permission request dialog
- `restaurant_image_view.dart` - Image gallery for restaurants

#### **Advanced Components**
- `firebase_pagination/` - Pagination logic for Firestore queries
- `geoflutterfire/` - Geolocation and map utilities
- `osm_map/` - OpenStreetMap integration component
- `place_picker/` - Location/place selection widget
- `story_view/` - Story/carousel display component

---

### **lib/payment/**
Payment gateway integration modules.

| File | Function |
|------|----------|
| `createRazorPayOrderModel.dart` | Razorpay payment order creation |
| `getPaytmTxtToken.dart` | Paytm payment token retrieval |
| `MercadoPagoScreen.dart` | Mercado Pago integration UI |
| `midtrans_screen.dart` | Midtrans payment gateway integration |
| `orangePayScreen.dart` | Orange Money payment integration |
| `PayFastScreen.dart` | PayFast payment gateway integration |
| `RazorPayFailedModel.dart` | Razorpay payment failure handling |
| `rozorpayConroller.dart` | Razorpay payment controller and logic |
| `stripe_failed_model.dart` | Stripe payment failure handling |
| `xenditModel.dart` | Xendit payment model |
| `xenditScreen.dart` | Xendit payment UI |
| `paystack/` | PayStack payment gateway integration |

---

### **lib/lang/**
Localization and language support.

| File | Function |
|------|----------|
| `app_en.dart` | English language translations and text strings for entire application |

---

### **android/**
Android-specific configuration and native code.

| File/Folder | Function |
|------|----------|
| `build.gradle.kts` | Android project build configuration |
| `gradle.properties` | Gradle properties and JVM settings |
| `settings.gradle.kts` | Gradle settings and project structure |
| `local.properties` | Local Android SDK path and development settings |
| `key.properties` | App signing key configuration (gitignored) |
| `gradlew / gradlew.bat` | Gradle wrapper scripts for building |
| `app/build.gradle.kts` | App-level build configuration |
| `app/google-services.json` | Firebase configuration for Android |
| `app/src/` | Android source code, resources, and manifests |

---

### **ios/**
iOS-specific configuration and native code.

| File/Folder | Function |
|------|----------|
| `Podfile` | CocoaPods dependencies and iOS configurations |
| `Runner.xcodeproj/` | Xcode project file |
| `Runner.xcworkspace/` | Xcode workspace for development |
| `Runner/` | iOS app source code and resources |
| `RunnerTests/` | iOS unit and integration tests |
| `Flutter/` | Flutter engine and configuration for iOS |

---

### **assets/**
Application assets and resources.

| Folder | Contents |
|--------|----------|
| `fonts/` | Custom font files (.ttf, .otf) for typography |
| `icons/` | App icon files for different sizes and platforms |
| `images/` | Image assets (banners, backgrounds, illustrations) |

---

### **build/**
Generated build artifacts (auto-generated, not for version control).

Contains compiled output, intermediate files, and build cache for:
- Main Android/iOS apps
- Flutter plugins (Firebase, Google Maps, Stripe, etc.)
- Generated code and resources

---

### **test/**
Testing directory.

| File | Function |
|------|----------|
| `widget_test.dart` | Flutter widget and integration test examples |

---

## 🔄 Data Flow Overview

```
User Interface (screen_ui/) 
    ↓
Controllers (GetX State Management)
    ↓
Services (Firebase, Local DB, APIs)
    ↓
Models (Data Structures)
    ↓
Backend (Firebase Firestore/Realtime DB)
```

---

---

## 📱 Complete Screens List & Functions

### **1. AUTHENTICATION SCREENS** (`auth_screens/`)
Navigation: App Entry Point for new/unregistered users

#### **1.1 LoginScreen** - `login_screen.dart`
- **Controller:** `LoginController`
- **Function:** Email/password user authentication
- **Key Features:**
  - Email validation
  - Password visibility toggle
  - Forgot password link
  - Social login (Google, Apple)
  - Error handling
- **Navigation Flow:**
  - ✅ Valid user → **LocationPermissionScreen** (if no address) OR **ServiceListScreen** (with address)
  - ❌ Invalid → Error toast & stay on screen
  - Forgot password → **ForgotPasswordScreen**
  - Sign up → **SignUpScreen**

#### **1.2 SignUpScreen** - `sign_up_screen.dart`
- **Controller:** `SignUpController`
- **Function:** New user account creation
- **Key Features:**
  - First/Last name input
  - Email validation
  - Phone number with country code
  - Password strength validation
  - Confirm password matching
  - Referral code support
  - Profile image upload option
- **Navigation Flow:**
  - ✅ Account created → **LocationPermissionScreen** (if no address) OR **ServiceListScreen** (with address)
  - ❌ Validation error → Show specific error message
  - Email already exists → Error notification

#### **1.3 MobileLoginScreen** - `mobile_login_screen.dart`
- **Controller:** `MobileLoginController`
- **Function:** Phone number-based login alternative
- **Key Features:**
  - Phone number input with country picker
  - Numeric keyboard for number entry
  - Country code selection
- **Navigation Flow:**
  - ✅ Valid phone → **OTPVerificationScreen**
  - ❌ Invalid → Error message

#### **1.4 OTPVerificationScreen** - `otp_verification_screen.dart`
- **Controller:** `OtpVerificationController`
- **Function:** OTP verification for phone-based authentication
- **Key Features:**
  - 6-digit OTP input
  - Resend OTP functionality
  - OTP timer countdown
  - Auto-fill from SMS
- **Navigation Flow:**
  - ✅ Valid OTP → **SignUpScreen** (new user) OR **ServiceListScreen** (existing)
  - ❌ Invalid OTP → Error & request resend
  - Resend → Send new OTP

#### **1.5 ForgotPasswordScreen** - `forgot_password_screen.dart`
- **Controller:** `ForgotPasswordController`
- **Function:** Password reset functionality
- **Key Features:**
  - Email input
  - Reset link generation
  - New password creation
  - Password confirmation
- **Navigation Flow:**
  - ✅ Password reset → **LoginScreen**
  - ❌ Error → Show error message

---

### **2. ONBOARDING & SPLASH** (`on_boarding_screen/`, `splash_screen/`)

#### **2.1 SplashScreen** - `splash_screen.dart`
- **Controller:** `SplashController`
- **Function:** App startup screen & authentication check
- **Display Duration:** 3 seconds
- **Key Logic:**
  - Check maintenance mode status
  - Verify onboarding completion
  - Authenticate user status
  - Check user role & active status
  - Verify saved addresses
- **Navigation Flow:**
  - Maintenance active → **MaintenanceModeScreen**
  - Onboarding not completed → **OnboardingScreen**
  - User not logged in → **LoginScreen**
  - User logged in + no address → **LocationPermissionScreen**
  - User logged in + with address → **ServiceListScreen**
  - User disabled → Logout & **LoginScreen**

#### **2.2 OnboardingScreen** - `on_boarding_screen.dart`
- **Controller:** `OnBoardingController`
- **Function:** First-time user onboarding tutorial
- **Key Features:**
  - Multi-page tutorial slides
  - App features overview
  - Benefits explanation
  - Skip option
  - Completion flag
- **Navigation Flow:**
  - Complete onboarding → Check login status → **LoginScreen** OR **ServiceListScreen**
  - Skip → **LoginScreen**

#### **2.3 MaintenanceModeScreen** - `maintenance_mode_screen.dart`
- **Controller:** N/A
- **Function:** Display server maintenance status
- **Key Features:**
  - Maintenance message
  - Estimated downtime
  - Refresh button
  - Support contact info
- **Navigation Flow:**
  - Maintenance over → Refresh & proceed to appropriate screen

---

### **3. LOCATION SCREENS** (`location_enable_screens/`)

#### **3.1 LocationPermissionScreen** - `location_permission_screen.dart`
- **Controller:** `LocationPermissionController`
- **Function:** Request device location permissions & set delivery address
- **Key Features:**
  - Permission request dialog
  - Current location detection
  - Map view integration
  - Manual address entry
  - Address list if multiple addresses exist
- **Navigation Flow:**
  - ✅ Address selected → **ServiceListScreen**
  - Skip manual → **AddressListScreen** (if addresses exist)
  - Add address → **EnterManuallyLocation**

#### **3.2 AddressListScreen** - `address_list_screen.dart`
- **Controller:** `AddressListController`
- **Function:** Manage saved delivery addresses
- **Key Features:**
  - Display all saved addresses
  - Add new address
  - Delete address
  - Set default address
  - Address type (Home, Work, etc.)
- **Navigation Flow:**
  - Select address → **ServiceListScreen**
  - Add new → **EnterManuallyLocation**
  - Back → **ServiceListScreen**

#### **3.3 EnterManuallyLocation** - `enter_manually_location.dart`
- **Controller:** `EnterManuallyLocationController`
- **Function:** Manual address entry with map picker
- **Key Features:**
  - Google Maps/OSM map display
  - Drag marker to set location
  - Search place functionality
  - Address autocomplete
  - Save address with name
- **Navigation Flow:**
  - ✅ Save address → **AddressListScreen** OR **ServiceListScreen**
  - Cancel → Back to previous screen

---

### **4. SERVICE SELECTION** (`service_home_screen/`)

#### **4.1 ServiceListScreen** - `service_list_screen.dart`
- **Controller:** `ServiceListController`
- **Function:** Main marketplace hub - select service type
- **Display Elements:**
  - Service banners/promotions
  - 6 main service categories (grid layout):
    1. E-commerce (Shopping)
    2. Food Delivery
    3. Cab/Rides
    4. Parcel Delivery
    5. Car Rental
    6. On-Demand Services
  - Bottom navigation bar
  - User profile access
- **Navigation Flow:**
  - E-commerce → **FoodHomeScreen** (Multi-vendor home)
  - Food Delivery → **HomeScreen** (Food home)
  - Cab → **CabHomeScreen**
  - Parcel → **HomeParcelScreen**
  - Rental → **RentalHomeScreen**
  - On-Demand → **OnDemandHomeScreen**
  - Profile icon → **ProfileScreen**
  - Cart icon → **CartScreen**

---

### **5. E-COMMERCE SCREENS** (`ecommarce/`)

#### **5.1 HomeECommerceScreen** - `home_e_commerce_screen.dart`
- **Controller:** `HomeECommerceController`
- **Function:** E-commerce home - product discovery
- **Key Features:**
  - Featured product banners
  - Category grid
  - Popular products
  - Search bar
  - Filter options
  - Wishlist toggle
- **Navigation Flow:**
  - Product tap → **ProductDetailsScreen** (handled in multi-vendor)
  - Category → **AllCategoryProductScreen**
  - Brand → **AllBrandProductScreen**
  - Search → **SearchScreen**

#### **5.2 AllCategoryProductScreen** - `all_category_product_screen.dart`
- **Controller:** `AllCategoryProductController`
- **Function:** Filter products by category
- **Key Features:**
  - Category list sidebar
  - Product grid with pagination
  - Sort options (price, rating, newest)
  - Price filters
  - Wishlist management
- **Navigation Flow:**
  - Select product → **ProductDetailsScreen**
  - Back → **HomeECommerceScreen**
  - Apply filters → Update product list

#### **5.3 AllBrandProductScreen** - `all_brand_product_screen.dart`
- **Controller:** `AllBrandProductController`
- **Function:** Filter products by brand
- **Key Features:**
  - Brand list display
  - Product grid by selected brand
  - Sort & filter options
- **Navigation Flow:**
  - Select product → **ProductDetailsScreen**
  - Select brand → Filter products
  - Back → **HomeECommerceScreen**

#### **5.4 DashboardECommerceScreen** - `dash_board_e_commerce_screen.dart`
- **Controller:** `DashboardECommerceController`
- **Function:** E-commerce dashboard/tab interface
- **Key Features:**
  - Tab navigation
  - Different product categories per tab
  - Wishlist access
  - Recent searches
- **Navigation Flow:**
  - Product → **ProductDetailsScreen**
  - Category tab → **AllCategoryProductScreen**
  - Wishlist → **FavouriteScreen**

---

### **6. FOOD & MULTI-VENDOR SCREENS** (`multi_vendor_service/`)

#### **6.1 HomeScreen** - `home_screen.dart`
- **Controller:** `FoodHomeController`
- **Function:** Main food delivery home screen
- **Display Elements:**
  - Location header with change address option
  - Search bar with filters
  - Promotional banners
  - Stories carousel
  - Category carousel
  - Restaurant carousel (popular)
  - Special discounts
  - Advertisements
- **Navigation Flow:**
  - Change address → **AddressListScreen**
  - Search → **SearchScreen**
  - Category → **CategoryRestaurantScreen**
  - Restaurant → **RestaurantDetailsScreen**
  - Special discount → **DiscountRestaurantListScreen**
  - All categories → **ViewAllCategoryScreen**
  - Advertisement → **AllAdvertisementScreen**
  - Cart icon → **CartScreen**
  - View all (restaurants) → **RestaurantListScreen**

#### **6.2 HomeScreenTwo** - `home_screen_two.dart`
- **Controller:** `FoodHomeController`
- **Function:** Alternative home screen layout variant
- **Key Features:**
  - Similar to HomeScreen but different UI arrangement
  - Optimized for different screen sizes
- **Navigation Flow:** Same as HomeScreen

#### **6.3 RestaurantListScreen** - `restaurant_list_screen.dart`
- **Controller:** `RestaurantListController`
- **Function:** Display all restaurants with filtering
- **Key Features:**
  - Restaurant grid/list view
  - Sort (rating, delivery time, price)
  - Filter (distance, cuisine type, offers)
  - Restaurant rating display
  - Delivery time & charges
  - Loyalty badges
- **Navigation Flow:**
  - Restaurant tap → **RestaurantDetailsScreen**
  - Filter → Update list
  - Search → **SearchScreen**
  - Back → **HomeScreen**

#### **6.4 CategoryRestaurantScreen** - `category_restaurant_screen.dart`
- **Controller:** `CategoryRestaurantController`
- **Function:** Filter restaurants by cuisine category
- **Key Features:**
  - Cuisine categories list
  - Restaurants matching category
  - Rating & reviews display
- **Navigation Flow:**
  - Select restaurant → **RestaurantDetailsScreen**
  - Select category → Filter restaurants
  - Back → **HomeScreen**

#### **6.5 DiscountRestaurantListScreen** - `discount_restaurant_list_screen.dart`
- **Controller:** `DiscountRestaurantListController`
- **Function:** Show restaurants with special discounts
- **Key Features:**
  - Discount percentage display
  - Filtered restaurant list
  - Discount details
- **Navigation Flow:**
  - Restaurant → **RestaurantDetailsScreen**
  - Back → **HomeScreen**

#### **6.6 ViewAllCategoryScreen** - `view_all_category_screen.dart`
- **Controller:** `ViewCategoryRestaurantController`
- **Function:** Display all restaurant categories
- **Key Features:**
  - Grid of all cuisine categories
  - Category images
  - Category name
  - Restaurant count
- **Navigation Flow:**
  - Select category → **CategoryRestaurantScreen**
  - Back → **HomeScreen**

#### **6.7 StoryView** - `story_view.dart`
- **Controller:** `FoodHomeController`
- **Function:** Display stories/temporary promotional content
- **Key Features:**
  - Story progression
  - Image/video stories
  - Story count indicator
  - Tap to advance
- **Navigation Flow:**
  - Story done → Back to home
  - Story tap (action) → Story details or promotion screen

#### **6.8 RestaurantDetailsScreen** - `restaurant_details_screen.dart`
- **Controller:** `RestaurantDetailsController`
- **Function:** Display restaurant info, menu & food items
- **Display Elements:**
  - Restaurant image/hero
  - Restaurant name & rating
  - Delivery info (time, charges)
  - Cuisine types
  - Menu categories
  - Food items grid
  - Wishlist button
  - Floating cart button
- **Key Features:**
  - Menu category tabs
  - Food item customization
  - Add to cart
  - Item reviews
  - Restaurant reviews
  - Loyalty offers
- **Navigation Flow:**
  - Food item → Show details/customization modal
  - Add to cart → Update cart count
  - Reviews → **ReviewListScreen**
  - Cart → **CartScreen**
  - Back → **RestaurantListScreen**
  - Favourite → Toggle wishlist

#### **6.9 CartScreen** - `cart_screen.dart`
- **Controller:** `CartController`
- **Function:** Shopping cart management for food orders
- **Key Features:**
  - Cart items list
  - Item quantity control
  - Remove item
  - Item subtotal calculation
  - Subtotal & taxes
  - Delivery charges
  - Grand total
  - Promo code input
  - Proceed to checkout button
- **Navigation Flow:**
  - Continue shopping → Back to **HomeScreen**
  - Apply coupon → **CouponListScreen**
  - Checkout → **OrderPlacingScreen**
  - Back → **RestaurantDetailsScreen**
  - Modify item → Back to restaurant menu

#### **6.10 CouponListScreen** - `coupon_list_screen.dart`
- **Controller:** `CartController` OR `CouponController`
- **Function:** Select discount coupon for order
- **Key Features:**
  - Available coupons list
  - Discount amount display
  - Coupon validity period
  - Terms & conditions
  - Apply coupon button
  - Discount preview
- **Navigation Flow:**
  - Apply coupon → **CartScreen** (updated with discount)
  - Cancel → Back to **CartScreen**

#### **6.11 OrderPlacingScreen** - `oder_placing_screens.dart`
- **Controller:** `OrderPlacingController`
- **Function:** Order review & payment processing
- **Key Features:**
  - Order summary
  - Delivery address display
  - Change address option
  - Special instructions input
  - Contact number
  - Delivery type (home/pickup)
  - Grand total with breakdown
  - Payment method selection
  - Place order button
- **Navigation Flow:**
  - Change address → **AddressListScreen**
  - Select payment → **SelectPaymentScreen**
  - Place order → Payment processing → **LiveTrackingScreen** OR **OrderDetailsScreen**
  - Back → **CartScreen**

#### **6.12 SelectPaymentScreen** - `select_payment_screen.dart`
- **Controller:** `OrderPlacingController`
- **Function:** Payment method selection & processing
- **Key Features:**
  - Payment options (Card, UPI, Wallet, Cash on Delivery, etc.)
  - Wallet balance display
  - Add new payment method
  - Saved payment methods
  - Security badges
- **Navigation Flow:**
  - Select payment → Process payment
  - ✅ Success → **OrderDetailsScreen** with tracking
  - ❌ Failed → Show error & retry option
  - Back → **OrderPlacingScreen**

#### **6.13 OrderScreen** - `order_screen.dart` (Food Order History)
- **Controller:** `OrderController`
- **Function:** Display user's order history
- **Key Features:**
  - List of all orders
  - Order status (preparing, on the way, delivered)
  - Order date & time
  - Total amount
  - Reorder button
  - Order filter (active, completed, cancelled)
- **Navigation Flow:**
  - Order tap → **OrderDetailsScreen**
  - Reorder → **CartScreen** (pre-filled)
  - Filter → Update list
  - Back → **DashboardScreen**

#### **6.14 OrderDetailsScreen** - `order_details_screen.dart`
- **Controller:** `OrderDetailsController`
- **Function:** Display detailed order information
- **Key Features:**
  - Order items list
  - Item customizations
  - Order status timeline
  - Delivery address
  - Delivery person info (when on delivery)
  - Payment details
  - Contact delivery person
  - Support chat
  - Help button
  - Rate order button
- **Navigation Flow:**
  - Contact → **ChatScreen** with delivery partner
  - Rate → **ReviewScreen**
  - Track live → **LiveTrackingScreen**
  - Back → **OrderScreen**

#### **6.15 LiveTrackingScreen** - `live_tracking_screen.dart`
- **Controller:** `LiveTrackingController`
- **Function:** Real-time order tracking on map
- **Key Features:**
  - Live map with delivery location
  - Delivery person marker
  - Route visualization
  - Order status update
  - Estimated time of arrival (ETA)
  - Contact delivery person button
  - Current location zoom control
  - Order details sidebar
- **Navigation Flow:**
  - Contact → **ChatScreen**
  - Order details → **OrderDetailsScreen**
  - Back → Return to calling screen

#### **6.16 ReviewListScreen** - `review_list_screen.dart`
- **Controller:** `ReviewListController`
- **Function:** Display all reviews for restaurant/item
- **Key Features:**
  - Reviews grid/list
  - Star rating distribution
  - Average rating
  - Filter (high to low, recent, most helpful)
  - Review images
  - Reviewer name & date
  - Helpful vote counter
- **Navigation Flow:**
  - Back → **RestaurantDetailsScreen** OR **ProductDetailsScreen**

#### **6.17 RateProductScreen** - `rate_product_screen.dart`
- **Controller:** `RateProductController`
- **Function:** Rate food item/restaurant after order
- **Key Features:**
  - Star rating (5 stars)
  - Photo upload
  - Comment text area
  - Attribute-based rating (taste, quality, delivery)
  - Submit button
  - Anonymous option
- **Navigation Flow:**
  - Submit → Save review → **OrderDetailsScreen** OR **OrderScreen**
  - Back → **OrderDetailsScreen**

---

### **7. DINE-IN BOOKING SCREENS** (`dine_in_screeen/`, `dine_in_booking/`)

#### **7.1 DineInScreen** - `dine_in_screen.dart`
- **Controller:** `DineInController`
- **Function:** Main dine-in home - table reservation
- **Display Elements:**
  - Location header
  - Search bar
  - Category carousel
  - Featured restaurants
  - Promotional banners
- **Navigation Flow:**
  - Search → **SearchScreen**
  - Category → **ViewAllCategoryDineInScreen**
  - Restaurant → **DineInRestaurantListScreen**
  - All categories → **ViewAllCategoryDineInScreen**
  - Cart → **CartScreen**

#### **7.2 ViewAllCategoryDineInScreen** - `view_all_category_dine_in_screen.dart`
- **Controller:** `DineInController`
- **Function:** Show all dining categories
- **Navigation Flow:**
  - Select category → **DineInRestaurantListScreen** (filtered)
  - Back → **DineInScreen**

#### **7.3 DineInRestaurantListScreen** - `dine_in_restaurant_list_screen.dart`
- **Controller:** `DineInController`
- **Function:** Display restaurants available for dine-in
- **Key Features:**
  - Restaurant list with images
  - Cuisine type
  - Star rating
  - Availability status
  - Special dine-in offers
- **Navigation Flow:**
  - Restaurant → **DineInDetailsScreen**
  - Filter → Update list
  - Back → **DineInScreen**

#### **7.4 DineInDetailsScreen** - `dine_in_details_screen.dart`
- **Controller:** `DineInRestaurantDetailsController`
- **Function:** Restaurant details for dine-in
- **Key Features:**
  - Restaurant info
  - Table availability
  - Menu preview
  - Special offers
  - Address & contact
  - Ambiance images
  - Operating hours
  - Dress code (if any)
- **Navigation Flow:**
  - Book table → **DineInBookingScreen**
  - View menu → **RestaurantDetailsScreen**
  - Back → **DineInRestaurantListScreen**

#### **7.5 DineInBookingScreen** - `dine_in_booking_screen.dart`
- **Controller:** `DineInBookingController`
- **Function:** Table reservation booking
- **Key Features:**
  - Date picker
  - Time picker
  - Party size selector
  - Table preference (balcony, window, etc.)
  - Special requests text area
  - Guest contact info
- **Navigation Flow:**
  - Continue → **DineInBookingDetailsScreen**
  - Back → **DineInDetailsScreen**

#### **7.6 DineInBookingDetailsScreen** - `dine_in_booking_details.dart`
- **Controller:** `DineInBookingDetailsController`
- **Function:** Booking review & confirmation
- **Key Features:**
  - Booking summary
  - Date & time
  - Party size
  - Table details
  - Restaurant info
  - Contact person
  - Cancellation policy
  - Confirm button
- **Navigation Flow:**
  - Confirm → **OrderDetailsScreen** (dine-in variant)
  - Edit → Back to **DineInBookingScreen**
  - Back → **DineInRestaurantListScreen**

#### **7.7 BookTableScreen** - `book_table_screen.dart`
- **Controller:** `DineInBookingController`
- **Function:** Quick table booking (may be alternative to DineInBookingScreen)
- **Navigation Flow:** Similar to dine-in booking flow

---

### **8. CAB/RIDE SERVICE SCREENS** (`cab_service_screens/`)

#### **8.1 CabHomeScreen** - `cab_home_screen.dart`
- **Controller:** `CabHomeController`
- **Function:** Cab booking home screen
- **Display Elements:**
  - Current location (from map)
  - Destination input
  - Ride type selector (Economy, Premium, XL)
  - Estimated fare display
  - Ride history quick access
  - Favorite locations
  - Promotional banners
- **Key Features:**
  - Location input with autocomplete
  - Swap locations button
  - Schedule ride option
  - Ride sharing toggle
- **Navigation Flow:**
  - Set destination → **CabBookingScreen**
  - View history → **MyCabBookingScreen**
  - Favorite location → Auto-fill destination → **CabBookingScreen**
  - Search → **SearchScreen**
  - Cart → **CartScreen**

#### **8.2 CabBookingScreen** - `cab_booking_screen.dart`
- **Controller:** `CabBookingController`
- **Function:** Confirm cab booking & wait for driver
- **Display Elements:**
  - Map with current location
  - Pickup location detail
  - Destination detail
  - Ride type (with price)
  - Driver info card (when matched)
  - ETA countdown
  - Driver location live tracking
  - Contact driver button
  - Floating action buttons (cancel, confirm)
- **Key Features:**
  - Auto matching with available driver
  - Real-time location sharing
  - OTP verification for safety
  - Driver rating
  - Vehicle details (color, license plate)
- **Navigation Flow:**
  - Driver accepted → Update screen with driver info
  - Driver pickup → **LiveTrackingScreen**
  - Contact driver → **ChatScreen**
  - Cancel → Show cancellation fee & confirm
  - ✅ Cancel confirmed → Back to **CabHomeScreen**
  - Ride started → **LiveTrackingScreen**

#### **8.3 CabDashboardScreen** - `cab_dashboard_screen.dart`
- **Controller:** `CabDashboardController`
- **Function:** Cab service dashboard/hub
- **Display Elements:**
  - Active ride status (if any)
  - Quick book buttons
  - Ride history
  - Favorite locations
  - Tab navigation (Home, History, Profile, etc.)
- **Navigation Flow:**
  - Quick book → **CabHomeScreen**
  - View ride → **CabOrderDetailsScreen**
  - Profile → **ProfileScreen**
  - Tab navigation → Respective screens

#### **8.4 MyCabBookingScreen** - `my_cab_booking_screen.dart`
- **Controller:** `MyCabBookingController`
- **Function:** View cab ride history
- **Key Features:**
  - List of all cab rides
  - Ride date, time, distance
  - Fare amount
  - Driver name & rating
  - Filter (upcoming, completed, cancelled)
  - Reorder button
  - Ride status indicators
- **Navigation Flow:**
  - Ride tap → **CabOrderDetailsScreen**
  - Reorder → **CabHomeScreen** (with saved destination)
  - Back → **CabDashboardScreen**

#### **8.5 CabOrderDetailsScreen** - `cab_order_details.dart`
- **Controller:** `CabOrderDetailsController`
- **Function:** Detailed ride information & receipt
- **Key Features:**
  - Ride route on map
  - Pickup & drop location
  - Distance & duration
  - Fare breakdown
  - Driver details (photo, name, rating, vehicle)
  - Payment method & status
  - Receipt download
  - Share trip
- **Navigation Flow:**
  - Contact driver → **ChatScreen**
  - Map view → **LiveTrackingScreen**
  - Rate ride → **CabReviewScreen**
  - Back → **MyCabBookingScreen**

#### **8.6 CabReviewScreen** - `cab_review_screen.dart`
- **Controller:** `CabReviewController`
- **Function:** Rate cab ride experience
- **Key Features:**
  - Star rating (ride quality, driver, cleanliness)
  - Comment box
  - Photo upload
  - Tip option
  - Issue report button
- **Navigation Flow:**
  - Submit → **CabOrderDetailsScreen**
  - Report issue → **ComplainScreen**
  - Back → **CabOrderDetailsScreen**

#### **8.7 CabCouponCodeScreen** - `cab_coupon_code_screen.dart`
- **Controller:** `CabCouponCodeController`
- **Function:** Apply discount coupon for cab ride
- **Key Features:**
  - Available coupons
  - Discount details
  - Coupon code copy
  - Apply button
  - Coupon validity info
- **Navigation Flow:**
  - Apply coupon → **CabHomeScreen** (with discount applied)
  - Back → **CabHomeScreen**

#### **8.8 ComplainScreen** - `complain_screen.dart`
- **Controller:** `ComplainController`
- **Function:** Report ride issues & complaints
- **Key Features:**
  - Issue category selector
  - Description text area
  - Attachment upload (photos/videos)
  - Submit button
  - Support email notification
- **Navigation Flow:**
  - Submit → Show confirmation → Back to calling screen
  - Back → Previous screen

#### **8.9 IntercityHomeScreen** - `Intercity_home_screen.dart`
- **Controller:** `IntercityHomeController`
- **Function:** Inter-city cab booking
- **Key Features:**
  - From/To city selector
  - Date picker
  - Passenger count
  - Car type selection
  - Price estimate
- **Navigation Flow:**
  - Search → Show available cabs → Book → **CabBookingScreen**
  - Back → **CabDashboardScreen**

---

### **9. PARCEL DELIVERY SCREENS** (`parcel_service/`)

#### **9.1 HomeParcelScreen** - `home_parcel_screen.dart`
- **Controller:** `ParcelHomeController`
- **Function:** Parcel delivery home screen
- **Display Elements:**
  - Quick booking buttons
  - Pickup & destination input
  - Parcel category selector
  - Parcel weight selector
  - Cost estimate
  - Recent parcels
  - Promotional banners
  - FAQ section
- **Navigation Flow:**
  - Set details → **BookParcelScreen**
  - View history → **ParcelMyBookingScreen**
  - Track parcel → **ParcelOrderDetailsScreen**

#### **9.2 BookParcelScreen** - `book_parcel_screen.dart`
- **Controller:** `BookParcelController`
- **Function:** Parcel booking form
- **Key Features:**
  - Pickup address selection/entry
  - Destination address selection/entry
  - Parcel category (documents, food, parcels, etc.)
  - Parcel weight/dimensions
  - Parcel description
  - Special handling instructions
  - Estimated cost display
  - Proceed to confirm button
- **Navigation Flow:**
  - Edit address → **EnterManuallyLocation**
  - Proceed → **ParcelOrderConfirmationScreen**
  - Back → **HomeParcelScreen**

#### **9.3 ParcelOrderConfirmationScreen** - `parcel_order_confirmation.dart`
- **Controller:** `ParcelOrderConfirmationController`
- **Function:** Review & confirm parcel delivery booking
- **Key Features:**
  - Order summary
  - Pickup details
  - Destination details
  - Parcel details
  - Cost breakdown
  - Delivery charges
  - Total amount
  - Payment method selection
  - Special requests
- **Navigation Flow:**
  - Confirm order → Process payment → **ParcelOrderDetailsScreen**
  - Edit → Back to **BookParcelScreen**
  - Back → **BookParcelScreen**

#### **9.4 ParcelOrderDetailsScreen** - `parcel_order_details.dart`
- **Controller:** `ParcelOrderDetailsController`
- **Function:** Parcel delivery tracking & details
- **Key Features:**
  - Parcel status timeline (picked up, in transit, out for delivery, delivered)
  - Pickup location
  - Destination location
  - Driver info & live location
  - Current parcel location
  - ETA
  - Contact driver
  - Proof of delivery (photo/signature)
  - Cost breakdown
- **Navigation Flow:**
  - Contact driver → **ChatScreen**
  - Track live → **LiveTrackingScreen**
  - Rate delivery → **ParcelReviewScreen**
  - Back → **ParcelMyBookingScreen**

#### **9.5 ParcelMyBookingScreen** - `my_booking_screen.dart`
- **Controller:** `ParcelMyBookingController`
- **Function:** View parcel delivery history
- **Key Features:**
  - List of all parcel bookings
  - Booking date
  - From-To locations
  - Status indicator
  - Cost
  - Reorder button
  - Filter (active, completed)
- **Navigation Flow:**
  - Booking tap → **ParcelOrderDetailsScreen**
  - Reorder → **BookParcelScreen** (with saved data)
  - Back → **ParcelDashboardScreen**

#### **9.6 ParcelDashboardScreen** - `parcel_dashboard_screen.dart`
- **Controller:** `ParcelDashboardController`
- **Function:** Parcel service dashboard
- **Display Elements:**
  - Active parcel (if any)
  - Quick book button
  - History access
  - Tab navigation
- **Navigation Flow:**
  - Quick book → **BookParcelScreen**
  - View history → **ParcelMyBookingScreen**
  - Tabs → Respective screens

#### **9.7 ParcelCouponScreen** - `parcel_coupon_screen.dart`
- **Controller:** `ParcelCouponController`
- **Function:** Select discount coupon for parcel
- **Navigation Flow:**
  - Apply coupon → **ParcelOrderConfirmationScreen**
  - Back → **ParcelOrderConfirmationScreen**

#### **9.8 ParcelReviewScreen** - `parcel_review_screen.dart`
- **Controller:** `ParcelReviewController`
- **Function:** Rate delivery service
- **Key Features:**
  - Star rating (delivery speed, professionalism, safety)
  - Comment box
  - Photo upload
  - Issue report
- **Navigation Flow:**
  - Submit → **ParcelOrderDetailsScreen**
  - Report issue → **ComplainScreen**

#### **9.9 OrderSuccessfullyPlacedScreen** - `order_successfully_placed.dart`
- **Controller:** N/A
- **Function:** Confirmation screen after successful booking
- **Key Features:**
  - Success message & animation
  - Order number
  - Order summary
  - Continue button
  - Track button
- **Navigation Flow:**
  - Continue → **ParcelDashboardScreen**
  - Track → **ParcelOrderDetailsScreen**

---

### **10. RENTAL SERVICE SCREENS** (`rental_service/`)

#### **10.1 RentalHomeScreen** - `rental_home_screen.dart`
- **Controller:** `RentalHomeController`
- **Function:** Car rental home screen
- **Display Elements:**
  - Pickup location input
  - Pickup date/time
  - Return date/time
  - Vehicle type selector
  - Available cars preview
  - Rental packages
  - Promotional offers
  - FAQ section
- **Navigation Flow:**
  - Search → Show available vehicles → **RentalDashboardScreen**
  - View packages → **RentalDashboardScreen**
  - View offer → **RentalDashboardScreen**

#### **10.2 RentalDashboardScreen** - `rental_dashboard_screen.dart`
- **Controller:** `RentalDashboardController`
- **Function:** View available rental vehicles
- **Key Features:**
  - Vehicle grid/list
  - Vehicle images carousel
  - Price per day
  - Vehicle specs (seats, AC, etc.)
  - Availability status
  - Filter (price, vehicle type)
  - Select vehicle button
- **Navigation Flow:**
  - Select vehicle → **RentalConfirmationScreen**
  - Filter → Update vehicle list
  - Back → **RentalHomeScreen**

#### **10.3 RentalConfirmationScreen** - `rental_conformation_screen.dart`
- **Controller:** `RentalConfirmationController`
- **Function:** Rental booking confirmation
- **Key Features:**
  - Vehicle details & image
  - Pickup location & time
  - Return location & time
  - Rental duration
  - Price breakdown (daily, total)
  - Insurance options
  - Driver details requirement
  - Payment method
  - Confirm booking button
- **Navigation Flow:**
  - Confirm → Payment processing → **RentalOrderDetailsScreen**
  - Edit → Back to **RentalDashboardScreen**
  - Apply coupon → **RentalCouponScreen**
  - Back → **RentalDashboardScreen**

#### **10.4 RentalOrderDetailsScreen** - `rental_order_details_screen.dart`
- **Controller:** `RentalOrderDetailsController`
- **Function:** Rental booking details & tracking
- **Key Features:**
  - Booking status (confirmed, picked up, returned)
  - Vehicle details & location
  - Rental period
  - Cost breakdown
  - Driver contact info
  - Pickup instructions
  - Support contact
- **Navigation Flow:**
  - Contact support → **ChatScreen**
  - Rate experience → **RentalReviewScreen**
  - Back → **MyRentalBookingScreen**

#### **10.5 MyRentalBookingScreen** - `my_rental_booking_screen.dart`
- **Controller:** `MyRentalBookingController`
- **Function:** View rental booking history
- **Key Features:**
  - List of all rental bookings
  - Booking date
  - Vehicle type
  - Rental duration
  - Cost
  - Status
  - Reorder button
- **Navigation Flow:**
  - Booking tap → **RentalOrderDetailsScreen**
  - Reorder → **RentalHomeScreen** (with saved dates)
  - Back → **RentalDashboardScreen**

#### **10.6 RentalCouponScreen** - `rental_coupon_screen.dart`
- **Controller:** `RentalCouponController`
- **Function:** Select rental discount coupon
- **Navigation Flow:**
  - Apply coupon → **RentalConfirmationScreen**
  - Back → **RentalConfirmationScreen**

#### **10.7 RentalReviewScreen** - `rental_review_screen.dart`
- **Controller:** `RentalReviewController`
- **Function:** Rate rental service
- **Key Features:**
  - Star rating (vehicle condition, cleanliness, service)
  - Comment box
  - Photo upload
- **Navigation Flow:**
  - Submit → **RentalOrderDetailsScreen**
  - Back → **RentalOrderDetailsScreen**

---

### **11. ON-DEMAND SERVICE SCREENS** (`on_demand_service/`)

#### **11.1 OnDemandHomeScreen** - `on_demand_home_screen.dart`
- **Controller:** `OnDemandHomeController`
- **Function:** On-demand services home (plumber, electrician, etc.)
- **Display Elements:**
  - Location selector
  - Service category grid
  - Popular services carousel
  - Top-rated providers
  - Special offers
  - Banners/Advertisements
- **Navigation Flow:**
  - Category → **OnDemandCategoryScreen**
  - View all → **ViewAllPopularServiceScreen**
  - Service → **OnDemandDetailsScreen**
  - Search → **SearchScreen**

#### **11.2 OnDemandCategoryScreen** - `on_demand_category_screen.dart`
- **Controller:** `OnDemandCategoryController`
- **Function:** Filter services by category
- **Key Features:**
  - Service list in category
  - Service provider info
  - Rating & reviews
  - Availability status
  - Price estimate
- **Navigation Flow:**
  - Select service → **OnDemandDetailsScreen**
  - Select provider → **OnDemandDetailsScreen**
  - Back → **OnDemandHomeScreen**

#### **11.3 ViewAllPopularServiceScreen** - `view_all_popular_service_screen.dart`
- **Controller:** `ViewAllPopularServiceController`
- **Function:** Display all popular services
- **Navigation Flow:**
  - Service tap → **OnDemandDetailsScreen**
  - Back → **OnDemandHomeScreen**

#### **11.4 ViewCategoryServiceScreen** - `view_category_service_screen.dart`
- **Controller:** `ViewCategoryServiceController`
- **Function:** View all services in a specific category
- **Navigation Flow:**
  - Service → **OnDemandDetailsScreen**
  - Back → **OnDemandCategoryScreen**

#### **11.5 OnDemandDetailsScreen** - `on_demand_details_screen.dart`
- **Controller:** `OnDemandDetailsController`
- **Function:** Service details & provider info
- **Display Elements:**
  - Service provider photo & info
  - Service description
  - Rating & reviews count
  - Price/estimate
  - Available slots/time
  - Service gallery
  - Reviews preview
  - Book button
- **Key Features:**
  - View provider profile
  - Check availability
  - Pricing details
- **Navigation Flow:**
  - Book service → **OnDemandBookingScreen**
  - View provider → **ProviderScreenProvider**
  - View reviews → **ReviewListScreen**
  - Add to favorite → Toggle favorite status
  - Back → **OnDemandCategoryScreen**

#### **11.6 OnDemandBookingScreen** - `on_demand_booking_screen.dart`
- **Controller:** `OnDemandBookingController`
- **Function:** Book on-demand service
- **Key Features:**
  - Service date picker
  - Time slot selector
  - Location confirmation
  - Service detail description
  - Special instructions
  - Contact number
  - Estimated cost
- **Navigation Flow:**
  - Confirm → **OnDemandPaymentScreen**
  - Change address → **AddressListScreen**
  - Back → **OnDemandDetailsScreen**

#### **11.7 OnDemandPaymentScreen** - `on_demand_payment_screen.dart`
- **Controller:** `OnDemandPaymentController`
- **Function:** Payment for on-demand service
- **Key Features:**
  - Service summary
  - Cost breakdown
  - Payment method selection
  - Apply coupon option
  - Pay button
- **Navigation Flow:**
  - Pay → Process payment → **OnDemandOrderDetailsScreen**
  - Apply coupon → **CouponListScreen**
  - Back → **OnDemandBookingScreen**

#### **11.8 OnDemandOrderDetailsScreen** - `on_demand_order_details_screen.dart`
- **Controller:** `OnDemandOrderDetailsController`
- **Function:** Service booking details & tracking
- **Key Features:**
  - Service status (confirmed, on the way, in progress, completed)
  - Provider location (live tracking)
  - Service address
  - Provider contact
  - Service timeline
  - Payment status
  - Support button
- **Navigation Flow:**
  - Contact provider → **ChatScreen** OR **WorkerInboxScreen**
  - Track → **LiveTrackingScreen**
  - Rate service → **OnDemandReviewScreen**
  - Back → **MyBookingOnDemandScreen**

#### **11.9 MyBookingOnDemandScreen** - `my_booking_on_demand_screen.dart`
- **Controller:** `MyBookingOnDemandController`
- **Function:** View on-demand service booking history
- **Key Features:**
  - List of all bookings
  - Booking date & time
  - Service type
  - Provider name
  - Status
  - Cost
  - Reorder button
- **Navigation Flow:**
  - Booking tap → **OnDemandOrderDetailsScreen**
  - Reorder → **OnDemandBookingScreen** (with saved data)
  - Back → **OnDemandDashboardScreen**

#### **11.10 OnDemandDashboardScreen** - `on_demand_dashboard_screen.dart`
- **Controller:** `OnDemandDashboardController`
- **Function:** On-demand service dashboard
- **Display Elements:**
  - Active service (if any)
  - Quick book buttons
  - History access
  - Tab navigation
- **Navigation Flow:**
  - Quick book → **OnDemandHomeScreen**
  - View history → **MyBookingOnDemandScreen**

#### **11.11 OnDemandReviewScreen** - `on_demand_review_screen.dart`
- **Controller:** `OnDemandReviewController`
- **Function:** Rate service provider & service quality
- **Key Features:**
  - Star rating
  - Comment
  - Photo upload
  - Aspect-based rating (professionalism, quality, etc.)
- **Navigation Flow:**
  - Submit → **OnDemandOrderDetailsScreen**
  - Back → **OnDemandOrderDetailsScreen**

#### **11.12 ProviderScreenProvider** - `provider_screen.dart`
- **Controller:** `ProviderController`
- **Function:** Service provider profile
- **Key Features:**
  - Provider info & photo
  - Rating & reviews count
  - Services offered
  - Working hours
  - Service locations
  - Verified badge
  - Reviews section
  - Book button
- **Navigation Flow:**
  - Book service → **OnDemandBookingScreen**
  - View reviews → **ReviewListScreen**
  - Contact → **ChatScreen**
  - Add to favorite → **FavouriteOndemandScreen**
  - Back → **OnDemandDetailsScreen**

#### **11.13 FavouriteOndemandScreen** - `favourite_ondemand_screen.dart`
- **Controller:** `FavouriteOndemandController`
- **Function:** Manage favorite on-demand providers/services
- **Key Features:**
  - List of favorite providers
  - Favorite services
  - Remove from favorite
  - Quick book button
- **Navigation Flow:**
  - Provider tap → **ProviderScreenProvider**
  - Service tap → **OnDemandDetailsScreen**
  - Book → **OnDemandBookingScreen**
  - Back → Dashboard or service screen

#### **11.14 OnDemandFavouritesScreen** - `on_demand_favourites_screen.dart`
- **Controller:** `FavouriteOndemandController`
- **Function:** Alternative favorite services screen
- **Navigation Flow:** Similar to FavouriteOndemandScreen

#### **11.15 WorkerInboxScreen** - `worker_inbox_screen.dart`
- **Controller:** `ChatController`
- **Function:** Chat with service provider
- **Key Features:**
  - Chat thread with provider
  - Send/receive messages
  - Photo/file sharing
  - Provider contact info
- **Navigation Flow:**
  - Send message → Update chat
  - Call provider → Make phone call
  - Back → **OnDemandOrderDetailsScreen**

#### **11.16 ProviderInboxScreen** - `provider_inbox_screen.dart`
- **Controller:** `ChatController`
- **Function:** Chat/messaging with providers
- **Navigation Flow:** Similar to WorkerInboxScreen

---

### **12. MULTI-VENDOR CORE SCREENS** (Additional common screens)

#### **12.1 ProfileScreen** - `profile_screen.dart`
- **Controller:** `MyProfileController`
- **Function:** User profile viewing
- **Display Elements:**
  - User avatar & name
  - Account info (email, phone)
  - Account type badge
  - Saved addresses count
  - Wallet balance
  - Loyalty points
  - Menu options (edit profile, settings, help, logout)
- **Navigation Flow:**
  - Edit profile → **EditProfileScreen**
  - Settings → App settings
  - Addresses → **AddressListScreen**
  - Wallet → **WalletScreen**
  - Logout → **LoginScreen**

#### **12.2 EditProfileScreen** - `edit_profile_screen.dart`
- **Controller:** `EditProfileController`
- **Function:** Modify user profile information
- **Key Features:**
  - Profile photo upload
  - First/Last name edit
  - Email edit
  - Phone number edit
  - Bio/About section
  - Save button
- **Navigation Flow:**
  - Save → Update profile → **ProfileScreen**
  - Back → **ProfileScreen**

#### **12.3 ChatScreen** - `chat_screen.dart`
- **Controller:** `ChatController`
- **Function:** In-app messaging with service providers/delivery partners
- **Key Features:**
  - Chat thread
  - Send/receive messages
  - Photo/document sharing
  - Video call option
  - Timestamp
  - Delivery partner/Provider contact info
  - Location sharing
- **Navigation Flow:**
  - End chat → Back to calling screen (order details)
  - Call → Make phone call
  - Back → Previous screen

#### **12.4 ChatVideoContainer** - `ChatVideoContainer.dart`
- **Controller:** N/A
- **Function:** Video call interface for in-app video calling
- **Key Features:**
  - Video call UI
  - End call button
  - Mute/Unmute
  - Camera toggle
  - Call duration timer
- **Navigation Flow:**
  - End call → Back to **ChatScreen**

#### **12.5 FullScreenImageViewer** - `full_screen_image_viewer.dart`
- **Controller:** N/A
- **Function:** Full-screen image viewing (from chat or other contexts)
- **Navigation Flow:**
  - Back → Return to calling screen

#### **12.6 FullScreenVideoViewer** - `full_screen_video_viewer.dart`
- **Controller:** N/A
- **Function:** Full-screen video playback
- **Navigation Flow:**
  - Back → Return to calling screen

#### **12.7 DriverInboxScreen** - `driver_inbox_screen.dart`
- **Controller:** `ChatController`
- **Function:** Chat with delivery driver
- **Navigation Flow:** Similar to ChatScreen

#### **12.8 RestaurantInboxScreen** - `restaurant_inbox_screen.dart`
- **Controller:** `ChatController`
- **Function:** Chat with restaurant
- **Navigation Flow:** Similar to ChatScreen

#### **12.9 FavouriteScreen** - `favourite_screen.dart`
- **Controller:** `FavouriteController`
- **Function:** View favorite food restaurants/items
- **Key Features:**
  - Favorite restaurants list
  - Favorite food items
  - Remove from favorite
  - Filter options
- **Navigation Flow:**
  - Restaurant/Item tap → **RestaurantDetailsScreen** OR **FoodItemDetailsModal**
  - Back → Dashboard

#### **12.10 SearchScreen** - `search_screen.dart`
- **Controller:** `SearchController`
- **Function:** Global search across restaurants, items, services
- **Key Features:**
  - Search input
  - Recent searches
  - Popular searches
  - Search results (restaurants, items, providers, services)
  - Filter results
- **Navigation Flow:**
  - Search result tap → Navigate to respective detail screen
  - Back → Previous screen

#### **12.11 ScanQRCodeScreen** - `scan_qr_code_screen.dart`
- **Controller:** `ScanQrCodeController`
- **Function:** Scan QR codes for loyalty, promotions, quick checkout
- **Key Features:**
  - Camera viewfinder
  - QR detection
  - Flashlight toggle
  - Permission handling
- **Navigation Flow:**
  - Valid QR scan → Navigate based on QR data
    - Coupon QR → Apply coupon to cart
    - Restaurant QR → **RestaurantDetailsScreen**
    - Provider QR → **ProviderScreenProvider**
  - Back → Previous screen

#### **12.12 AllAdvertisementScreen** - `all_advertisement_screen.dart`
- **Controller:** `AdvertisementListController`
- **Function:** View all promotional advertisements
- **Key Features:**
  - Grid/List of advertisements
  - Advertisement details (image, description, CTA)
  - Category filter
- **Navigation Flow:**
  - Advertisement tap → Open promotional offer/navigate to related screen
  - Back → **HomeScreen**

#### **12.13 RateUs Screen** - `rate_product_screen.dart`
- **Controller:** `RateProductController`
- **Function:** Rate app in app store
- **Key Features:**
  - Star rating for app
  - Comment box
  - Submit button
- **Navigation Flow:**
  - Submit → Redirect to app store
  - Skip → Back to previous screen

#### **12.14 ReferFriendScreen** - `refer_friend_screen.dart`
- **Controller:** `ReferFriendController`
- **Function:** Referral program management
- **Key Features:**
  - Referral code display
  - Copy referral link button
  - Share button
  - Earned referral rewards
  - How it works section
- **Navigation Flow:**
  - Share → Share via social/messaging
  - View rewards → **WalletScreen**
  - Back → **ProfileScreen**

#### **12.15 WalletScreen** - `wallet_screen.dart`
- **Controller:** `WalletController`
- **Function:** User wallet/prepaid balance management
- **Display Elements:**
  - Wallet balance
  - Add money button
  - Transaction history
  - Payment methods
- **Key Features:**
  - Add funds to wallet
  - View transactions
  - Refund status
- **Navigation Flow:**
  - Add money → **PaymentListScreen**
  - Transaction tap → **PaymentListScreen** (transaction details)
  - Back → **ProfileScreen**

#### **12.16 PaymentListScreen** - `payment_list_screen.dart`
- **Controller:** `WalletController`
- **Function:** View wallet transactions/add funds
- **Key Features:**
  - Transaction list
  - Add funds form
  - Select payment method
  - Amount input
- **Navigation Flow:**
  - Add funds → Payment gateway → **WalletScreen** (updated)
  - Back → **WalletScreen**

#### **12.17 GiftCardScreen** - `gift_card_screen.dart`
- **Controller:** `GiftCardController`
- **Function:** Browse & purchase gift cards
- **Key Features:**
  - Gift card list
  - Price tiers
  - Customization option
  - Buy button
- **Navigation Flow:**
  - Buy → **SelectGiftPaymentScreen**
  - View history → **HistoryGiftCardScreen**
  - Back → **ProfileScreen**

#### **12.18 SelectGiftPaymentScreen** - `select_gift_payment_screen.dart`
- **Controller:** `GiftCardController`
- **Function:** Payment for gift card purchase
- **Navigation Flow:**
  - Pay → Process payment → **HistoryGiftCardScreen** OR confirmation
  - Back → **GiftCardScreen**

#### **12.19 HistoryGiftCardScreen** - `history_gift_card.dart`
- **Controller:** `HistoryGiftCardController`
- **Function:** View purchased gift cards
- **Key Features:**
  - Purchased gift cards list
  - Gift card codes
  - Balance
  - Share option
  - Redeem button
- **Navigation Flow:**
  - Redeem → **RedeemGiftCardScreen**
  - Share → Share gift card code
  - Back → **GiftCardScreen**

#### **12.20 RedeemGiftCardScreen** - `redeem_gift_card_screen.dart`
- **Controller:** `RedeemGiftCardController`
- **Function:** Redeem gift card balance
- **Key Features:**
  - Gift card input
  - Balance display
  - Redeem to wallet button
- **Navigation Flow:**
  - Redeem → Add balance to wallet → **WalletScreen**
  - Back → **HistoryGiftCardScreen**

#### **12.21 CashbackOffersScreen** - `cashback_offers_list.dart`
- **Controller:** `CashbackController`
- **Function:** View available cashback offers & redemption
- **Key Features:**
  - Active cashback offers list
  - Cashback amount
  - Redemption conditions
  - Expired offers section
- **Navigation Flow:**
  - Offer tap → Show offer details
  - Redeem → Process redemption → **WalletScreen**
  - Back → **ProfileScreen**

#### **12.22 ForgotPasswordScreen** - `forgot_password_screen/` (in multi_vendor)
- **Controller:** `ForgotPasswordController`
- **Function:** Password reset (may be alternate implementation)
- **Navigation Flow:** Similar to auth_screens variant

#### **12.23 TermsAndConditionScreen** - `terms_and_condition/`
- **Controller:** N/A
- **Function:** Display app terms and privacy policy
- **Key Features:**
  - Terms text (scrollable)
  - Accept checkbox
  - Decline button
- **Navigation Flow:**
  - Accept → Proceed to next screen
  - Decline → Back
  - From signup → Accept required to continue

---

## 📊 Screen Navigation Flow Diagram

```
SplashScreen (3 sec)
    ↓
[Check Conditions]
    ├─→ MaintenanceModeScreen
    ├─→ OnboardingScreen
    └─→ [Check Auth]
        ├─→ LoginScreen → SignUpScreen
        ├─→ MobileLoginScreen → OTPVerificationScreen → SignUpScreen
        └─→ [Check Address]
            ├─→ LocationPermissionScreen → AddressListScreen
            └─→ ServiceListScreen [Main Hub]
                ├─→ Food (HomeScreen, MultiVendor)
                ├─→ E-commerce (HomeECommerceScreen)
                ├─→ Cab (CabHomeScreen)
                ├─→ Parcel (HomeParcelScreen)
                ├─→ Rental (RentalHomeScreen)
                ├─→ OnDemand (OnDemandHomeScreen)
                ├─→ ProfileScreen
                ├─→ CartScreen
                ├─→ WalletScreen
                └─→ FavouriteScreen
```

---

## 🎯 Key Features Supported

1. **Multi-Service Marketplace**
   - E-commerce
   - Food Delivery & Dine-in
   - Cab/Ride Sharing
   - Parcel Delivery
   - Car Rental
   - On-Demand Services

2. **User Management**
   - Authentication (Email, Phone, Google, Apple)
   - Profile Management
   - Address Management
   - Favorites/Wishlist

3. **Payment Integration**
   - Multiple gateway support (Stripe, Razorpay, Paytm, Mercado Pago, PayFast, Xendit, PayStack)
   - Wallet system
   - Cashback rewards

4. **Location Services**
   - Google Maps integration
   - OpenStreetMap (OSM) integration
   - Geolocation tracking
   - Real-time order tracking

5. **Communication**
   - In-app messaging/chat
   - Push notifications
   - Email notifications

6. **Loyalty Programs**
   - Referral system
   - Gift cards
   - Cashback rewards
   - Discount coupons

7. **Multi-language & Theme Support**
   - Dark/Light mode
   - Multiple language support

---

## 📦 External Dependencies

### State Management
- **GetX** - Reactive state management and routing

### Backend
- **Firebase** - Authentication, Firestore, Realtime DB, Storage, Messaging

### UI/UX
- **Flutter SVG** - SVG rendering
- **Shimmer** - Loading shimmer effects
- **Photo View** - Image zooming
- **HTML** - HTML content rendering

### Maps & Location
- **Google Maps Flutter** - Google Maps integration
- **Flutter OSM Plugin** - OpenStreetMap support
- **Geolocator** - Location services
- **Geocoding** - Address geocoding

### Payment
- **Flutter Stripe** - Stripe payments
- **Razorpay Flutter** - Razorpay integration
- **PayPal Flutter** - PayPal integration

### Media
- **Image Picker** - Photo/video selection
- **Video Player** - Video playback
- **Video Compress** - Video compression

### Utilities
- **Shared Preferences** - Local data persistence
- **SQLite** - Local database
- **QR Code Scan** - QR code reading
- **Mailer** - Email sending

---

## 🚀 Getting Started

1. Flutter SDK installation
2. Firebase project setup
3. Configure Google/Apple credentials for authentication
4. Set up payment gateway credentials
5. Update API endpoints in constants
6. Run `flutter pub get` to install dependencies
7. Run on Android: `flutter run` or on iOS: `flutter run -d iphone`

---

**Last Updated:** April 26, 2026





Based on my examination of the codebase, here's the navigation flow:

🔑 Page Flow After Login & Account Creation
When User Logs In:
User enters credentials on LoginScreen
LoginController.loginWithEmail() authenticates with Firebase
Next Page Depends on Saved Addresses:
✅ If user HAS saved addresses → Navigates to ServiceListScreen (main dashboard)
❌ If NO saved addresses → Navigates to LocationPermissionScreen (to add delivery address first)
When User Creates an Account:
User fills form on SignUpScreen
SignUpController.signUp() creates Firebase account
User profile saved to Firestore with:
Name, email, phone, country code
Role set to "customer"
Active status set to true
FCM token for notifications
Next Page (Same Logic as Login):
✅ If user HAS saved addresses → ServiceListScreen
❌ If NO saved addresses → LocationPermissionScreen
First Page When App Loads:
SplashScreen (3-second delay)
Then SplashController.redirectScreen() checks:
Maintenance mode status
If onboarding completed
If user is logged in
User's role and active status
Saved addresses
📍 Key Screens:
Screen	Purpose
ServiceListScreen	Main marketplace dashboard showing all services (E-commerce, Food, Cab, Parcel, Rental, On-demand)
LocationPermissionScreen	User must add their first delivery address before accessing services
LoginScreen	Entry point for existing users
SignUpScreen	Account creation for new users
SplashScreen	App startup screen with initialization
The flow ensures users always have a delivery address set before they can browse services!