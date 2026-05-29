# 🎬 FlickTV Premium — Flutter Onboarding UI

> **Assignment Submission · Nayan Thomas**
> A premium OTT (Over-The-Top) streaming app onboarding experience built entirely in Flutter, showcasing advanced animation choreography, a production-grade design system, and clean, modular architecture.

---

## 📸 Overview

FlickTV Premium is a single-screen Flutter application that delivers a cinematic, Netflix-inspired onboarding UI. The screen features a **multi-phase staggered animation sequence** driven by a single `AnimationController`, ensuring butter-smooth 60 fps performance even on mid-range devices.

---

## ✨ Key Features

| Feature | Details |
|---|---|
| 🎞️ **Staggered Animations** | 4 coordinated animation phases (Hero → Brand → Cards → Footer) driven by one `AnimationController` |
| 🎉 **Confetti Overlay** | Custom `CustomPainter` confetti burst synced to the animation timeline |
| 🌑 **Dark Design System** | Centralised `FlickColors`, `FlickTypography`, and `FlickSpacing` token classes |
| 📐 **Dot Grid Background** | Custom `CustomPainter` producing a subtle dot-grid texture |
| ⚡ **RepaintBoundary Isolation** | Every independent layer is wrapped in a `RepaintBoundary` to eliminate unnecessary rasterisation |
| 📳 **Haptic Feedback** | `HapticFeedback.lightImpact()` / `mediumImpact()` on button interactions |
| 🔒 **Portrait Lock** | `SystemChrome.setPreferredOrientations` enforces portrait-only mode |
| 💫 **Animated CTA Button** | `Matrix4.scaleByDouble` press-down feedback with gradient shift and shadow collapse |

---

## 🗂️ Project Structure

```
flicktv/
└── lib/
    ├── main.dart                          # App entry point, theme & orientation setup
    ├── core/
    │   ├── design_system.dart             # FlickColors, FlickSpacing, FlickTypography
    │   └── staggered_animation_engine.dart # Interval-based animation curve factory
    ├── screens/
    │   └── onboarding_screen.dart         # Full onboarding screen — State + build phases
    ├── widgets/
    │   ├── premium_hero_asset.dart        # Animated hero illustration widget
    │   └── value_feature_card.dart        # Reusable feature card (icon · badge · text)
    └── painters/
        ├── dot_grid_background_painter.dart  # Canvas dot-grid texture
        └── confetti_overlay_painter.dart     # Canvas confetti burst effect
```

---

## 🏗️ Architecture & Design Decisions

### 1. `StaggeredAnimationEngine`
A single `AnimationController` (2200 ms) is sliced into named `CurvedAnimation` intervals using `Interval`. Each UI phase (hero, brand text, cards, footer) gets its own opacity and slide animation — completely decoupled, zero `Timer` usage.

```
0 ms ──── 400 ms ──── 800 ms ──── 1200 ms ──── 1600 ms ──── 2200 ms
  [Settings]   [Hero]      [Brand Text]   [Cards 1-3]     [Footer]
```

### 2. `FlickDesignSystem` (Token Architecture)
All visual constants live in three `abstract final class` singletons — no magic numbers in widget code:
- **`FlickColors`** — full palette including confetti variants
- **`FlickSpacing`** — xs / sm / md / lg / xl / xxl / xxxl + radius constants
- **`FlickTypography`** — pre-defined `TextStyle` constants for all text roles

### 3. `RepaintBoundary` Strategy
Static layers (background, hero, cards) are each isolated behind a `RepaintBoundary`. Only the `AnimatedBuilder` at the root re-evaluates on each tick — static subtrees are never re-rasterised.

### 4. Custom Painters
- **`DotGridBackgroundPainter`** — draws an evenly-spaced dot grid on canvas for depth
- **`ConfettiOverlayPainter`** — seeds pseudo-random confetti particles using `progress` and `opacity` values from the animation engine

---

## 🚀 Getting Started

### Prerequisites

| Tool | Minimum Version |
|---|---|
| Flutter SDK | `^3.10.0` |
| Dart SDK | `^3.10.7` |
| Android Studio / VS Code | Latest stable |

### Run Locally

```bash
# 1. Clone or unzip the project
cd flicktv

# 2. Fetch dependencies
flutter pub get

# 3. Run on a connected device or emulator
flutter run
```

> **Tip:** Run `flutter devices` to list available targets. The app is optimised for Android but also supports iOS and Windows.

### Build Release APK

```bash
flutter build apk --release
```

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8   # iOS-style icon set

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0     # Lint rules for code quality
```

> All business logic and animation is achieved using **Flutter's built-in SDK only** — no third-party animation libraries.

---

## 🎨 Design System Reference

### Color Palette

| Token | Hex | Role |
|---|---|---|
| `background` | `#0A0A0A` | App / Scaffold background |
| `surface` | `#1A1A1A` | Card & button surface |
| `accent` | `#E50914` | Primary CTA (Cinematic Red) |
| `gold` | `#FFD700` | Premium badge highlight |
| `silver` | `#C0C0C0` | Secondary text & icons |
| `textPrimary` | `#FFFFFF` | Headlines |
| `textSecondary` | `#8A8A8A` | Body / descriptions |
| `textMuted` | `#555555` | Fine print |

### Typography Scale

| Style | Size | Weight | Use Case |
|---|---|---|---|
| `premiumTitle` | 42 sp | Black (900) | "PREMIUM" hero headline |
| `brandLabel` | 13 sp | Light (300) | "flicktv" sub-label |
| `cardHeadline` | 16 sp | Bold (700) | Feature card titles |
| `cardBody` | 13 sp | Regular (400) | Feature card descriptions |
| `buttonPrimary` | 16 sp | Bold (700) | Primary CTA label |
| `buttonSecondary` | 15 sp | Medium (500) | Secondary action label |
| `badgeLabel` | 9.5 sp | ExtraBold (800) | Pill badge text |

---

## 🧩 Component Breakdown

### `OnboardingScreen`
- Uses `SingleTickerProviderStateMixin`
- Orchestrates all 4 animation phases via `StaggeredAnimationEngine`
- Manages primary button press state (`Matrix4` scale transform)
- Handles `HapticFeedback` and `SystemChrome` UI overlay styling

### `PremiumHeroAsset`
- Self-contained animated hero illustration
- Designed to be composable and independently testable

### `ValueFeatureCard`
- Accepts `icon`, `badgeLabel`, `headline`, `description`, `badgeColor`, `iconColor`
- Fully stateless — all style driven by props
- Renders icon block + text column + coloured pill badge

---

## 📋 Assignment Checklist

- [x] Premium dark-mode UI with custom design system
- [x] Multi-phase staggered entry animations (4 phases, single controller)
- [x] Custom `CustomPainter` implementations (background + confetti)
- [x] `RepaintBoundary` performance optimisation
- [x] Haptic feedback integration
- [x] Modular folder structure (`core` / `screens` / `widgets` / `painters`)
- [x] Zero third-party animation dependencies
- [x] Portrait orientation lock
- [x] Clean, documented Dart code

---

## 👤 Author

**Nayan Thomas**
Flutter Developer

---

*Built with Flutter · Dart SDK `^3.10.7` · Assignment Submission 2026*
