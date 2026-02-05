# 💒 Electronic Wedding Card App

A beautiful Flutter web application for wedding invitations with wishes collection system.

## ✨ Features

- **Digital Wedding Invitation** - Beautiful animated wedding card
- **Wedding Schedule** - Timeline of wedding events
- **Photo Gallery** - Wedding photo gallery with viewer
- **Wishes Collection** - Guests can send wishes with photos
- **Thank You Page** - Display collected wishes
- **Responsive Design** - Works on all devices
- **Thai Fonts** - Beautiful Thai typography support

## 🚀 Quick Start

### Prerequisites

- Flutter SDK (latest stable)
- Dart SDK
- Git

### Installation

```bash
# Clone the repository
git clone <your-repo-url>
cd electronic_card_app

# Install dependencies
flutter pub get

# Run the app
flutter run -d chrome
```

## 🌐 Deployment

This project supports both **manual** and **automatic** deployment to Fly.io.

### 🎯 Auto Deployment (Recommended)

**Automatic deployment triggers on every push to `main` branch.**

#### Setup Steps:

1. **Get Fly.io API Token:**

    ```bash
    flyctl auth token
    ```

2. **Add GitHub Secret:**
    - Go to GitHub repository → Settings → Secrets and variables → Actions
    - Create new secret:
        - Name: `FLY_API_TOKEN`
        - Value: [your fly.io token from step 1]

3. **Push to main branch:**

    ```bash
    git push origin main
    ```

4. **Done!** 🎉 GitHub Actions will automatically:
    - Build Flutter web app
    - Deploy to Fly.io
    - Your app will be live at: https://ben-mae-the-wedding.fly.dev

#### Auto Deploy Features:

- ✅ Triggered on every push to `main`
- ✅ Automatic Flutter web build
- ✅ Code analysis and testing
- ✅ Zero-downtime deployment
- ✅ Deployment status notifications

---

### 🔧 Manual Deployment

For one-time deployments or when you need more control.

#### Prerequisites:

1. **Install Fly.io CLI:**

    ```bash
    curl -L https://fly.io/install.sh | sh
    ```

2. **Login to Fly.io:**
    ```bash
    flyctl auth login
    ```

#### Quick Deploy:

```bash
# One-command deployment
./deploy.sh
```

#### Manual Step-by-Step:

```bash
# 1. Set up secrets (first time only)
./set-secrets.sh

# 2. Build Flutter web
flutter build web --release

# 3. Deploy to Fly.io
flyctl deploy

# 4. Check status
flyctl status
```

#### Manual Deploy Features:

- 🎛️ Full control over deployment process
- 🔍 Local build verification
- 🔧 Custom secret management
- 📊 Immediate deployment feedback

---

## 🛠️ Configuration

### Environment Variables

Create `.env` file:

```env
# API Configuration
API_BASE_URL=https://wedding-card-online-service.fly.dev/api
```

### Fly.io Secrets

The app uses the following secrets:

- `API_BASE_URL` - Backend API endpoint

Set secrets:

```bash
flyctl secrets set API_BASE_URL="your-api-url"
```

## 📱 Project Structure

```
lib/
├── main.dart              # App entry point
├── font_styles.dart       # Thai font system
├── config/
│   └── api_config.dart    # API configuration
├── gallery.dart           # Photo gallery
├── schedule.dart          # Wedding schedule
├── wishes.dart           # Wishes collection
├── thank_you_page.dart   # Thank you page
└── splash_screen.dart    # Loading screen

assets/
├── images/               # App images
├── fonts/               # Thai fonts
└── icons/               # App icons

.github/
└── workflows/
    ├── ci.yml           # Continuous Integration
    └── deploy.yml       # Auto Deployment
```

## 🔄 Development Workflow

### For Contributors:

1. **Create feature branch:**

    ```bash
    git checkout -b feature/my-feature
    ```

2. **Make changes and commit:**

    ```bash
    git add .
    git commit -m "Add new feature"
    ```

3. **Push and create PR:**

    ```bash
    git push origin feature/my-feature
    ```

4. **CI automatically runs:**
    - Code analysis
    - Tests
    - Build verification

5. **After review, merge to main:**
    - Auto deployment triggers
    - App updates automatically

### For Quick Changes:

1. **Direct push to main:**

    ```bash
    git add .
    git commit -m "Quick fix"
    git push origin main
    ```

2. **Auto deployment happens immediately!**

## 🚀 Deployment Options Comparison

| Feature      | Auto Deploy            | Manual Deploy    |
| ------------ | ---------------------- | ---------------- |
| **Trigger**  | Git push to main       | Manual command   |
| **Setup**    | One-time GitHub secret | Local Fly.io CLI |
| **Speed**    | ~3-5 minutes           | ~1-2 minutes     |
| **CI/CD**    | ✅ Full pipeline       | ❌ No CI         |
| **Rollback** | GitHub revert          | Manual flyctl    |
| **Best for** | Production             | Development      |

## 📊 Monitoring

### GitHub Actions

- View deployment status in Actions tab
- Get notified on deployment failures
- See build logs and deployment time

### Fly.io Dashboard

- Monitor app performance
- View logs: `flyctl logs`
- Check status: `flyctl status`

### App Health

- Health check endpoint: `/health`
- Auto-scaling based on traffic
- Zero-downtime deployments

## 🛡️ Production Checklist

Before going live:

- [ ] Set up auto deployment
- [ ] Configure production API_BASE_URL
- [ ] Test deployment pipeline
- [ ] Set up monitoring
- [ ] Configure domain (optional)
- [ ] Enable HTTPS (automatic with Fly.io)

## 🆘 Troubleshooting

### Auto Deployment Issues:

**Build fails:**

```bash
# Check GitHub Actions logs
# Usually Flutter version or dependency issues
```

**Deployment fails:**

```bash
# Check if FLY_API_TOKEN is set correctly in GitHub secrets
# Verify Fly.io app exists: flyctl apps list
```

### Manual Deployment Issues:

**CLI not found:**

```bash
# Reinstall Fly.io CLI
curl -L https://fly.io/install.sh | sh
```

**Auth issues:**

```bash
# Re-login to Fly.io
flyctl auth login
```

**Build issues:**

```bash
# Clean Flutter build
flutter clean
flutter pub get
```

## 🎯 Live App

**Production URL:** https://ben-mae-the-wedding.fly.dev

## 📞 Support

For deployment issues:

- Check GitHub Actions logs
- Review Fly.io dashboard
- Run `flyctl logs` for app logs
- Check `flyctl status` for health

---

**Happy Deploying!** 🚀✨

### 🚀 Splash Screen | หน้าจอเปิดแอป

- Professional app startup experience | ประสบการณ์การเปิดแอปอย่างมืออาชีพ
- Animated mini-logo with fade effects | มินิโลโก้แอนิเมชันพร้อมเอฟเฟกต์เฟด
- Smooth white fade transition to main app | การเปลี่ยนหน้าแบบ white fade ที่นุ่มนวลสู่แอปหลัก

## 🛠️ Technology Stack | เทคโนโลยีที่ใช้

- **Frontend**: Flutter (Dart) | ส่วนหน้า: Flutter (Dart)
- **UI/UX**: Material Design with custom animations | ส่วนติดต่อผู้ใช้: Material Design พร้อมแอนิเมชันกำหนดเอง
- **State Management**: StatefulWidget with AnimationController | การจัดการสถานะ: StatefulWidget พร้อม AnimationController
- **HTTP Requests**: http package for API integration | การร้องขอ HTTP: package http สำหรับเชื่อมต่อ API
- **Local Storage**: SharedPreferences for token persistence | การจัดเก็บข้อมูลท้องถิน: SharedPreferences สำหรับเก็บ token
- **Image Handling**: image_picker for photo uploads | การจัดการรูปภาพ: image_picker สำหรับอัปโหลดรูป
- **Cross-Platform**: iOS, Android, Web support | รองรับหลากหลายแพลตฟอร์ม: iOS, Android, Web

## 📱 Screenshots & Demo | ภาพหน้าจอและตัวอย่าง

The app features a modern, elegant design with:
แอปมีดีไซน์ที่ทันสมัยและสวยงามพร้อม:

- Smooth 3D animations and transitions | แอนิเมชัน 3D และการเปลี่ยนที่นุ่มนวล
- Responsive design for all screen sizes | ดีไซน์ที่ตอบสนองสำหรับทุกขนาดหน้าจอ
- Professional loading states and feedback | สถานะการโหลดและการตอบกลับอย่างมืออาชีพ
- Intuitive navigation between pages | การนำทางระหว่างหน้าที่ใช้งานง่าย

## 🚀 Getting Started | เริ่มต้นใช้งาน

### Prerequisites | ข้อกำหนดเบื้องต้น

- Flutter SDK (^3.9.2)
- Dart SDK
- Android Studio / Xcode (for mobile development) | (สำหรับพัฒนามือถือ)
- Web browser (for web development) | เว็บเบราว์เซอร์ (สำหรับพัฒนาเว็บ)

### Installation | การติดตั้ง

1. **Clone the repository | โคลนที่เก็บโค้ด**

    ```bash
    git clone <repository-url>
    cd electronic_card_app
    ```

2. **Install dependencies | ติดตั้ง dependencies**

    ```bash
    flutter pub get
    ```

3. **Add required assets | เพิ่ม assets ที่จำเป็น**
    - Place `mini-logo.png` in `assets/images/` | วาง `mini-logo.png` ไว้ใน `assets/images/`
    - Add gallery images in `assets/images/gallery/` | เพิ่มรูปแกลลอรี่ใน `assets/images/gallery/`
    - Copy `.env.example` to `.env` and update API_BASE_URL | คัดลอก `.env.example` เป็น `.env` และอัปเดต API_BASE_URL
    - Update `pubspec.yaml` if adding new assets | อัปเดต `pubspec.yaml` หากเพิ่ม assets ใหม่

4. **Configure environment variables | ตั้งค่า environment variables**

    ```bash
    cp .env.example .env
    # Edit .env file and update API_BASE_URL to your server URL
    # แก้ไขไฟล์ .env และอัปเดต API_BASE_URL เป็น URL ของเซิร์ฟเวอร์
    ```

5. **Run the application | รันแอปพลิเคชัน**

    ```bash
    # For debug mode | สำหรับโหมดแก้ไขข้อผิดพลาด
    flutter run

    # For web | สำหรับเว็บ
    flutter run -d chrome

    # For specific device | สำหรับอุปกรณ์เฉพาะ
    flutter run -d <device-id>
    ```

## 📁 Project Structure | โครงสร้างโปรเจกต์

```
lib/
├── main.dart                 # App entry point & main wedding card | จุดเข้าแอปและการ์ดแต่งงานหลัก
├── splash_screen.dart        # App splash screen with animations | หน้าจอเปิดแอปพร้อมแอนิเมชัน
├── schedule.dart            # Wedding schedule page | หน้าตารางเวลางานแต่งงาน
├── gallery.dart             # Photo gallery page | หน้าแกลลอรี่รูปภาพ
├── wishes.dart              # Wishes submission form | ฟอร์มส่งคำอวยพร
├── thank_you_page.dart      # Thank you & wishes display page | หน้าขอบคุณและแสดงคำอวยพร
└── config/
    └── api_config.dart      # Global API configuration | การตั้งค่า API แบบ Global

.env                          # Environment variables (not committed) | ตัวแปร environment (ไม่ commit)
.env.example                  # Environment template | เทมเพลต environment
assets/
├── images/
│   ├── mini-logo.png        # App logo for splash screen | โลโก้แอปสำหรับหน้าจอเปิดแอป
│   └── gallery/             # Gallery photos | รูปภาพแกลลอรี่
└── icons/                   # App icons | ไอคอนแอป
```

## 🔧 Configuration | การตั้งค่า

### API Integration | การเชื่อมต่อ API

The app uses environment variables for API configuration. Update the `.env` file with your server details:
แอปใช้ environment variables สำหรับการตั้งค่า API อัปเดตไฟล์ `.env` ด้วยรายละเอียดของเซิร์ฟเวอร์:

```env
# .env file
API_BASE_URL=https://your-api-server.com/api
```

The API configuration is managed in `lib/config/api_config.dart` which automatically loads the base URL from environment variables:
การตั้งค่า API ถูกจัดการใน `lib/config/api_config.dart` ซึ่งจะโหลด base URL จาก environment variables อัตโนมัติ:

```dart
// lib/config/api_config.dart
class ApiConfig {
  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000/api';
}
```

### Template Colors | สีเทมเพลต

Customize the app colors by modifying the template color system in `thank_you_page.dart`:
ปรับแต่งสีของแอปโดยการแก้ไขระบบสีเทมเพลตใน `thank_you_page.dart`:

```dart
// Example template colors | ตัวอย่างสีเทมเพลต
final templateColors = {
  'primary': '#E8F4F0',
  'secondary': '#4A7C59',
  'accent': '#8B4513'
};
```

## 🎯 Key Features Implementation | การใช้งานฟีเจอร์หลัก

## 🎯 Key Features Implementation | การใช้งานฟีเจอร์หลัก

- **3D Flip Animation**: Custom AnimationController with Transform.rotate3D | แอนิเมชันพลิก 3D: AnimationController และ Transform.rotate3D กำหนดเอง
- **API Integration**: HTTP requests with multipart file upload | การเชื่อมต่อ API: คำขอ HTTP พร้อมการอัปโหลดไฟล์ multipart
- **Image Handling**: Cross-platform image picker and display | การจัดการรูปภาพ: ตัวเลือกและแสดงผลรูปข้ามแพลตฟอร์ม
- **Responsive Design**: MediaQuery-based responsive layouts | ดีไซน์ที่ตอบสนอง: เลย์เอาต์ที่ใช้ MediaQuery
- **State Management**: Efficient StatefulWidget architecture | การจัดการสถานะ: สถาปัตยกรรม StatefulWidget ที่มีประสิทธิภาพ
- **Error Handling**: Comprehensive error states and user feedback | การจัดการข้อผิดพลาด: สถานะข้อผิดพลาดและการตอบกลับผู้ใช้อย่างครบถ้วน

## 🚀 Build & Deploy | การ Build และ Deploy

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

## 🤝 Contributing | การร่วมพัฒนา

1. Fork the repository | Fork repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`) | สร้าง feature branch
3. Commit your changes (`git commit -m 'Add some amazing feature'`) | Commit การเปลี่ยนแปลง
4. Push to the branch (`git push origin feature/amazing-feature`) | Push ไปที่ branch
5. Open a Pull Request | เปิด Pull Request

## 📄 License | สิทธิ์การใช้งาน

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
โปรเจกต์นี้อยู่ภายใต้สิทธิ์ MIT License - ดูรายละเอียดในไฟล์ [LICENSE](LICENSE)

## 👥 Authors | ผู้เขียน

- **Developer** - Wedding Card App Team | นักพัฒนา - ทีมแอปการ์ดแต่งงาน

## 🙏 Acknowledgments | กิตติกรรมประกาศ

- Flutter team for the amazing framework | ทีม Flutter สำหรับเฟรมเวิร์กที่ยอดเยี่ยม
- Material Design for UI inspiration | Material Design สำหรับแรงบันดาลใจ UI
- Community packages that made this project possible | packages จากชุมชนที่ทำให้โปรเจกต์นี้เป็นไปได้

---

Built with ❤️ using Flutter | สร้างด้วย ❤️ โดยใช้ Flutter
