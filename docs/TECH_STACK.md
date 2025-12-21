# 🛠️ SMARTHYDRO TECH STACK

**Dự án:** SmartHydro
**Phiên bản:** 1.2
**Mô hình:** Client-Serverless Hybrid (Offline-first)
**Độ phức tạp:** Trung bình-Cao - Yêu cầu xử lý Offline, Realtime Sync, Animation và Gamification.

---

## 1. MOBILE APPLICATION (CLIENT)

*Nền tảng chính để người dùng tương tác.*

### 1.1. Core Framework

| Hạng mục | Công nghệ | Version | Lý do lựa chọn |
|----------|-----------|---------|----------------|
| **Framework** | **Flutter** | 3.x+ | Hiệu năng 60fps, UI giống hệt trên iOS/Android, animation mượt mà |
| **Language** | **Dart** | 3.x+ | AOT compilation (nhanh), JIT (hot reload), null-safety |
| **State Management** | **Riverpod** | 2.x | Compile-safe, test dễ dàng, không boilerplate nhiều như Bloc |
| **Navigation** | **GoRouter** | 12.x+ | Deep Link tốt, cần thiết khi mở app từ Widget/Notification |

### 1.2. Data & Storage

| Hạng mục | Package | Lý do lựa chọn |
|----------|---------|----------------|
| **Local Database** | \`isar\` (v3.x) | **Offline-first**, NoSQL siêu nhanh, query mạnh mẽ |
| **Secure Storage** | \`flutter_secure_storage\` | Mã hóa AES-256 cho dữ liệu nhạy cảm (health data) |
| **Cache Images** | \`cached_network_image\` | Cache ảnh bài viết, avatar, giảm bandwidth |
| **Environment** | \`flutter_dotenv\` | Quản lý API keys, config theo môi trường (dev/prod) |

### 1.3. Health & Sensors Integration

| Hạng mục | Package | Lý do lựa chọn |
|----------|---------|----------------|
| **Health Data** | \`health\` | All-in-one: Apple Health (iOS), Google Fit (Android) |
| **Permissions** | \`permission_handler\` | Request quyền Health, Location, Notification |
| **Location** | \`geolocator\` | Lấy vị trí để call Weather API |
| **Connectivity** | \`connectivity_plus\` | Detect online/offline để trigger sync |

### 1.4. Notifications & Background

| Hạng mục | Package | Lý do lựa chọn |
|----------|---------|----------------|
| **Local Notifications** | \`flutter_local_notifications\` | Schedule nhắc nhở offline, không cần server push |
| **Background Tasks** | \`workmanager\` | Sync queue khi có mạng, reset daily goal lúc 00:00 |
| **Timezone** | \`timezone\` | Xử lý múi giờ chính xác cho notifications |

### 1.5. UI/UX & Animation

| Hạng mục | Package | Lý do lựa chọn |
|----------|---------|----------------|
| **Animation Core** | \`flutter_animate\` | Declarative animations, dễ chain effects |
| **Lottie** | \`lottie\` | Chạy animation phức tạp (Buddy, water effects) |
| **Confetti** | \`confetti\` | Celebration effect khi đạt 100% goal |
| **Charts** | \`fl_chart\` | Line chart, Pie chart, responsive, customizable |
| **Calendar Heatmap** | \`flutter_heatmap_calendar\` | Streak calendar như GitHub contributions |
| **Haptic** | \`haptic_feedback\` | Rung nhẹ khi log nước thành công |
| **3D Rendering** | \`vector_math\` | 3D matrix transforms, lighting calculations cho Puru mascot |
| **Physics Engine** | Custom implementation | Soft-body/Jelly physics cho Puru mascot |

### 1.6. Widget & Platform Integration

| Hạng mục | Package | Lý do lựa chọn |
|----------|---------|----------------|
| **Home Widget** | \`home_widget\` | Widget màn hình chính cho iOS 17+/Android |
| **Share** | \`share_plus\` | Chia sẻ bài viết, achievements lên social |
| **URL Launcher** | \`url_launcher\` | Mở link nguồn trích dẫn trong Science Hub |
| **Device Info** | \`device_info_plus\` | Thu thập device info cho analytics/debug |

### 1.7. Internationalization (i18n)

| Hạng mục | Package | Lý do lựa chọn |
|----------|---------|----------------|
| **Localization** | \`easy_localization\` | Hỗ trợ đa ngôn ngữ (VI, EN), hot reload translations |
| **Intl** | \`intl\` | Format số, ngày tháng, tiền tệ theo locale |

### 1.8. Phase 3-4 (Future)

| Hạng mục | Package | Phase |
|----------|---------|-------|
| **PDF Generation** | \`pdf\` + \`printing\` | Phase 3 - Health Report |
| **NFC** | \`nfc_manager\` | Phase 4 - NFC Tag logging |
| **Speech/Voice** | \`speech_to_text\` | Phase 4 - Voice command |

---

## 2. WEB APPLICATION (ADMIN & BLOG)

*Nền tảng quản trị và cung cấp kiến thức khoa học.*

### 2.1. Core Framework

| Hạng mục | Công nghệ | Version | Lý do lựa chọn |
|----------|-----------|---------|----------------|
| **Framework** | **Next.js** (App Router) | 15.x+ | SEO tốt cho Blog, Server Components, Turbopack, Vercel deploy |
| **Language** | **TypeScript** | 5.x | Type Safety chặt chẽ với Database schema |
| **Runtime** | **Node.js** | 22.x LTS | Stable, long-term support |
| **Package Manager** | **pnpm** | 9.x | Nhanh, tiết kiệm disk, strict dependency management |

### 2.2. UI & Styling

| Hạng mục | Package | Version | Lý do lựa chọn |
|----------|---------|---------|----------------|
| **UI Library** | \`shadcn/ui\` | Latest | Components đẹp, copy-paste, tùy biến cao |
| **CSS Framework** | \`Tailwind CSS\` | 4.x | CSS-first config, native CSS variables, Lightning CSS engine |
| **Icons** | \`lucide-react\` | Latest | Icon set nhất quán với shadcn |
| **Animation** | \`motion\` | 11.x | Page transitions, micro-interactions (successor của framer-motion) |

#### Tailwind CSS v4 - CSS-First Configuration

Tailwind v4 sử dụng **CSS-first configuration** thay vì file JavaScript:

\`\`\`css
/* app/globals.css */
@import "tailwindcss";

@theme {
  /* SmartHydro Brand Colors */
  --color-hydro-start: #2AF598;
  --color-hydro-end: #009EFD;
  --color-deep-ocean: #051E3E;
  --color-science: #651FFF;
  
  /* Typography */
  --font-sans: "Inter", system-ui, sans-serif;
  --font-heading: "Nunito", system-ui, sans-serif;
  
  /* Border Radius - Fluid Design */
  --radius-3xl: 2rem;
  --radius-pill: 9999px;
}
\`\`\`

**Lợi ích Tailwind v4:**
- ⚡ Lightning CSS engine - biên dịch nhanh hơn 10x
- 🎨 Native CSS variables - tương thích tốt với CSS ecosystem
- 📦 Không cần \`tailwind.config.js\` - config trong CSS
- 🔥 Tích hợp tốt với React 19 và Next.js 15

### 2.3. State & Data

| Hạng mục | Package | Lý do lựa chọn |
|----------|---------|----------------|
| **State Management** | \`zustand\` | Lightweight, đơn giản hơn Redux |
| **Data Fetching** | \`@tanstack/react-query\` | Cache, refetch, optimistic updates |
| **Form Handling** | \`react-hook-form\` | Performance tốt, ít re-render |
| **Validation** | \`zod\` | Schema validation, type-safe |

### 2.4. Content & Editor

| Hạng mục | Package | Lý do lựa chọn |
|----------|---------|----------------|
| **Rich Text Editor** | \`@tiptap/react\` | Headless, extensible, hỗ trợ markdown |
| **Image Upload** | \`react-dropzone\` | Drag & drop images |
| **Date Handling** | \`date-fns\` | Lightweight date utilities |

### 2.5. Charts & Analytics (Admin Dashboard)

| Hạng mục | Package | Lý do lựa chọn |
|----------|---------|----------------|
| **Charts** | \`recharts\` | React-friendly, responsive charts |
| **Tables** | \`@tanstack/react-table\` | Sorting, filtering, pagination |

---

## 3. BACKEND & INFRASTRUCTURE (BaaS)

*Hạ tầng Serverless - Không cần quản lý máy chủ.*

### 3.1. Core Platform: Supabase

| Hạng mục | Service | Lý do lựa chọn |
|----------|---------|----------------|
| **Database** | **PostgreSQL** (v15+) | RDBMS mạnh mẽ, JSONB support, full-text search |
| **Authentication** | **Supabase Auth** | Social Login (Google, Apple), Magic Link, JWT |
| **File Storage** | **Supabase Storage** | Avatar, thumbnails, Buddy assets |
| **Realtime** | **Supabase Realtime** | Sync data across devices instantly |
| **Security** | **RLS (Row Level Security)** | Policy-based security tại DB level |
| **Edge Functions** | **Deno/TypeScript** | Cron jobs, webhooks, email triggers |

### 3.2. Database Schema Mapping (từ SRS)

\`\`\`
┌─────────────────────────────────────────────────────────┐
│                    SUPABASE TABLES                       │
├─────────────────────────────────────────────────────────┤
│  Core:                                                   │
│  ├── users (profile, settings)                          │
│  ├── water_logs (hydration tracking)                    │
│  └── daily_goals (dynamic goals per day)                │
│                                                          │
│  Gamification:                                           │
│  ├── streaks (user streaks)                             │
│  ├── challenges (challenge definitions)                 │
│  ├── user_challenges (user progress)                    │
│  └── buddy_status (skins, badges, points)               │
│                                                          │
│  Content:                                                │
│  ├── science_articles (blog posts)                      │
│  └── notification_templates (message templates)         │
└─────────────────────────────────────────────────────────┘
\`\`\`

### 3.3. Edge Functions (Cron Jobs)

| Function | Schedule | Mô tả |
|----------|----------|-------|
| \`reset-daily-goals\` | 00:00 daily | Tạo DailyGoal mới, update streak |
| \`fetch-weather\` | Mỗi 3 giờ | Cache weather data cho users active |
| \`send-inactive-reminder\` | 09:00 daily | Email users inactive > 3 ngày |
| \`generate-weekly-report\` | Monday 08:00 | Tạo weekly summary notification |

---

## 4. 3RD PARTY APIS & SERVICES

### 4.1. Weather Data

| Service | Plan | Usage |
|---------|------|-------|
| **OpenWeatherMap** | Free/Starter | Temperature, humidity để điều chỉnh Dynamic Goal |

*Alternative: WeatherAPI.com, Tomorrow.io*

### 4.2. Analytics & Monitoring

| Service | Platform | Usage |
|---------|----------|-------|
| **Firebase Analytics** | Mobile | User behavior, feature usage, retention |
| **Google Analytics 4** | Web | Blog traffic, SEO metrics |
| **Firebase Crashlytics** | Mobile | Crash reports, ANR detection |
| **Sentry** | Both | Error tracking với context đầy đủ hơn Crashlytics |

### 4.3. Push Notifications (Future - Scale)

| Service | Usage |
|---------|-------|
| **Firebase Cloud Messaging** | Push notifications khi cần server-triggered |
| **OneSignal** | Alternative với dashboard tốt hơn |

*Note: MVP dùng Local Notifications, chỉ cần FCM khi scale.*

---

## 5. DEVOPS & CI/CD

### 5.1. Source Control & Collaboration

| Tool | Usage |
|------|-------|
| **GitHub** | Source control, Issues, PR reviews |
| **GitHub Projects** | Task management, Kanban board |

### 5.2. CI/CD Pipelines (GitHub Actions)

#### Mobile Pipeline

\`\`\`yaml
# .github/workflows/mobile.yml
name: Mobile CI/CD

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test --coverage

  build-android:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - run: flutter build apk --release
      - uses: wzieba/Firebase-Distribution-Github-Action@v1
        # Upload to Firebase App Distribution

  build-ios:
    needs: test
    runs-on: macos-latest
    steps:
      - run: flutter build ipa --release
      # Upload to TestFlight
\`\`\`

#### Web Pipeline

\`\`\`yaml
# .github/workflows/web.yml
name: Web CI/CD

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v4
        with:
          version: 9
      - uses: actions/setup-node@v4
        with:
          node-version: '22'
          cache: 'pnpm'
          cache-dependency-path: 'web/pnpm-lock.yaml'
      - run: pnpm install --frozen-lockfile
        working-directory: ./web
      - run: pnpm run build
        working-directory: ./web
      # Auto-deploy to Vercel via integration
\`\`\`

### 5.3. Hosting & Deployment

| Platform | Service | Usage |
|----------|---------|-------|
| **Vercel** | Web Hosting | Next.js app (Admin + Blog) |
| **Google Play Console** | Android | Production releases |
| **Apple App Store Connect** | iOS | Production releases |
| **Firebase App Distribution** | Both | Beta testing |

### 5.4. Environment Management

\`\`\`
├── .env.development     (Local dev)
├── .env.staging         (Testing)
├── .env.production      (Production)
└── .env.example         (Template for team)

Variables:
- SUPABASE_URL
- SUPABASE_ANON_KEY
- OPENWEATHER_API_KEY
- SENTRY_DSN
\`\`\`

---

## 6. TESTING STRATEGY

### 6.1. Flutter Testing

| Type | Tool | Coverage Target |
|------|------|-----------------|
| **Unit Tests** | \`flutter_test\` + \`mocktail\` | 80%+ business logic |
| **Widget Tests** | \`flutter_test\` | Critical UI components |
| **Integration Tests** | \`integration_test\` | Happy paths, E2E |
| **Golden Tests** | \`golden_toolkit\` | UI regression |

### 6.2. Web Testing

| Type | Tool | Coverage Target |
|------|------|-----------------|
| **Unit Tests** | \`vitest\` | Utility functions |
| **Component Tests** | \`@testing-library/react\` | UI components |
| **E2E Tests** | \`@playwright/test\` | Critical user flows |

### 6.3. API Testing

| Tool | Usage |
|------|-------|
| **Postman/Insomnia** | Manual API testing |
| **Supabase Test Helpers** | Database testing with RLS |

---

## 7. SECURITY CONSIDERATIONS

### 7.1. Mobile Security

| Concern | Solution |
|---------|----------|
| **Sensitive Data** | \`flutter_secure_storage\` (Keychain/Keystore) |
| **API Keys** | Không hardcode, dùng \`.env\` + obfuscation |
| **Network** | Certificate pinning cho production |
| **Code** | ProGuard (Android), bitcode (iOS) |

### 7.2. Backend Security

| Concern | Solution |
|---------|----------|
| **Authorization** | Supabase RLS policies |
| **Data Isolation** | User chỉ access data của mình |
| **Rate Limiting** | Supabase built-in + Edge Function middleware |
| **Audit Log** | PostgreSQL triggers cho sensitive operations |

### 7.3. Compliance

| Standard | Implementation |
|----------|----------------|
| **GDPR** | Data export, deletion API, consent tracking |
| **CCPA** | Do-not-sell flag, data transparency |
| **Health Data** | Không share với 3rd party, encrypted at rest |

---

## 8. MÔ HÌNH KIẾN TRÚC CODE

### 8.1. Flutter (Clean Architecture + Feature-first)

\`\`\`
lib/
├── main.dart
├── src/
│   ├── app/                      # App-level config
│   │   ├── app.dart
│   │   └── router.dart
│   │
│   ├── features/                 # Feature modules
│   │   ├── auth/
│   │   │   ├── data/            # Repositories, DTOs
│   │   │   ├── domain/          # Entities, Use cases
│   │   │   └── presentation/    # Screens, Widgets, Controllers
│   │   │
│   │   ├── hydration/           # Core water tracking
│   │   │   ├── data/
│   │   │   │   ├── repositories/
│   │   │   │   ├── datasources/
│   │   │   │   └── models/
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   ├── repositories/
│   │   │   │   └── usecases/
│   │   │   └── presentation/
│   │   │       ├── screens/
│   │   │       ├── widgets/
│   │   │       └── providers/
│   │   │
│   │   ├── gamification/        # Buddy, Challenges, Streaks
│   │   ├── notifications/       # Smart reminders
│   │   ├── science_hub/         # Blog articles
│   │   └── settings/            # User preferences
│   │
│   ├── core/                    # Shared utilities
│   │   ├── constants/
│   │   ├── errors/
│   │   ├── extensions/
│   │   ├── services/            # Weather, Health services
│   │   └── utils/
│   │
│   └── shared/                  # Shared UI
│       ├── widgets/
│       └── theme/
│
├── assets/
│   ├── animations/              # Lottie files
│   ├── images/
│   └── translations/            # i18n JSON files
│
└── test/
    ├── unit/
    ├── widget/
    └── integration/
\`\`\`

### 8.2. Next.js (App Router + Modular)

\`\`\`
web/
├── app/
│   ├── (admin)/                     # Protected admin routes
│   │   ├── dashboard/
│   │   │   └── page.tsx
│   │   ├── articles/
│   │   │   ├── page.tsx            # List articles
│   │   │   ├── new/page.tsx        # Create article
│   │   │   └── [id]/page.tsx       # Edit article
│   │   ├── notifications/
│   │   │   └── page.tsx            # Manage templates
│   │   └── layout.tsx              # Admin layout with sidebar
│   │
│   ├── (public)/                    # Public routes
│   │   ├── blog/
│   │   │   ├── page.tsx            # Blog listing
│   │   │   └── [slug]/page.tsx     # Article detail (SEO)
│   │   └── layout.tsx
│   │
│   ├── globals.css                  # Tailwind v4 CSS-first config
│   ├── layout.tsx
│   └── page.tsx
│
├── components/
│   ├── ui/                      # Shadcn components
│   ├── admin/                   # Admin-specific
│   └── blog/                    # Blog-specific
│
├── lib/
│   ├── supabase/
│   │   ├── client.ts           # Browser client
│   │   ├── server.ts           # Server client
│   │   └── admin.ts            # Service role client
│   ├── utils/
│   └── validations/            # Zod schemas
│
├── hooks/                       # Custom React hooks
├── stores/                      # Zustand stores
├── types/                       # TypeScript types (shared with DB)
│
├── package.json
├── pnpm-lock.yaml              # pnpm lockfile
├── postcss.config.mjs          # PostCSS với @tailwindcss/postcss
├── tsconfig.json
└── middleware.ts               # Auth middleware
\`\`\`

---

## 9. DEPENDENCY VERSIONS (package.json / pubspec.yaml)

### 9.1. Flutter Dependencies

\`\`\`yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State & Architecture
  flutter_riverpod: ^2.4.9
  go_router: ^13.0.0
  
  # Storage
  isar: ^3.1.0
  isar_flutter_libs: ^3.1.0
  flutter_secure_storage: ^9.0.0
  
  # Supabase
  supabase_flutter: ^2.3.0
  
  # Health & Sensors
  health: ^10.0.0
  permission_handler: ^11.1.0
  geolocator: ^10.1.0
  connectivity_plus: ^5.0.2
  
  # Notifications
  flutter_local_notifications: ^16.3.0
  workmanager: ^0.5.2
  timezone: ^0.9.2
  
  # UI/UX
  flutter_animate: ^4.3.0
  lottie: ^3.0.0
  confetti: ^0.7.0
  fl_chart: ^0.66.0
  flutter_heatmap_calendar: ^1.0.5
  haptic_feedback: ^0.5.1+1
  cached_network_image: ^3.3.1
  
  # 3D Rendering & Physics
  vector_math: ^2.1.4
  
  # Utils
  easy_localization: ^3.0.3
  intl: ^0.19.0
  share_plus: ^7.2.1
  url_launcher: ^6.2.2
  device_info_plus: ^9.1.1
  flutter_dotenv: ^5.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  mocktail: ^1.0.1
  golden_toolkit: ^0.15.0
  isar_generator: ^3.1.0
  build_runner: ^2.4.8
\`\`\`

### 9.2. Next.js Dependencies (pnpm)

\`\`\`json
{
  "name": "smarthydro-web",
  "version": "1.0.0",
  "private": true,
  "packageManager": "pnpm@9.15.1",
  "scripts": {
    "dev": "next dev --turbopack",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "type-check": "tsc --noEmit"
  },
  "dependencies": {
    "next": "^15.1.3",
    "react": "^19.0.0",
    "react-dom": "^19.0.0",
    "@supabase/supabase-js": "^2.47.10",
    "@supabase/ssr": "^0.5.2",
    
    "tailwindcss": "^4.0.0",
    "@tailwindcss/postcss": "^4.0.0",
    "class-variance-authority": "^0.7.1",
    "clsx": "^2.1.1",
    "tailwind-merge": "^2.6.0",
    "lucide-react": "^0.469.0",
    
    "zustand": "^5.0.2",
    "@tanstack/react-query": "^5.62.8",
    "react-hook-form": "^7.54.2",
    "zod": "^3.24.1",
    "@hookform/resolvers": "^3.9.1",
    
    "@tiptap/react": "^2.11.2",
    "@tiptap/starter-kit": "^2.11.2",
    "@tiptap/extension-image": "^2.11.2",
    "@tiptap/extension-link": "^2.11.2",
    "date-fns": "^4.1.0",
    "recharts": "^2.15.0",
    "@tanstack/react-table": "^8.20.6",
    "motion": "^11.15.0",
    
    "@radix-ui/react-slot": "^1.1.1",
    "@radix-ui/react-dialog": "^1.1.4",
    "@radix-ui/react-dropdown-menu": "^2.1.4",
    "@radix-ui/react-label": "^2.1.1",
    "@radix-ui/react-select": "^2.1.4",
    "@radix-ui/react-tabs": "^1.1.2",
    "@radix-ui/react-toast": "^1.2.4"
  },
  "devDependencies": {
    "typescript": "^5.7.2",
    "@types/node": "^22.10.2",
    "@types/react": "^19.0.2",
    "@types/react-dom": "^19.0.2",
    "eslint": "^9.17.0",
    "eslint-config-next": "^15.1.3",
    "vitest": "^2.1.8",
    "@testing-library/react": "^16.1.0",
    "@playwright/test": "^1.49.1"
  }
}
\`\`\`

### 9.3. PostCSS Config (Tailwind v4)

\`\`\`javascript
// postcss.config.mjs
export default {
  plugins: {
    "@tailwindcss/postcss": {},
  },
};
\`\`\`

---

## 10. MASCOT COLLECTION SYSTEM

### 10.1. Architecture

SmartHydro sử dụng **Mascot Collection System** - cho phép user chọn và thay đổi mascot:

| Component | Implementation | Purpose |
|-----------|----------------|---------|
| **Mascot Registry** | `mascot_registry.dart` | Single Source of Truth cho tất cả mascots |
| **Mascot Factory** | `mascot_factory.dart` | Factory Pattern tạo CustomPainter cho từng mascot |
| **Mascot Models** | `mascot_models.dart` | Domain models (MascotType, MascotInfo, UnlockCondition) |
| **Mascot Providers** | `mascot_providers.dart` | Riverpod providers cho state management |
| **Mascot Gallery** | `mascot_gallery_screen.dart` | UI cho collection gallery |

### 10.2. Mascot Painters

| Mascot | Painter Class | Style | Rarity |
|--------|--------------|-------|--------|
| Classic Puru | `PuruClassicPainter` | Original, Beloved | Common (Default) |
| Celestial Drop | `PuruCelestialV2Painter` | Soft glow, glitter | Rare (7-day streak) |
| Aqua-Axo | `PuruAxoV2Painter` | Pet-like, cute | Rare (seasonal) |
| Liquid Chibi-Bot | `PuruChibiBotV2Painter` | Tech, holographic | Epic (Health connect) |
| + 7 more | TBD | Various | Various |

### 10.3. Unlock Mechanics

```dart
enum UnlockCondition {
  DefaultUnlock,          // Có sẵn
  StreakUnlock(days),     // Đạt X ngày streak
  HealthConnectUnlock,    // Kết nối Health app
  SeasonalUnlock,         // Theo mùa
  EventUnlock,            // Event đặc biệt
  PremiumUnlock(price),   // Mua IAP
}
```

### 10.4. Benefits

- **User Engagement:** Tăng 3-5x retention
- **Personalization:** Mỗi user có mascot riêng
- **Monetization:** Premium mascots, Mascot Pass
- **Long-term Value:** Luôn có content mới (thêm mascots mỗi tháng)

---

## 11. ĐÁNH GIÁ TỔNG QUAN

### 10.1. Ưu điểm

| Aspect | Benefit |
|--------|---------|
| **Tốc độ phát triển** | Rất nhanh - Supabase loại bỏ 40% backend work, Flutter viết 1 chạy 2 |
| **Chi phí vận hành** | Thấp - Free tiers đủ cho 10,000+ users đầu |
| **Scalability** | Supabase scale theo PostgreSQL, không bottleneck |
| **Offline-first** | Isar + WorkManager đảm bảo UX mượt mà |
| **Type Safety** | Dart + TypeScript đồng bộ types với DB |
| **Modern Web Stack** | React 19 + Next.js 15 + Tailwind v4 = DX tuyệt vời |

### 10.2. Chi phí ước tính (Monthly)

| Service | Free Tier | Pro Tier (Scale) |
|---------|-----------|------------------|
| Supabase | 500MB DB, 1GB Storage | \$25/month |
| Vercel | 100GB bandwidth | \$20/month |
| OpenWeatherMap | 1000 calls/day | \$40/month |
| Firebase | Generous free | Pay-as-you-go |
| **Total MVP** | **\$0** | ~\$85/month |

### 10.3. Rủi ro & Mitigation

| Risk | Mitigation |
|------|------------|
| Vendor lock-in (Supabase) | PostgreSQL chuẩn → Export & migrate dễ dàng |
| Flutter performance | Profile thường xuyên, lazy loading, tree shaking |
| Offline sync conflicts | Last-Write-Wins + user notification |
| API rate limits | Caching, request batching, fallback data |

---

## 11. CHECKLIST TRƯỚC KHI BẮT ĐẦU

### Development Setup

- [ ] Flutter SDK 3.x installed
- [ ] Node.js 22.x LTS installed
- [ ] pnpm 9.x installed (\`npm install -g pnpm\`)
- [ ] Supabase project created
- [ ] OpenWeatherMap API key
- [ ] Firebase project (Analytics, Crashlytics)
- [ ] GitHub repo với branch protection
- [ ] \`.env\` files configured
- [ ] CI/CD pipelines setup

### Web Development

\`\`\`bash
# Setup web project
cd web
pnpm install
pnpm dev
\`\`\`

### Design Assets

- [ ] Figma/Design files ready
- [ ] Lottie animations (Buddy states, water effects)
- [ ] App icons (iOS, Android)
- [ ] Splash screen assets

### Legal & Compliance

- [ ] Privacy Policy draft
- [ ] Terms of Service draft
- [ ] Apple Health usage description
- [ ] Google Fit scopes defined

---

*Tech Stack này được thiết kế để **đồng bộ 100%** với SRS v1.2, đảm bảo mọi chức năng đều có giải pháp kỹ thuật phù hợp.*
