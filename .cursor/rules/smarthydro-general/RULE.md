---
description: "SmartHydro project general rules - Core guidelines for the entire project"
globs:
alwaysApply: true
---

# SmartHydro Project General Rules

You are the Lead Developer for **SmartHydro** - a hydration tracking mobile app.

## Project Context

- **Project Name:** SmartHydro - Ứng dụng Theo dõi & Tối ưu Hóa Việc Uống Nước
- **Tech Stack:** Flutter (Mobile) | Next.js (Web Admin/Blog) | Supabase (Backend)
- **Slogan:** "Hydration tuned to your biology."

## Core Philosophy

### Product Philosophy: "Adaptive & Empathic"
- **Adaptive:** App never static. Water goals change based on weather and activity. Don't force users to follow fixed numbers.
- **Empathic:** App understands context. Don't disturb when sleeping or just drank. Never blame when users forget, only encourage.

### Design Philosophy: "Fluid & Organic"
- **Fluidity:** All movements must be smooth like water. Avoid sharp edges, use curves (large border-radius).
- **Clarity:** Information must be clear, easy to read, not cluttered - like pure water.

## Key Features (Reference @docs/SRS.md)

1. **Dynamic Goal:** Water target changes in real-time based on:
   - Weather (temperature, humidity)
   - Activity (from HealthKit/Google Fit)
   - Biology (pregnancy, breastfeeding)

2. **BHI (Beverage Hydration Index):** Not all drinks hydrate equally:
   - Water: 1.0
   - Milk/Coconut water: 1.1-1.15
   - Coffee/Tea: 0.85-0.90
   - Alcohol: 0.5

3. **Smart Notifications:**
   - Silent Period: 90 mins after logging
   - No notifications during sleep hours
   - Context-aware messages

4. **Gamification:**
   - Buddy character "Puru" reflects hydration status
   - Streaks, Challenges, Badges
   - Skin unlocks

## Non-Negotiables

- App must open in < 1.5 seconds
- Log water function must work 100% Offline
- Max 8 notifications per day
- All actions must have instant feedback (visual or haptic)

## Tone & Microcopy

- **Tone:** Smart, Witty, Scientific but Accessible
- **Don't:** "Error! You haven't drunk water." (Rigid)
- **Do:** "Puru is getting thirsty, give them a sip!" (Metaphor)
- **Don't:** "Drink 200ml."
- **Do:** "Refuel 200ml." or "Treat yourself to a glass."

## Documentation References

Always refer to these documents for detailed specifications:
- `@docs/SRS.md` - Software Requirements Specification
- `@docs/TECH_STACK.md` - Technology Stack Details
- `@docs/BLUEPRINT.md` - System Blueprint
- `@docs/VISUAL_DESIGN.md` - Visual Design System

## Code Quality Standards

- Follow Clean Architecture principles
- Separate UI and Logic
- Write unit tests for Hydration Engine (health-related calculations)
- All icons must be from the same set (consistent style)
- TypeScript/Dart strict mode enabled

