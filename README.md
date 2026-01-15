# 📦 Inventory Management System

A comprehensive Flutter-based inventory management application with offline support, QR code scanning, and real-time stock tracking.

## 🎯 Features

### Core Features (Mandatory)
- ✅ **Product Management**
  - Add, edit, and delete products
  - 5-character alphanumeric unique Product ID validation
  - Product attributes: Name, Description, Current Stock
  - Image support (Camera/Gallery)
  - Metadata: Timestamp and "Added By" username
  - Persistent local storage with SQLite

- ✅ **Home Screen**
  - Display all products in card layout
  - Search bar with Product ID filtering
  - Pull-to-refresh functionality
  - Empty state handling

- ✅ **CRUD Operations**
  - Full Create, Read, Update, Delete capabilities
  - Input validation and error handling
  - Confirmation dialogs for destructive actions

- ✅ **Stock Management**
  - Increment/Decrement controls
  - Dedicated Stock Update screen
  - Stock validation (prevent negative values)

### Bonus Features
- ✅ **QR Code Scanner**
  - Search and identify products via QR scanning
  - Torch and camera flip controls
  - Direct navigation to product details

- ✅ **Stock History**
  - Chronological log of all stock changes
  - Track +/- values with timestamps
  - View complete transaction history per product

### Additional Features
- 📊 **Dashboard**
  - Total products count
  - Total stock value
  - Low stock alerts
  - Out of stock monitoring
  - Quick action buttons

- ⚠️ **Low Stock Alerts**
  - Dedicated alert screen
  - Out of stock section
  - Low stock section (< 10 units)
  - Quick restock actions

- ⚙️ **Settings**
  - App information
  - Feature overview
  - Package details
  - Database management

## 🏗️ Architecture

### MVVM + Riverpod Pattern

```
┌─────────────────────────────────────────┐
│              View Layer                  │
│  (Screens, Widgets, UI Components)      │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│           ViewModel Layer                │
│  (Riverpod Providers, State Notifiers)  │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│            Model Layer                   │
│     (Product, StockHistory Models)      │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│         Repository Layer                 │
│      (Data Access Abstraction)          │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│          Database Layer                  │
│         (SQLite with sqflite)           │
└─────────────────────────────────────────┘
```

## 📁 Project Structure

```
lib/
├── main.dart                      # App entry point
├── models/
│   ├── product.dart              # Product model
│   └── stock_history.dart        # Stock history model
├── repositories/
│   └── product_repository.dart   # Data access layer
├── view_models/
│   └── product_view_model.dart   # Riverpod state management
├── views/
│   ├── home_screen.dart          # Main product list
│   ├── add_edit_product_screen.dart
│   ├── product_detail_screen.dart
│   ├── stock_update_screen.dart  # Dedicated stock update
│   ├── stock_history_screen.dart # Transaction history
│   ├── qr_scanner_screen.dart    # QR code scanning
│   ├── dashboard_screen.dart     # Statistics overview
│   ├── low_stock_screen.dart     # Alert management
│   └── settings_screen.dart      # App settings
├── widgets/
│   ├── product_card.dart         # Product list item
│   └── stock_control_widget.dart # Stock +/- controls
└── utils/
    └── database_helper.dart      # SQLite database operations
```

## 🛠️ Tech Stack & Packages

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_riverpod` | ^2.4.9 | State management |
| `sqflite` | ^2.3.0 | Local SQLite database |
| `path` | ^1.8.3 | File path operations |
| `image_picker` | ^1.0.4 | Camera & gallery access |
| `mobile_scanner` | ^3.5.2 | QR code scanning |
| `uuid` | ^4.2.1 | Unique ID generation |
| `intl` | ^0.18.1 | Date & number formatting |
| `cached_network_image` | ^3.3.0 | Image caching |

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Android Studio / VS Code
- Android device or emulator

### Installation

1. **Clone the repository**
```bash
git clone <your-repo-url>
cd inventory_management
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
flutter run
```

### Building APK

```bash
# Release APK
flutter build apk --release

# Split APKs (recommended - smaller size)
flutter build apk --split-per-abi

# Output location:
# build/app/outputs/flutter-apk/app-release.apk
```

## 📱 All Screens Overview

### 1. Home Screen
- Product list with cards
- Search by Product ID
- Quick actions (Dashboard, QR Scanner, Settings)
- Add product FAB
- Delete products
- Pull-to-refresh

### 2. Dashboard Screen
- Total products
- Total stock value
- Low stock alerts
- Out of stock count
- Average stock per product
- Quick action buttons

### 3. Add Product Screen
- Product ID input (5 alphanumeric characters)
- Name, description, initial stock
- Image picker (Camera/Gallery)
- Input validation
- Unique ID checking

### 4. Edit Product Screen
- Same as Add Product
- Pre-filled with existing data
- Product ID is read-only

### 5. Product Detail Screen
- Product information display
- Product image
- Current stock display
- Stock control buttons (+/-)
- Quick actions: Update Stock, View History
- Edit button

### 6. Stock Update Screen
- Stock In/Out operations
- Quantity input with +/- buttons
- Optional notes field
- Preview of new stock value
- Operation confirmation

### 7. Stock History Screen
- Product summary card
- Total transactions count
- Chronological list of all changes
- Stock In (green) / Stock Out (red)
- Timestamp for each transaction
- Stock value after each change

### 8. QR Scanner Screen
- Live camera preview
- QR code detection
- Torch toggle
- Camera flip
- Automatic product lookup

### 9. Low Stock Alert Screen
- Out of stock section (stock = 0)
- Low stock section (stock < 10)
- Summary card with alert count
- Quick restock button
- Direct product navigation

### 10. Settings Screen
- App information
- Version details
- Architecture overview
- Features list
- Packages used
- Database management
- Clear all data option

## 🗄️ Database Schema

### Products Table
```sql
CREATE TABLE products (
  id TEXT PRIMARY KEY,           -- 5 alphanumeric characters
  name TEXT NOT NULL,
  description TEXT NOT NULL,
  currentStock INTEGER NOT NULL,
  imagePath TEXT,
  timestamp TEXT NOT NULL,       -- ISO 8601 format
  addedBy TEXT NOT NULL          -- Hardcoded username
)
```

### Stock History Table
```sql
CREATE TABLE stock_history (
  historyId INTEGER PRIMARY KEY AUTOINCREMENT,
  productId TEXT NOT NULL,
  changeAmount INTEGER NOT NULL, -- Positive or negative
  stockAfterChange INTEGER NOT NULL,
  timestamp TEXT NOT NULL,
  changeType TEXT NOT NULL,      -- 'increment' or 'decrement'
  FOREIGN KEY (productId) REFERENCES products (id) ON DELETE CASCADE
)
```

## 🔧 Configuration

### Android Permissions (AndroidManifest.xml)
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.INTERNET"/>
```

### Minimum SDK Requirements
- minSdkVersion: 21
- targetSdkVersion: 34
- compileSdkVersion: 34

## 🎨 UI/UX Features

- Material Design 3
- Responsive layouts
- Loading indicators
- Error handling with user-friendly messages
- Empty state illustrations
- Confirmation dialogs
- Snackbar notifications
- Pull-to-refresh
- Smooth navigation transitions

## 🧪 Testing

```bash
# Run tests
flutter test

# Run with coverage
flutter test --coverage
```

## 📝 Code Quality

- MVVM architecture for separation of concerns
- Repository pattern for data access
- Provider pattern (Riverpod) for state management
- Singleton pattern for database
- Factory pattern for model creation
- Clean code principles
- Comprehensive error handling

## 🔐 Data Security

- All data stored locally (offline-first)
- No network calls (privacy-focused)
- SQLite database with proper constraints
- Input validation and sanitization
- CASCADE delete for referential integrity

## 🎯 Performance Optimizations

- Efficient database queries with indexes
- Image caching for faster loading
- Lazy loading for large lists
- Async operations for non-blocking UI
- Optimized build methods

## 📈 Future Enhancements

- [ ] Export data to CSV/Excel
- [ ] Barcode generation for products
- [ ] Multi-user support with authentication
- [ ] Cloud sync capability
- [ ] Reports and analytics
- [ ] Category management
- [ ] Supplier information
- [ ] Purchase orders
- [ ] Sales tracking

## 🐛 Known Issues

None reported. Please create an issue if you find any bugs.

## 📄 License

This project is licensed under the MIT License.

## 👨‍💻 Developer

Created with ❤️ for the Android Development Assessment

## 📞 Support

For issues, questions, or feedback:
- Create an issue in the repository
- Contact: [Your Email]

---

**Built with Flutter | MVVM + Riverpod | SQLite**