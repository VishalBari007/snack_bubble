/// The functional type / intent of the snack bubble.
enum SnackBubbleType {
  /// Green emerald accent for successful operations.
  success,

  /// Crimson rose accent for errors and failures.
  error,

  /// Amber golden accent for warnings and alerts.
  warning,

  /// Cyan azure accent for informational notices.
  info,

  /// Sleek neutral slate accent for standard notifications.
  neutral,
}

/// Aesthetic visual styling variant.
enum SnackBubbleVariant {
  /// Frosted glass acrylic effect with background blur and micro-shimmer border.
  glassmorphic,

  /// Rich solid card with deep ambient soft shadows.
  elevated,

  /// Modern neon glow border and vibrant accent lighting.
  neon,

  /// Ultra-minimalist compact capsule with clean typography.
  minimal,
}

/// Icon rendering mode: animated spring drawing or clean static icon.
enum SnackBubbleIconStyle {
  /// Fluid animated entrance (drawing checkmark, pop shake, or pulse).
  animated,

  /// Clean, traditional static icon.
  simple,
}

/// The screen position where the snack bubble appears.
enum SnackBubblePosition {
  /// Appears floating at the top of the screen (below SafeArea).
  top,

  /// Appears floating at the bottom of the screen (above SafeArea).
  bottom,
}
