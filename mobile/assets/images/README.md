# SmartHydro App Icons & Images

## 📱 App Icon Requirements

### iOS Icons
Place in `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

| Size | Filename | Purpose |
|------|----------|---------|
| 1024x1024 | Icon-App-1024x1024@1x.png | App Store |
| 180x180 | Icon-App-60x60@3x.png | iPhone (3x) |
| 120x120 | Icon-App-60x60@2x.png | iPhone (2x) |
| 167x167 | Icon-App-83.5x83.5@2x.png | iPad Pro |
| 152x152 | Icon-App-76x76@2x.png | iPad |
| 76x76 | Icon-App-76x76@1x.png | iPad (1x) |
| 120x120 | Icon-App-40x40@3x.png | Spotlight (3x) |
| 80x80 | Icon-App-40x40@2x.png | Spotlight (2x) |
| 40x40 | Icon-App-40x40@1x.png | Spotlight (1x) |
| 87x87 | Icon-App-29x29@3x.png | Settings (3x) |
| 58x58 | Icon-App-29x29@2x.png | Settings (2x) |
| 29x29 | Icon-App-29x29@1x.png | Settings (1x) |
| 60x60 | Icon-App-20x20@3x.png | Notification (3x) |
| 40x40 | Icon-App-20x20@2x.png | Notification (2x) |
| 20x20 | Icon-App-20x20@1x.png | Notification (1x) |

### Android Icons
Place in respective drawable folders:

| Size | Folder | Purpose |
|------|--------|---------|
| 192x192 | drawable-xxxhdpi | Launcher (4x) |
| 144x144 | drawable-xxhdpi | Launcher (3x) |
| 96x96 | drawable-xhdpi | Launcher (2x) |
| 72x72 | drawable-hdpi | Launcher (1.5x) |
| 48x48 | drawable-mdpi | Launcher (1x) |
| 512x512 | - | Play Store |

### Web Icons
Place in `web/icons/`

| Size | Filename | Purpose |
|------|----------|---------|
| 512x512 | Icon-512.png | PWA icon (large) |
| 192x192 | Icon-192.png | PWA icon (medium) |
| 512x512 | Icon-maskable-512.png | Maskable icon (large) |
| 192x192 | Icon-maskable-192.png | Maskable icon (medium) |

---

## 🎨 Design Guidelines

### App Icon Design:
- **Primary Element:** Water drop shape
- **Colors:** Hydration gradient (#2AF598 → #009EFD)
- **Style:** Rounded, modern, clean
- **Background:** Gradient or solid color
- **No text:** Icon should be recognizable without text

### Recommended Design:
```
┌─────────────────┐
│   ╱╲           │  Gradient background
│  ╱  ╲          │  (#2AF598 → #009EFD)
│ │ 💧 │         │
│  ╲  ╱          │  Water drop icon
│   ╲╱           │  (white or light blue)
└─────────────────┘
```

### Color Palette:
- Primary: #2AF598 (Hydro Green)
- Secondary: #009EFD (Hydro Blue)
- Accent: #FFFFFF (White)
- Shadow: Use colored shadows for depth

---

## 🛠️ Tools for Icon Generation

### Option 1: Online Tools (Easiest)
- [AppIcon.co](https://appicon.co/) - Generate all sizes from one image
- [Icon Kitchen](https://icon.kitchen/) - Android adaptive icons
- [Figma](https://figma.com/) - Design custom icon

### Option 2: Flutter Package
```yaml
# Add to pubspec.yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

# Create flutter_launcher_icons.yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/icon.png"
  adaptive_icon_foreground: "assets/icon/foreground.png"
  adaptive_icon_background: "#2AF598"
```

Then run:
```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

### Option 3: Manual Design
1. Create 1024x1024 PNG in design tool (Figma, Sketch, Illustrator)
2. Export at 1x size
3. Use ImageMagick to resize:
```bash
# Install ImageMagick
brew install imagemagick

# Resize for all sizes
for size in 20 29 40 58 60 76 80 87 120 152 167 180 1024; do
  convert icon-1024.png -resize ${size}x${size} icon-${size}.png
done
```

---

## 📸 Splash Screen

### Requirements:
- **Size:** 1242x2688 (iPhone Pro Max)
- **Design:** Simple, branded, fast-loading
- **Background:** Hydration gradient
- **Logo:** Centered, 200-300px
- **Duration:** < 2 seconds (guideline)

### Recommended Layout:
```
┌───────────────────┐
│                   │  Gradient background
│                   │  (#001220 → #051E3E)
│                   │
│      ╱╲          │
│     ╱  ╲         │  Logo (white)
│    │ 💧 │        │  200x200px
│     ╲  ╱         │
│      ╲╱          │
│                   │
│   SmartHydro      │  App name (white)
│                   │
└───────────────────┘
```

### Implementation:
Use `flutter_native_splash` package:
```yaml
dev_dependencies:
  flutter_native_splash: ^2.3.0

flutter_native_splash:
  color: "#001220"
  image: assets/splash/logo.png
  android_12:
    image: assets/splash/logo.png
    color: "#001220"
```

---

## ✅ Current Status

- [ ] App icon designed (1024x1024)
- [ ] iOS icons generated
- [ ] Android icons generated
- [ ] Web icons generated
- [ ] Splash screen designed
- [ ] Splash screen implemented
- [ ] Icons tested on devices

---

## 📝 Notes

### Placeholder Icons
Currently using default Flutter icons. Replace with custom SmartHydro icons before release.

### Testing
Test icons on:
- Real iOS device (check rounded corners)
- Real Android device (check adaptive icon)
- Light and dark mode home screens
- Different device sizes

### Accessibility
- Icon should be clear at small sizes
- High contrast between icon and background
- Avoid fine details that don't scale well

