---
description: "UI/UX visual design rules following SmartHydro design system"
globs: ["**/*.dart", "**/*.tsx", "**/*.css", "**/theme/**", "**/styles/**"]
alwaysApply: false
---

# SmartHydro Visual Design System

Follow this design system for all UI development. Reference: `@docs/VISUAL_DESIGN.md`

## Design Concept

- **Concept:** "Liquid Life" (Sự sống lỏng)
- **Emotion:** Clear, Soft, Trustworthy, Fresh
- **Philosophy:** "Fluid & Organic"

## Color Palette

### Primary Colors (Gradient-based)
```css
/* Hydro Blue Gradient - Primary CTA, Progress, Puru body */
--hydro-gradient: linear-gradient(135deg, #2AF598 0%, #009EFD 100%);
--hydro-start: #2AF598;  /* Turquoise - Fresh, Vitality */
--hydro-end: #009EFD;    /* Ocean Blue - Depth, Trust */

/* Deep Ocean - Text & Elements (instead of pure black) */
--deep-ocean: #051E3E;
```

### Functional Colors
```css
--success: #00C853;      /* Green - Goal complete */
--warning: #FFD600;      /* Amber - Mild dehydration */
--danger: #FF3D00;       /* Red-Orange - Severe dehydration */
--science: #651FFF;      /* Violet - Blog/Knowledge */
```

### Background Colors
```css
/* Light Mode */
--bg-light: #F0F8FF;     /* Alice Blue - Very light blue tint */

/* Dark Mode */
--bg-dark: #001220;      /* Deep night blue */
/* Note: In dark mode, blue elements should have neon glow effect */
```

## Typography

### Font Families
```css
/* Headings - Rounded Sans-serif */
--font-heading: 'Nunito', sans-serif;

/* Body Text - Modern, Vietnamese support */
--font-body: 'Inter', 'Be Vietnam Pro', sans-serif;
```

### Font Sizes (Mobile)
```css
--text-xs: 12px;
--text-sm: 14px;
--text-base: 16px;
--text-lg: 18px;
--text-xl: 20px;
--text-2xl: 24px;
--text-3xl: 30px;
--text-4xl: 36px;    /* Main water amount display */
--text-5xl: 48px;    /* Hero numbers */
```

## Spacing & Sizing

### Border Radius
```css
--radius-sm: 8px;
--radius-md: 16px;
--radius-lg: 24px;      /* Cards, containers */
--radius-xl: 32px;
--radius-full: 50px;    /* Pill buttons */
--radius-circle: 9999px;
```

### Shadows (Colored Shadows)
```css
/* Instead of black shadows, use colored shadows matching the element */
--shadow-blue: 0 10px 20px -10px rgba(0, 158, 253, 0.5);
--shadow-green: 0 10px 20px -10px rgba(42, 245, 152, 0.5);

/* Example usage */
.primary-button {
  box-shadow: var(--shadow-blue);
}
```

## Glassmorphism

```css
/* Light Mode Glass */
.glass-light {
  background: rgba(255, 255, 255, 0.7);
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.2);
}

/* Dark Mode Glass */
.glass-dark {
  background: rgba(0, 18, 32, 0.6);
  backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.1);
}
```

## Iconography

- **Style:** Filled + Soft outline
- **Corners:** All corners must be rounded (4px - 8px corner radius)
- **No sharp edges** - Icons should feel organic like water
- **Recommended:** Lucide React (web), Flutter's rounded icons (mobile)

## Component Specifications

### Buttons
```css
/* Primary Button */
.btn-primary {
  background: linear-gradient(135deg, #2AF598 0%, #009EFD 100%);
  border-radius: 50px;  /* Pill shape */
  padding: 16px 32px;
  color: white;
  font-weight: 600;
  box-shadow: 0 10px 20px -10px rgba(0, 158, 253, 0.5);
}

/* Secondary Button */
.btn-secondary {
  background: transparent;
  border: 2px solid #009EFD;
  border-radius: 50px;
  color: #009EFD;
}
```

### Cards
```css
.card {
  background: white;
  border-radius: 24px;
  padding: 20px;
  box-shadow: 0 4px 20px rgba(5, 30, 62, 0.08);
}
```

### Input Fields
```css
.input {
  border-radius: 16px;
  border: 2px solid #E5E7EB;
  padding: 16px 20px;
}

.input:focus {
  border-color: #009EFD;
  box-shadow: 0 0 0 4px rgba(0, 158, 253, 0.1);
}
```

## Puru (Mascot) States

| State | Description | Color | Expression |
|-------|-------------|-------|------------|
| **Hydrated** (100%+) | Glowing, bouncy | Bright blue gradient | Happy, closed eyes smile |
| **Good** (75-99%) | Normal, content | Normal blue | Gentle smile |
| **Okay** (50-74%) | Slightly deflated | Lighter blue | Neutral |
| **Thirsty** (25-49%) | Deflated | Grayish blue | Worried |
| **Dehydrated** (0-24%) | Melting | Purple-gray | Sad, SOS sign |
| **Sleeping** | Zzz animation | Dim blue | Peaceful |

## Animation Guidelines

### Water Fill Animation
```dart
// Flutter example
AnimatedContainer(
  duration: Duration(milliseconds: 800),
  curve: Curves.elasticOut,  // Bouncy water effect
  height: waterLevel * maxHeight,
)
```

### Micro-interactions
- **Tap feedback:** Ripple effect + haptic
- **Log success:** Water splash animation + confetti
- **Goal complete:** Puru jumps + confetti burst
- **Loading:** Puru drinking animation (not spinning circle)
- **Pull-to-refresh:** Water droplet stretches and drops

### Transition Curves
```dart
// Smooth, water-like movements
Curves.easeInOutCubic  // Default for most transitions
Curves.elasticOut      // For bouncy effects (water fill, Puru)
Curves.easeOutBack     // For items appearing
```

## Screen-Specific Guidelines

### Home Screen (Dashboard)
- Background changes with time of day (morning/afternoon/evening gradient)
- Center: Large progress ring with fluid simulation inside
- Puru floats/swims on the water surface
- Weather indicator in top-left corner
- FAB at bottom center with pulse animation when behind schedule

### Logging Overlay
- Glassmorphism sheet sliding from bottom
- Grid of beverage icons (3D-style, rounded)
- Vertical slider for amount (with water splash sounds conceptually)
- Show BHI percentage under each beverage icon

### Statistics Screen
- Card-based layout
- Charts with rounded bar caps or wave-style area charts
- Color-coded by beverage type
- Insight cards with Puru reactions

### Science Hub
- Pinterest/Masonry grid layout
- Large rounded thumbnails
- Pastel category tags
- "X min read" indicator
- Highlight important text with yellow marker effect

## Flutter Implementation

```dart
// Theme data
ThemeData smartHydroTheme = ThemeData(
  primaryColor: Color(0xFF009EFD),
  scaffoldBackgroundColor: Color(0xFFF0F8FF),
  fontFamily: 'Inter',
  textTheme: TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'Nunito',
      fontSize: 48,
      fontWeight: FontWeight.bold,
      color: Color(0xFF051E3E),
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Inter',
      fontSize: 16,
      color: Color(0xFF051E3E),
    ),
  ),
  cardTheme: CardTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
    elevation: 0,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: StadiumBorder(),
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    ),
  ),
);

// Gradient decoration
BoxDecoration hydroGradient = BoxDecoration(
  gradient: LinearGradient(
    colors: [Color(0xFF2AF598), Color(0xFF009EFD)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
);
```

## Tailwind CSS Implementation (Next.js)

```javascript
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        hydro: {
          start: '#2AF598',
          end: '#009EFD',
        },
        'deep-ocean': '#051E3E',
        success: '#00C853',
        warning: '#FFD600',
        danger: '#FF3D00',
        science: '#651FFF',
      },
      backgroundImage: {
        'hydro-gradient': 'linear-gradient(135deg, #2AF598 0%, #009EFD 100%)',
      },
      borderRadius: {
        '3xl': '24px',
        '4xl': '32px',
      },
      fontFamily: {
        heading: ['Nunito', 'sans-serif'],
        body: ['Inter', 'Be Vietnam Pro', 'sans-serif'],
      },
      boxShadow: {
        'hydro': '0 10px 20px -10px rgba(0, 158, 253, 0.5)',
      },
    },
  },
};
```

