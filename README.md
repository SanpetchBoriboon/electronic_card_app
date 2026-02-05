# 💒 Electronic Wedding Card App

A beautiful, interactive wedding invitation mobile application built with Flutter. This app provides a complete digital wedding experience with stunning animations, guest interactions, and modern design.

## ✨ Features

### 🎴 3D Flip Card Animation

- Interactive wedding invitation with smooth 3D flip animation
- Elegant card design with bride and groom details
- Touch-responsive flip interaction

### ⏰ Wedding Countdown

- Real-time countdown to the wedding date
- Beautiful animated display showing days, hours, minutes, and seconds

### 🗓️ Schedule Page

- Complete wedding day timeline
- Ceremony and reception details
- Venue information and timing

### 📸 Photo Gallery

- Beautiful gallery showcase
- Full-screen photo viewer with smooth transitions
- Responsive grid layout

### 💝 Wishes & Blessings

- Interactive wishes submission form
- Photo upload functionality for guests
- Real-time API integration for storing wishes
- Loading and success feedback

### 🌻 Thank You Page

- Display all submitted wishes from guests
- Beautiful sunflower-themed design
- Template color customization
- Image proxy for CORS-free image loading

### 🎨 Template Colors

- Dynamic color theming system
- Customizable color schemes
- Consistent design across all pages

### 🚀 Splash Screen

- Professional app startup experience
- Animated mini-logo with fade effects
- Smooth white fade transition to main app

## 🛠️ Technology Stack

- **Frontend**: Flutter (Dart)
- **UI/UX**: Material Design with custom animations
- **State Management**: StatefulWidget with AnimationController
- **HTTP Requests**: http package for API integration
- **Local Storage**: SharedPreferences for token persistence
- **Image Handling**: image_picker for photo uploads
- **Cross-Platform**: iOS, Android, Web support

## 📱 Screenshots & Demo

The app features a modern, elegant design with:

- Smooth 3D animations and transitions
- Responsive design for all screen sizes
- Professional loading states and feedback
- Intuitive navigation between pages

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (^3.9.2)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- Web browser (for web development)

### Installation

1. **Clone the repository**

    ```bash
    git clone <repository-url>
    cd electronic_card_app
    ```

2. **Install dependencies**

    ```bash
    flutter pub get
    ```

3. **Add required assets**
    - Place `mini-logo.png` in `assets/images/`
    - Add gallery images in `assets/images/gallery/`
    - Update `pubspec.yaml` if adding new assets

4. **Run the application**

    ```bash
    # For debug mode
    flutter run

    # For web
    flutter run -d chrome

    # For specific device
    flutter run -d <device-id>
    ```

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point & main wedding card
├── splash_screen.dart        # App splash screen with animations
├── schedule.dart            # Wedding schedule page
├── gallery.dart             # Photo gallery page
├── wishes.dart              # Wishes submission form
└── thank_you_page.dart      # Thank you & wishes display page

assets/
├── images/
│   ├── mini-logo.png        # App logo for splash screen
│   └── gallery/             # Gallery photos
└── icons/                   # App icons
```

## 🔧 Configuration

### API Integration

The app integrates with a REST API for wishes submission. Configure the API endpoints in the wishes page:

```dart
// Update API URLs in wishes.dart and thank_you_page.dart
const String apiUrl = 'your-api-endpoint';
const String imageProxyUrl = 'your-image-proxy-endpoint';
```

### Template Colors

Customize the app colors by modifying the template color system in `thank_you_page.dart`:

```dart
// Example template colors
final templateColors = {
  'primary': '#E8F4F0',
  'secondary': '#4A7C59',
  'accent': '#8B4513'
};
```

## 🎯 Key Features Implementation

- **3D Flip Animation**: Custom AnimationController with Transform.rotate3D
- **API Integration**: HTTP requests with multipart file upload
- **Image Handling**: Cross-platform image picker and display
- **Responsive Design**: MediaQuery-based responsive layouts
- **State Management**: Efficient StatefulWidget architecture
- **Error Handling**: Comprehensive error states and user feedback

## 🚀 Build & Deploy

### Android

```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

### Web

```bash
flutter build web --release
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Authors

- **Developer** - Wedding Card App Team

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design for UI inspiration
- Community packages that made this project possible

---

Built with ❤️ using Flutter
