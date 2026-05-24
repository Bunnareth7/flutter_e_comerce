# 🛍️ E-Shop – Flutter E-Commerce App

A full‑featured e‑commerce mobile application built with **Flutter** and **Firebase**, following **Clean Architecture** and **BLoC** state management. The app supports product browsing, cart, wishlist, checkout, order tracking, user authentication, and more.

---

## 📱 Features

### Authentication
- Sign up, login, and logout with Firebase Authentication (Email/Password)
- Forgot password with reset email
- Input validation and error handling

### Product Catalog
- Product grid with Firestore integration
- Search by name and description
- Category filter chips
- Banner carousel on home screen
- Pull‑to‑refresh

### Product Detail
- Image carousel with dot indicators
- Size and color selectors (where applicable)
- Quantity picker
- Add to cart and Buy Now buttons
- Related products section
- Product reviews and ratings
- Discount badges with original & discounted prices

### Shopping Cart (Persistent)
- Add, remove, and update quantity
- Swipe‑to‑delete items
- Live cart badge on bottom navigation
- Cart data survives app restarts (SQLite)

### Wishlist (Persistent)
- Heart toggle on product cards and detail screen
- Dedicated wishlist tab
- Persistent across restarts (SQLite)

### Checkout
- Address selection from saved addresses
- Payment simulation with processing dialog
- Order confirmation and cart clearing

### Orders
- Persistent order history (SQLite)
- Order detail screen with tracking timeline
- Shipping address display

### User Profile
- View and edit profile information
- Manage shipping addresses (CRUD)
- App logout

### Additional UX
- Onboarding screen (first launch only)
- Animated splash screen
- Search history with suggestion chips
- Shimmer loading, empty states, hero animations

---

## 🏗️ Architecture

This project follows **Clean Architecture** principles with three layers:

- **Data Layer** – datasources (local SQLite, remote Firestore), models, repository implementations
- **Domain Layer** – entities, repository interfaces, use cases
- **Presentation Layer** – BLoCs, screens, widgets

State management is handled with **flutter_bloc**. Dependency injection is managed by **get_it**.

---

## 🛠️ Tech Stack

| Category | Technology |
|----------|------------|
| Frontend | Flutter (Dart) |
| Backend | Firebase Authentication, Cloud Firestore |
| Local Storage | SQLite (sqflite) |
| State Management | flutter_bloc |
| DI | get_it |
| Functional Error Handling | dartz (Either) |
| Fonts | google_fonts (Poppins) |
| Onboarding | shared_preferences |

---

## 📂 Project Structure
lib/
├── core/ # Shared utilities, errors, usecase base class
├── features/
│ ├── address/ # Address management
│ ├── auth/ # Authentication (Firebase)
│ ├── cart/ # Shopping cart
│ ├── checkout/ # Checkout & order placement
│ ├── onboarding/ # Onboarding flow
│ ├── order/ # Order history & detail
│ ├── product/ # Product listing & detail
│ ├── profile/ # User profile
│ ├── review/ # Product reviews
│ ├── search/ # Search history
│ ├── splash/ # Splash screen
│ └── wishlist/ # Wishlist
├── injection_container.dart # GetIt DI setup
├── app.dart # App entry with routes and providers
└── main.dart # Firebase init and app startup


 
---

## 🚀 Setup Instructions

### Prerequisites
- Flutter SDK (≥ 3.10)
- Android Studio / VS Code
- Firebase project

### 1. Clone the repository
```bash
git clone https://github.com/Bunnareth7/flutter_e_comerce.git
cd flutter_e_comerce
flutter pub get
# (Optional) Put your google-services.json inside android/app/
flutter run