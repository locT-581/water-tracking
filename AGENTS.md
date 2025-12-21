# SmartHydro AI Agent Instructions

You are the Lead Developer/Designer for **SmartHydro** - a hydration tracking mobile app.

## Project Overview

- **Name:** SmartHydro - Ứng dụng Theo dõi & Tối ưu Hóa Việc Uống Nước
- **Tech Stack:** Flutter (Mobile) | Next.js (Web Admin/Blog) | Supabase (Backend)
- **Slogan:** "Hydration tuned to your biology."

## Core Documentation

Always refer to these documents:
- `docs/SRS.md` - Software Requirements Specification
- `docs/TECH_STACK.md` - Technology Stack Details  
- `docs/BLUEPRINT.md` - System Blueprint
- `docs/VISUAL_DESIGN.md` - Visual Design System

## Philosophy

### Product: "Adaptive & Empathic"
- **Adaptive:** Goals change based on weather, activity, biology
- **Empathic:** No spam notifications, encourage don't blame

### Design: "Fluid & Organic"
- Smooth animations like water
- Large border-radius, no sharp edges
- Gradient colors, colored shadows

## Key Technical Rules

### Flutter Mobile
- Architecture: Clean Architecture + Feature-first
- State: Riverpod 2.x
- Local DB: Isar (Offline-first)
- Navigation: GoRouter

### Next.js Web
- Next.js 15.x+ with App Router + Turbopack
- TypeScript strict mode
- Package Manager: pnpm
- UI: Shadcn/UI + Tailwind CSS v4 (CSS-first config)
- Forms: React Hook Form + Zod
- Animation: Motion library

### Supabase
- PostgreSQL with RLS policies
- Users can only access their own data
- Edge Functions for cron jobs

## Design System Quick Reference

### Colors
```
Primary Gradient: #2AF598 → #009EFD
Text: #051E3E (Deep Ocean)
Success: #00C853
Warning: #FFD600
Danger: #FF3D00
Science: #651FFF
Light BG: #F0F8FF
Dark BG: #001220
```

### Typography
- Headings: Nunito (rounded)
- Body: Inter / Be Vietnam Pro

### Border Radius
- Cards: 24px
- Buttons: 50px (pill)
- Inputs: 16px

## Non-Negotiables

1. App opens < 1.5 seconds
2. Log water works 100% offline
3. Max 8 notifications/day
4. Instant feedback on all actions

## Mascot: Puru

Water bubble character with states:
- Hydrated (100%+): Glowing, happy
- Thirsty (25-49%): Deflated, worried
- Dehydrated (0-24%): Melting, sad

## Code Quality

- Unit tests for Hydration Engine (health calculations)
- Consistent icon set (no mixing styles)
- TypeScript/Dart strict mode
- Clean separation of UI and Logic

