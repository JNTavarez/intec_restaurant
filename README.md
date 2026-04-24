# INTEC Restaurant App

A comprehensive mobile application built with Flutter, designed to provide a complete restaurant menu and food ordering experience. The app integrates Firebase for authentication, database management, and cloud storage, offering a seamless user journey from registration to order tracking.

## 🚀 Features

- **User Authentication:** Secure sign-up and login functionalities powered by Firebase Auth.
- **Profile Management:** Users can view, edit, and manage their profiles, including uploading avatars using Firebase Storage and Image Picker.
- **Interactive Menu:** Browse various food categories (burgers, desserts, drinks, salads, sides) with custom TabBars and dynamic Slivers.
- **Food Details:** View in-depth information about food items, customize with add-ons, and see dynamic pricing.
- **Shopping Cart & Checkout:** Add items to the cart, adjust quantities, and proceed to a structured checkout process.
- **Payment Integration:** UI for selecting payment methods and a custom credit card component.
- **Order Tracking:** A delivery progress screen that simulates real-time order tracking.
- **Favorites:** Users can save and manage their favorite food items for quick access.
- **Settings & Theming:** Configurable application settings, including a Dark/Light mode toggle.

## 🛠️ Tech Stack & Dependencies

- **Framework:** [Flutter](https://flutter.dev/)
- **Language:** Dart
- **State Management:** `provider`
- **Backend / BaaS:** Firebase
  - `firebase_auth`: For user authentication.
  - `cloud_firestore`: NoSQL database for managing users, food items, and orders.
  - `firebase_storage`: For storing user profile images.
- **UI & Utilities:**
  - `google_fonts`: For modern, custom typography.
  - `cupertino_icons`: For iOS-style icons.
  - `shared_preferences`: For local persistent storage (e.g., theme preferences).
  - `image_picker`: For selecting images from the device gallery.
  - `form_field_validator`: For streamlined form validation logic.
  - `flutter_dotenv`: For securely loading environment variables (like Firebase credentials) at runtime.

## 📂 Project Architecture

The project follows a scalable MVC/Provider architecture to cleanly separate concerns:

```text
lib/
├── main.dart                  # Application entry point
├── constants.dart             # Global constants and configurations
├── firebase_options.dart      # Firebase configuration file
└── src/
    ├── controllers/           # Business logic and external service interactions
    ├── models/                # Data models (e.g., Restaurant, UserProfile, Food)
    ├── providers/             # State management providers
    ├── themes/                # App themes (Light and Dark mode definitions)
    └── views/                 # UI Layer
        └── screens/
            ├── auth_screens/  # Login, Register, AuthGate
            ├── tab_screens/   # Cart, Explore, Favorites, Profile
            ├── components/    # Reusable widgets (Drawer, FoodTile, Custom AppBars, Credit Card)
            ├── home_screen.dart
            ├── food_detail_screen.dart
            ├── payment_methods_screen.dart
            └── delivery_progress_screen.dart
```

## ⚙️ Getting Started

To run this project locally, follow these steps:

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed (version >= 3.10.8).
- A configured IDE (VS Code, Android Studio, etc.).
- An active Firebase Project.

### Installation Steps

1. **Clone the repository:**

   ```bash
   git clone <repository_url>
   cd intec_restaurant
   ```

2. **Install dependencies:**

   ```bash
   flutter pub get
   ```

3. **Configure Environment Variables & Firebase:**
   - The project protects sensitive Firebase credentials using a `.env` file.
   - Duplicate the provided template and rename it to `.env`:
     ```bash
     cp .env.example .env
     ```
   - Open the `.env` file and fill in the values with your Firebase project credentials.
   - *(Optional)* If you run the FlutterFire CLI (`flutterfire configure`) to re-generate settings, remember to update `lib/firebase_options.dart` again so it reads from `dotenv.env['KEY']` rather than using hardcoded values.
   - Ensure you enable **Authentication**, **Firestore**, and **Storage** in your Firebase console.

4. **Run the App:**
   - Connect an emulator or physical device.
   - Run the application:

     ```bash
     flutter run
     ```

## 🎨 UI Highlights

- **Custom Slivers:** The home screen uses a `SliverAppBar` with a flexible space bar for a dynamic scrolling experience.
- **Custom Components:** Features highly reusable widgets like `MyDrawer`, `MyFoodTile`, `MyQuantitySelector`, and `MyCreditCard`.
- **Responsive Design:** Ensures a smooth experience across different screen sizes.

## 📝 License

This project is open-source and available under the [MIT License](LICENSE).
