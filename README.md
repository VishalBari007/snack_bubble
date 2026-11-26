<p align="center">
  <h1 align="center">✨ snack_bubble</h1>
  <p align="center">
    <strong>State-of-the-art, physics-driven toast & notification bubbles for Flutter applications.</strong>
  </p>
</p>

<p align="center">
  <a href="https://pub.dev/packages/snack_bubble"><img src="https://img.shields.io/pub/v/snack_bubble.svg" alt="Pub Version"></a>
  <a href="https://pub.dev/packages/snack_bubble/score"><img src="https://img.shields.io/pub/points/snack_bubble" alt="Pub Points"></a>
  <a href="https://pub.dev/packages/snack_bubble"><img src="https://img.shields.io/pub/likes/snack_bubble" alt="Pub Likes"></a>
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.19+-02569B?logo=flutter&logoColor=white" alt="Flutter"></a>
  <a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart&logoColor=white" alt="Dart"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License: MIT"></a>
  <a href="https://github.com/VishalBari007/snack_bubble"><img src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg" alt="PRs Welcome"></a>
</p>

---

## 💎 Features

- 🪟 **True Frosted Glass Acrylic**: Live real-time `BackdropFilter` with micro-glass reflection border and multi-layer ambient lighting.
- ✨ **Fluid Animated Drawing Icons**: Dynamic custom stroke-drawn checkmark (`_CheckmarkPainter`), cross (`_CrossPainter`), warning pulse, and bell shake with elastic spring pop. Toggle between `SnackBubbleIconStyle.animated` and `SnackBubbleIconStyle.simple`.
- 🌓 **Full Adaptive Theme Support**: Built-in support for Light mode, Dark mode, and System auto-detection with bespoke color palettes and shadow contrasts for each.
- 🌟 **Ambient Halo Glow**: Soft diffused backlight halo behind the bubble matching the semantic accent color for an ultra-modern aesthetic.
- ⏸️ **Touch-To-Pause Physics**: Holding down any bubble automatically pauses the auto-dismiss timer and scales the bubble down with tactile spring response (`0.97` scale). Releasing resumes countdown seamlessly.
- 👤 **Social & Team Avatars (`SnackBubbleAvatar`)**: Built-in support for user profile pictures, initials, and active online status indicator dots.
- ⚡ **Dynamic Island & Dock Motion**: Smooth spring entrance and exit curves powered by `Curves.easeOutBack` & `Curves.easeOutCubic`.
- 📳 **Haptic Touch Engine**: Integrated subtle tactile vibration feedback on appearance, press, and dismiss.
- ⏳ **Glowing Countdown Bar**: Sleek gradient linear progress bar reflecting remaining view duration with a luminous glowing cap.
- 🔘 **Interactive Action Buttons**: Attach stylish action buttons directly inside the toast (*"Undo"*, *"Retry"*, *"View Logs"*).
- 🎨 **4 Designer Variants**:
  - `SnackBubbleVariant.glassmorphic` (Frosted glass with light borders)
  - `SnackBubbleVariant.neon` (Vibrant electric glow borders & deep shadows)
  - `SnackBubbleVariant.elevated` (Deep solid card for maximum contrast)
  - `SnackBubbleVariant.minimal` (Ultra-compact floating capsule)
- 🎯 **Zero External Dependencies**: Pure, blazing-fast Flutter framework implementation.

---

## 📦 Installation

Add `snack_bubble` to your `pubspec.yaml`:

```yaml
dependencies:
  snack_bubble: ^0.0.1
```

Or run:

```bash
flutter pub add snack_bubble
```

---

## 🚀 Usage

### 1. Simple Notification

```dart
import 'package:snack_bubble/snack_bubble.dart';

// Emerald Success Notification
SnackBubble.showSuccess(
  context,
  title: 'Deployment Live',
  message: 'Release v3.0 is live across 28 global regions.',
);
```

### 2. Social Avatar Notification

```dart
SnackBubble.showAvatar(
  context,
  senderName: 'Sarah Connor',
  message: 'Shared "DesignSystem_v4.fig" with editor access.',
  avatar: const SnackBubbleAvatar(
    initials: 'SC',
    isOnline: true,
  ),
  action: SnackBubbleAction(
    label: 'Reply',
    onPressed: () => openChat(),
  ),
);
```

### 3. Actionable Toast with Callback

```dart
SnackBubble.showError(
  context,
  title: 'Payment Declined',
  message: 'Invoice #9281 could not be processed.',
  action: SnackBubbleAction(
    label: 'Retry',
    onPressed: () {
      SnackBubble.hide();
      retryPayment();
    },
  ),
);
```

### 4. Fully Customized Bubble

```dart
SnackBubble.show(
  context,
  title: 'Cloud Sync Paused',
  message: 'You have 3 local modifications waiting for sync.',
  type: SnackBubbleType.warning,
  variant: SnackBubbleVariant.glassmorphic,
  position: SnackBubblePosition.top, // or SnackBubblePosition.bottom
  duration: const Duration(seconds: 5),
  showProgressBar: true,
  enableHaptics: true,
  pauseOnTouch: true, // Freezes timer when pressed
  action: SnackBubbleAction(
    label: 'Sync Now',
    onPressed: () => syncFiles(),
  ),
);
```

---

## 📱 SnackBubble Interactive Playground

A complete, production-ready interactive example application showcasing **SnackBubble** is included in the `example/` directory.

To run the interactive playground on your phone or emulator:

```bash
cd example
flutter run
```

---

## 🧪 Testing

```bash
flutter test
flutter analyze
```

---

## 📄 License

Distributed under the MIT License. See [LICENSE](LICENSE) for details.
