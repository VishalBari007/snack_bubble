import 'package:flutter/material.dart';
import 'enums.dart';

/// Interactive action button attached to a [SnackBubbleWidget].
class SnackBubbleAction {
  /// Label text displayed on the action button.
  final String label;

  /// Callback executed when clicked.
  final VoidCallback onPressed;

  /// Optional custom background color.
  final Color? backgroundColor;

  /// Optional custom text color.
  final Color? textColor;

  const SnackBubbleAction({
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
  });
}

/// Optional avatar presentation for chat, team, and user-centric notifications.
class SnackBubbleAvatar {
  /// Network image URL.
  final String? imageUrl;

  /// Fallback initials (e.g. 'SC' for Sarah Connor).
  final String? initials;

  /// Fallback icon if no image or initials provided.
  final IconData? icon;

  /// Whether to render an active green status badge dot.
  final bool isOnline;

  /// Size diameter of the avatar.
  final double size;

  const SnackBubbleAvatar({
    this.imageUrl,
    this.initials,
    this.icon,
    this.isOnline = false,
    this.size = 38.0,
  });
}

/// Styling configuration for [SnackBubble].
class SnackBubbleStyle {
  /// Background color or translucent surface.
  final Color backgroundColor;

  /// Text color for message and title.
  final Color foregroundColor;

  /// Primary vibrant accent color for badge, icon, and progress.
  final Color accentColor;

  /// Optional border color.
  final Color? borderColor;

  /// Border width.
  final double borderWidth;

  /// Corner radius.
  final BorderRadius borderRadius;

  /// Blur intensity for glassmorphic frosted acrylic effect (0.0 disables blur).
  final double blurSigma;

  /// Multi-layer box shadows for realistic lighting depth.
  final List<BoxShadow>? shadows;

  /// Color of the countdown progress indicator.
  final Color? progressBarColor;

  /// Custom icon replacing default category icon.
  final IconData? icon;

  /// Custom text style for title.
  final TextStyle? titleStyle;

  /// Custom text style for message body.
  final TextStyle? messageStyle;

  /// Visual styling variant.
  final SnackBubbleVariant variant;

  /// Whether to render a soft ambient colored halo behind the card.
  final bool enableAmbientGlow;

  /// Custom ambient glow color. If null, derived from [accentColor].
  final Color? ambientGlowColor;

  const SnackBubbleStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.accentColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(22)),
    this.blurSigma = 18.0,
    this.shadows,
    this.progressBarColor,
    this.icon,
    this.titleStyle,
    this.messageStyle,
    this.variant = SnackBubbleVariant.glassmorphic,
    this.enableAmbientGlow = true,
    this.ambientGlowColor,
  });

  /// Factory constructor providing state-of-the-art presets for each [SnackBubbleType] and [SnackBubbleVariant].
  factory SnackBubbleStyle.fromType(
    SnackBubbleType type, {
    bool isDark = true,
    SnackBubbleVariant variant = SnackBubbleVariant.glassmorphic,
  }) {
    final Color accent;
    final IconData icon;

    switch (type) {
      case SnackBubbleType.success:
        accent = const Color(0xFF10B981); // Emerald
        icon = Icons.check_circle_rounded;
      case SnackBubbleType.error:
        accent = const Color(0xFFF43F5E); // Rose crimson
        icon = Icons.cancel_rounded;
      case SnackBubbleType.warning:
        accent = const Color(0xFFF59E0B); // Amber
        icon = Icons.warning_rounded;
      case SnackBubbleType.info:
        accent = const Color(0xFF0EA5E9); // Sky blue
        icon = Icons.info_rounded;
      case SnackBubbleType.neutral:
        accent = isDark ? const Color(0xFFA1A1AA) : const Color(0xFF52525B); // Zinc
        icon = Icons.notifications_rounded;
    }

    switch (variant) {
      case SnackBubbleVariant.glassmorphic:
        return SnackBubbleStyle(
          variant: variant,
          blurSigma: 20.0,
          enableAmbientGlow: true,
          backgroundColor: isDark
              ? const Color(0xD9141418) // Frosted Obsidian Zinc
              : const Color(0xEBFFFFFF), // Frosted Bright White
          foregroundColor: isDark ? const Color(0xFFFAFAFA) : const Color(0xFF09090B),
          accentColor: accent,
          borderColor: isDark
              ? const Color(0x2EFFFFFF) // Micro-glass refraction line
              : const Color(0x1F000000),
          borderWidth: 1.0,
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          shadows: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.40 : 0.14),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
          progressBarColor: accent,
          icon: icon,
        );

      case SnackBubbleVariant.neon:
        return SnackBubbleStyle(
          variant: variant,
          blurSigma: 14.0,
          enableAmbientGlow: true,
          backgroundColor: isDark ? const Color(0xF209090B) : const Color(0xF5FFFFFF),
          foregroundColor: isDark ? const Color(0xFFFFFFFF) : const Color(0xFF0F172A),
          accentColor: accent,
          borderColor: accent.withValues(alpha: isDark ? 0.7 : 0.85),
          borderWidth: 1.5,
          borderRadius: const BorderRadius.all(Radius.circular(22)),
          shadows: [
            BoxShadow(
              color: accent.withValues(alpha: isDark ? 0.45 : 0.22),
              blurRadius: 28,
              offset: const Offset(0, 4),
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.55 : 0.10),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
          progressBarColor: accent,
          icon: icon,
        );

      case SnackBubbleVariant.elevated:
        return SnackBubbleStyle(
          variant: variant,
          blurSigma: 0.0,
          enableAmbientGlow: false,
          backgroundColor: isDark ? const Color(0xFF202024) : Colors.white,
          foregroundColor: isDark ? Colors.white : const Color(0xFF18181B),
          accentColor: accent,
          borderColor: isDark ? const Color(0xFF333338) : const Color(0xFFE4E4E7),
          borderWidth: 1.0,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          shadows: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.12),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
          progressBarColor: accent,
          icon: icon,
        );

      case SnackBubbleVariant.minimal:
        return SnackBubbleStyle(
          variant: variant,
          blurSigma: 16.0,
          enableAmbientGlow: false,
          backgroundColor: isDark ? const Color(0xD909090B) : const Color(0xE6FFFFFF),
          foregroundColor: isDark ? Colors.white : const Color(0xFF09090B),
          accentColor: accent,
          borderColor: isDark ? const Color(0x26FFFFFF) : const Color(0x1A000000),
          borderWidth: 0.8,
          borderRadius: const BorderRadius.all(Radius.circular(32)), // Capsule
          shadows: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.22),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
          progressBarColor: accent,
          icon: icon,
        );
    }
  }

  SnackBubbleStyle copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? accentColor,
    Color? borderColor,
    double? borderWidth,
    BorderRadius? borderRadius,
    double? blurSigma,
    List<BoxShadow>? shadows,
    Color? progressBarColor,
    IconData? icon,
    TextStyle? titleStyle,
    TextStyle? messageStyle,
    SnackBubbleVariant? variant,
    bool? enableAmbientGlow,
    Color? ambientGlowColor,
  }) {
    return SnackBubbleStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      accentColor: accentColor ?? this.accentColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      blurSigma: blurSigma ?? this.blurSigma,
      shadows: shadows ?? this.shadows,
      progressBarColor: progressBarColor ?? this.progressBarColor,
      icon: icon ?? this.icon,
      titleStyle: titleStyle ?? this.titleStyle,
      messageStyle: messageStyle ?? this.messageStyle,
      variant: variant ?? this.variant,
      enableAmbientGlow: enableAmbientGlow ?? this.enableAmbientGlow,
      ambientGlowColor: ambientGlowColor ?? this.ambientGlowColor,
    );
  }
}
