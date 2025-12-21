# 💧 SmartHydro

**Hydration tuned to your biology.**

SmartHydro là ứng dụng theo dõi và tối ưu hóa việc uống nước, với mục tiêu động được điều chỉnh dựa trên sinh học và môi trường của bạn.

## 📱 Features

### Core Features (MVP)
- ✅ **Dynamic Goal Calculation** - Mục tiêu nước thay đổi theo tuổi, cân nặng, thời tiết và vận động
- ✅ **BHI (Beverage Hydration Index)** - Tính toán hydration thực tế cho từng loại đồ uống
- ✅ **Smart Notifications** - Nhắc nhở thông minh với Silent Period
- ✅ **Offline-first** - Hoạt động 100% offline, sync khi có mạng

### Enhanced Features
- 🎮 **Gamification** - Puru buddy, challenges, achievements
- 📊 **Analytics** - Biểu đồ thống kê, streak calendar
- 📚 **Science Hub** - Blog kiến thức khoa học về hydration
- ⌚ **Widgets** - Home screen widgets cho iOS & Android

## 🛠️ Tech Stack

| Platform | Technology |
|----------|------------|
| Mobile | Flutter 3.x + Riverpod |
| Web | Next.js 14 + Tailwind CSS |
| Backend | Supabase (PostgreSQL + Auth + Storage) |
| CI/CD | GitHub Actions |

## 📁 Project Structure

```
Water-tracking/
├── mobile/                # Flutter mobile app
│   ├── lib/
│   │   ├── src/
│   │   │   ├── app/       # App configuration, router
│   │   │   ├── features/  # Feature modules
│   │   │   ├── core/      # Shared utilities
│   │   │   └── shared/    # Shared UI, theme
│   │   └── main.dart
│   └── pubspec.yaml
├── web/                   # Next.js web app
│   ├── app/
│   │   ├── (admin)/       # Admin dashboard
│   │   └── (public)/      # Science Hub blog
│   └── package.json
├── supabase/             # Database migrations
│   └── migrations/
├── docs/                 # Documentation
│   ├── SRS.md            # Software Requirements
│   ├── TECH_STACK.md     # Technology Stack
│   ├── BLUEPRINT.md      # System Blueprint
│   └── VISUAL_DESIGN.md  # Visual Design System
└── .github/workflows/    # CI/CD pipelines
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.x
- Node.js 20.x LTS
- Supabase account

### Mobile Development

```bash
cd mobile
flutter pub get
flutter run
```

### Web Development

```bash
cd web
npm install
npm run dev
```

### Database Setup

1. Create a Supabase project
2. Run migrations in `supabase/migrations/`
3. Configure environment variables

## 🔑 Environment Variables

### Mobile (.env)
```
SUPABASE_URL=your-project-url
SUPABASE_ANON_KEY=your-anon-key
OPENWEATHER_API_KEY=your-api-key
```

### Web (.env.local)
```
NEXT_PUBLIC_SUPABASE_URL=your-project-url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
```

## 📖 Documentation

- [Software Requirements (SRS)](docs/SRS.md)
- [Technology Stack](docs/TECH_STACK.md)
- [System Blueprint](docs/BLUEPRINT.md)
- [Visual Design System](docs/VISUAL_DESIGN.md)

## 🎨 Design Philosophy

- **Adaptive & Empathic** - App thích ứng với bạn, không áp đặt
- **Fluid & Organic** - Giao diện mượt mà như nước
- **Zero-Friction Logging** - 1-tap để log nước

## 🧪 Testing

```bash
# Mobile
cd mobile && flutter test

# Web
cd web && npm test
```

## 📝 License

Copyright © 2025 SmartHydro. All rights reserved.

