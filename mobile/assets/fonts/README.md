# SmartHydro Fonts

SmartHydro sử dụng 2 font families chính:

## 1. Nunito (Headings & Titles)
- **Style:** Rounded, friendly, modern
- **Usage:** Display text, headings, titles
- **Download:** [Google Fonts - Nunito](https://fonts.google.com/specimen/Nunito)

### Required weights:
- Regular (400)
- Medium (500)
- SemiBold (600)
- Bold (700)

### Files cần download:
```
Nunito-Regular.ttf
Nunito-Medium.ttf
Nunito-SemiBold.ttf
Nunito-Bold.ttf
```

---

## 2. Inter (Body Text)
- **Style:** Clean, readable, professional
- **Usage:** Body text, labels, buttons
- **Download:** [Google Fonts - Inter](https://fonts.google.com/specimen/Inter)

### Required weights:
- Regular (400)
- Medium (500)
- SemiBold (600)
- Bold (700)

### Files cần download:
```
Inter-Regular.ttf
Inter-Medium.ttf
Inter-SemiBold.ttf
Inter-Bold.ttf
```

---

## Hướng dẫn cài đặt:

### Option 1: Google Fonts Package (Recommended)
Không cần download manual, sử dụng package `google_fonts`:

```yaml
# Add to pubspec.yaml
dependencies:
  google_fonts: ^6.1.0
```

Sau đó uncomment Google Fonts trong `app_theme.dart`.

### Option 2: Manual Download
1. Download fonts từ Google Fonts
2. Đặt file .ttf vào folder này (`assets/fonts/`)
3. Uncomment phần `fonts:` trong `pubspec.yaml`
4. Run `flutter pub get`
5. Restart app

---

## Current Status:
- ❌ Fonts chưa được cài đặt
- ⚠️ App hiện đang dùng system default fonts
- ✅ Theme đã được config sẵn, chỉ cần enable fonts

---

## Notes:
- Nunito: Rounded, san-serif (perfect cho mascot vibe)
- Inter: Neutral, highly legible (perfect cho data-heavy UI)
- Backup: System sẽ fallback sang default nếu fonts không tìm thấy

