# 💒 Electronic Wedding Card App

A beautiful and performant Flutter web application for wedding invitations with an integrated wishes collection system. Optimized for fast loading and responsive across all devices.

## ✨ Features

- **Digital Wedding Invitation** - Beautiful animated wedding card with smooth transitions
- **Wedding Schedule** - Timeline of wedding events with location maps
- **Photo Gallery** - Optimized wedding photo gallery with timeline viewer
- **Wishes Collection** - Guests can send wishes with photo uploads
- **Thank You Page** - Beautiful display of collected wishes
- **Responsive Design** - Seamless experience on all devices
- **Thai Fonts** - Beautiful Thai typography using Google Fonts
- **Performance Optimized** - Image precaching and optimization for fast loading
- **Progressive Web App** - Can be installed on mobile devices

## 🏗️ Project Structure

```
lib/
├── pages/              # All page components
│   ├── gallery.dart    # Photo gallery with timeline
│   ├── schedule.dart   # Wedding schedule
│   ├── splash_screen.dart
│   ├── thank_you_page.dart
│   └── wishes.dart     # Wishes collection
├── config/             # Configuration files
│   └── api_config.dart
├── utils/              # Utility functions
│   └── utils.dart
├── main.dart           # App entry point
└── font_styles.dart    # Typography styles

assets/
├── images/             # Optimized images (67% size reduction)
│   ├── journey-of-us/  # Timeline photos (19MB total)
│   └── perview/        # Preview images
├── icons/              # App icons
└── fonts/              # Custom fonts

docs/                   # Documentation
scripts/                # Build and optimization scripts
.github/
├── workflows/          # CI/CD workflows
└── BRANCH_PROTECTION.md
```

## ⚡ Performance Optimizations

- **Image Optimization**: All images compressed (reduced from 58MB to 19MB)
- **Image Precaching**: Critical images loaded during splash screen
- **Nginx Caching**: Aggressive caching for static assets (7 days for images)
- **Gzip Compression**: Enabled for text-based files
- **Code Splitting**: Optimized Flutter web build
- **Lazy Loading**: Images loaded as needed

## 🚀 Quick Start

### Prerequisites

- Flutter SDK (3.9.2 or later)
- Dart SDK
- Git
- (Optional) ImageMagick for image optimization

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

### Development

```bash
# Run with hot reload
flutter run -d chrome

# Analyze code
flutter analyze

# Format code
dart format lib/

# Run tests
flutter test
```

## 🖼️ Image Optimization

Images are pre-optimized, but if you add new images:

```bash
# Run optimization script
./scripts/optimize-images.sh

# Rebuild
flutter clean
flutter build web --release
```

See [docs/IMAGE_OPTIMIZATION.md](docs/IMAGE_OPTIMIZATION.md) for details.

## 🌐 Deployment

### 🎯 Tag-Based Deployment (Recommended)

**Deployment triggers only when you create a version tag.**

#### Setup Steps:

1. **Get Fly.io API Token:**

    ```bash
    flyctl auth token
    ```

2. **Add GitHub Secrets:**
    - Go to GitHub repository → Settings → Secrets and variables → Actions
    - Create these secrets:
        - `FLY_API_TOKEN`: [your fly.io token]
        - `API_BASE_URL`: [your backend API URL] (optional)

3. **Deploy with version tag:**

    ```bash
    # Commit your changes
    git add .
    git commit -m "feat: Your feature description"
    git push origin main

    # Create and push version tag
    git tag -a v1.0.0 -m "Release version 1.0.0"
    git push origin v1.0.0
    ```

4. **Done!** 🎉 GitHub Actions will automatically:
    - Check assets integrity
    - Analyze code
    - Build Flutter web app
    - Deploy to Fly.io
    - Your app will be live at: https://ben-mae-the-wedding.fly.dev

#### Deployment Features:

- ✅ Triggered only on version tags (v\*)
- ✅ Automatic image optimization checks
- ✅ Code analysis before deploy
- ✅ Zero-downtime deployment
- ✅ Version tracking

---

### 🔧 Manual Deployment

For one-time deployments or local testing.

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

## � Technologies Used

- **Frontend**: Flutter Web
- **Language**: Dart 3.9.2
- **Fonts**: Google Fonts (Thai typography)
- **Image Optimization**: ImageMagick
- **Hosting**: Fly.io
- **CI/CD**: GitHub Actions
- **Web Server**: Nginx (Alpine)

### Key Dependencies

- `http`: API communication
- `shared_preferences`: Local storage
- `image_picker`: Photo uploads
- `url_launcher`: External links
- `google_fonts`: Typography
- `intl`: Date/time formatting

## 🔄 Development Workflow

### Branch Protection

This project uses PR-based workflow with branch protection:

1. **Create feature branch:**

    ```bash
    git checkout -b feature/my-feature
    # or
    git checkout -b fix/bug-description
    ```

2. **Make changes and commit:**

    ```bash
    git add .
    git commit -m "feat: Add new feature"
    git push origin feature/my-feature
    ```

3. **Create Pull Request:**
    - Go to GitHub repository
    - Click "Compare & pull request"
    - Fill in PR template
    - Wait for CI checks to pass
    - Request review (if required)

4. **After approval:**
    - Merge PR via GitHub UI
    - Branch protection ensures code quality

5. **Deploy to production:**

    ```bash
    # After merge, create version tag
    git checkout main
    git pull origin main
    git tag -a v1.0.1 -m "Release version 1.0.1"
    git push origin v1.0.1
    ```

### PR Template

Automatically populated when creating PRs:

- Description
- Type of change
- Testing checklist
- Screenshots
- Related issues

See [.github/pull_request_template.md](.github/pull_request_template.md)

### Branch Protection Rules

- ✅ Require pull request before merging
- ✅ Require status checks to pass
- ✅ Require conversation resolution
- ❌ No direct push to main
- ❌ No force push

See [.github/BRANCH_PROTECTION.md](.github/BRANCH_PROTECTION.md) for setup guide.

## 🚀 Deployment Options Comparison

| Feature           | Tag-Based Deploy       | Manual Deploy    |
| ----------------- | ---------------------- | ---------------- |
| **Trigger**       | Version tag (v\*)      | Manual command   |
| **Setup**         | One-time GitHub secret | Local Fly.io CLI |
| **Speed**         | ~5-7 minutes           | ~2-3 minutes     |
| **CI/CD**         | ✅ Full pipeline       | ❌ No CI         |
| **Rollback**      | Revert tag/commit      | Manual flyctl    |
| **Safeguards**    | ✅ Tests + Analysis    | ⚠️ Manual verify |
| **Best for**      | Production releases    | Development test |
| **Version Track** | ✅ Automatic           | ❌ Manual        |

## 📊 Monitoring & Health

### GitHub Actions

- View deployment status in Actions tab
- Get notified on failures
- See detailed build logs
- Track deployment time

### Fly.io Dashboard

```bash
# View real-time logs
flyctl logs

# Check app status
flyctl status

# Monitor metrics
flyctl dashboard
```

### Health Checks

- Endpoint: `/health`
- Auto-scaling enabled
- Zero-downtime deployments
- Automatic SSL/HTTPS

## 🛡️ Production Checklist

Before deploying:

- [x] Images optimized (67% reduction achieved)
- [x] Code analyzed and formatted
- [x] Branch protection enabled
- [x] CI/CD pipeline configured
- [ ] Production API_BASE_URL set
- [ ] Monitoring set up
- [ ] Custom domain configured (optional)
- [ ] HTTPS enabled (automatic with Fly.io)
- [ ] Backup strategy defined

## 🔧 Advanced Configuration

### Custom Domain

```bash
# Add custom domain
flyctl certs create yourdomain.com

# Follow DNS instructions
flyctl certs show yourdomain.com
```

### Scaling

```bash
# Scale instances
flyctl scale count 2

# Scale memory
flyctl scale memory 512
```

### Environment-Specific Builds

```bash
# Development
flutter build web --dart-define=ENV=dev

# Production
flutter build web --release --dart-define=ENV=prod
```

## 🆘 Troubleshooting

### Image Loading Issues

If images don't load on first visit:

```bash
# Re-optimize images
./scripts/optimize-images.sh

# Rebuild
flutter clean
flutter build web --release
```

### Deployment Failures

**GitHub Actions fails:**

- Check logs in Actions tab
- Verify FLY_API_TOKEN secret is set
- Ensure Flutter version compatibility

**Manual deploy fails:**

- Verify Fly.io CLI: `flyctl version`
- Re-authenticate: `flyctl auth login`
- Check app exists: `flyctl apps list`

### Performance Issues

```bash
# Analyze bundle size
flutter build web --analyze-size

# Check for large assets
du -sh build/web/assets/

# Verify nginx cache headers
curl -I https://your-app.fly.dev/assets/images/main-logo.png
```

### Build Issues

```bash
# Complete clean rebuild
rm -rf build
flutter clean
flutter pub get
flutter build web --release

# Verify no errors
flutter analyze
flutter test
```

## 📞 Support & Resources

- **Documentation**: `/docs` directory
- **Issues**: GitHub Issues tab
- **Image Optimization**: [docs/IMAGE_OPTIMIZATION.md](docs/IMAGE_OPTIMIZATION.md)
- **Branch Protection**: [.github/BRANCH_PROTECTION.md](.github/BRANCH_PROTECTION.md)
- **Fly.io Docs**: https://fly.io/docs

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
