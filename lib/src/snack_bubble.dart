import 'package:flutter/material.dart';
import 'enums.dart';
import 'snack_bubble_overlay.dart';
import 'snack_bubble_style.dart';

/// Top-level controller for launching high-end floating snack bubbles anywhere in your Flutter app.
class SnackBubble {
  static OverlayEntry? _currentEntry;

  /// Returns true if a snack bubble is currently visible.
  static bool get isVisible => _currentEntry != null;

  /// Displays an ultra-premium floating snack bubble.
  ///
  /// [context]: Current BuildContext.
  /// [message]: Primary description text.
  /// [title]: Optional bold headline.
  /// [type]: Semantic category preset ([SnackBubbleType.success], [SnackBubbleType.error], etc.).
  /// [variant]: Visual style ([SnackBubbleVariant.glassmorphic], [SnackBubbleVariant.neon], etc.).
  /// [position]: Location on screen ([SnackBubblePosition.top] or [SnackBubblePosition.bottom]).
  /// [duration]: Visible duration before auto-dismissal. Set [Duration.zero] for persistent.
  /// [showProgressBar]: Whether to render the sleek countdown bar.
  /// [showCloseButton]: Whether to display a close button when no custom action exists.
  /// [enableHaptics]: Triggers subtle vibration feedback on display, touch, and dismiss.
  /// [pauseOnTouch]: Freezes the countdown timer and scales down when the user holds their finger down.
  /// [iconStyle]: Animated drawing icon or simple static icon.
  /// [avatar]: Optional circular avatar with online status badge.
  /// [action]: Optional action pill button (e.g. "Undo", "Retry").
  /// [style]: Custom styling overrides.
  /// [leading]: Optional widget replacing leading icon badge.
  /// [trailing]: Optional custom trailing widget.
  /// [margin]: Outer margin around the bubble.
  /// [onTap]: Callback when the bubble body is clicked.
  static void show(
    BuildContext context, {
    required String message,
    String? title,
    SnackBubbleType type = SnackBubbleType.neutral,
    SnackBubbleVariant variant = SnackBubbleVariant.glassmorphic,
    SnackBubblePosition position = SnackBubblePosition.top,
    Duration duration = const Duration(seconds: 4),
    bool showProgressBar = true,
    bool showCloseButton = true,
    bool enableHaptics = true,
    bool pauseOnTouch = true,
    SnackBubbleIconStyle iconStyle = SnackBubbleIconStyle.animated,
    SnackBubbleAvatar? avatar,
    SnackBubbleAction? action,
    SnackBubbleStyle? style,
    Widget? leading,
    Widget? trailing,
    EdgeInsetsGeometry margin = const EdgeInsets.symmetric(horizontal: 16),
    VoidCallback? onTap,
  }) {
    hide();

    final overlay = Overlay.maybeOf(context);
    if (overlay == null) {
      debugPrint('SnackBubble Warning: No Overlay found in the provided context.');
      return;
    }

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => SnackBubbleOverlay(
        title: title,
        message: message,
        type: type,
        variant: variant,
        position: position,
        style: style,
        avatar: avatar,
        leading: leading,
        action: action,
        trailing: trailing,
        onTap: onTap,
        duration: duration,
        showProgressBar: showProgressBar,
        showCloseButton: showCloseButton,
        enableHaptics: enableHaptics,
        pauseOnTouch: pauseOnTouch,
        iconStyle: iconStyle,
        margin: margin,
        onDismiss: () {
          if (_currentEntry == entry) {
            _currentEntry?.remove();
            _currentEntry = null;
          }
        },
      ),
    );

    _currentEntry = entry;
    overlay.insert(entry);
  }

  /// Convenience method to display a success notification.
  static void showSuccess(
    BuildContext context, {
    required String message,
    String? title = 'Success',
    SnackBubbleVariant variant = SnackBubbleVariant.glassmorphic,
    SnackBubblePosition position = SnackBubblePosition.top,
    Duration duration = const Duration(seconds: 4),
    bool showProgressBar = true,
    bool enableHaptics = true,
    SnackBubbleIconStyle iconStyle = SnackBubbleIconStyle.animated,
    SnackBubbleStyle? style,
    SnackBubbleAction? action,
    VoidCallback? onTap,
  }) {
    show(
      context,
      title: title,
      message: message,
      type: SnackBubbleType.success,
      variant: variant,
      position: position,
      duration: duration,
      showProgressBar: showProgressBar,
      enableHaptics: enableHaptics,
      iconStyle: iconStyle,
      style: style,
      action: action,
      onTap: onTap,
    );
  }

  /// Convenience method to display an error notification.
  static void showError(
    BuildContext context, {
    required String message,
    String? title = 'Error',
    SnackBubbleVariant variant = SnackBubbleVariant.glassmorphic,
    SnackBubblePosition position = SnackBubblePosition.top,
    Duration duration = const Duration(seconds: 5),
    bool showProgressBar = true,
    bool enableHaptics = true,
    SnackBubbleIconStyle iconStyle = SnackBubbleIconStyle.animated,
    SnackBubbleStyle? style,
    SnackBubbleAction? action,
    VoidCallback? onTap,
  }) {
    show(
      context,
      title: title,
      message: message,
      type: SnackBubbleType.error,
      variant: variant,
      position: position,
      duration: duration,
      showProgressBar: showProgressBar,
      enableHaptics: enableHaptics,
      iconStyle: iconStyle,
      style: style,
      action: action,
      onTap: onTap,
    );
  }

  /// Convenience method to display a warning notification.
  static void showWarning(
    BuildContext context, {
    required String message,
    String? title = 'Warning',
    SnackBubbleVariant variant = SnackBubbleVariant.glassmorphic,
    SnackBubblePosition position = SnackBubblePosition.top,
    Duration duration = const Duration(seconds: 4),
    bool showProgressBar = true,
    bool enableHaptics = true,
    SnackBubbleIconStyle iconStyle = SnackBubbleIconStyle.animated,
    SnackBubbleStyle? style,
    SnackBubbleAction? action,
    VoidCallback? onTap,
  }) {
    show(
      context,
      title: title,
      message: message,
      type: SnackBubbleType.warning,
      variant: variant,
      position: position,
      duration: duration,
      showProgressBar: showProgressBar,
      enableHaptics: enableHaptics,
      iconStyle: iconStyle,
      style: style,
      action: action,
      onTap: onTap,
    );
  }

  /// Convenience method to display an informational notification.
  static void showInfo(
    BuildContext context, {
    required String message,
    String? title = 'Info',
    SnackBubbleVariant variant = SnackBubbleVariant.glassmorphic,
    SnackBubblePosition position = SnackBubblePosition.top,
    Duration duration = const Duration(seconds: 4),
    bool showProgressBar = true,
    bool enableHaptics = true,
    SnackBubbleIconStyle iconStyle = SnackBubbleIconStyle.animated,
    SnackBubbleStyle? style,
    SnackBubbleAction? action,
    VoidCallback? onTap,
  }) {
    show(
      context,
      title: title,
      message: message,
      type: SnackBubbleType.info,
      variant: variant,
      position: position,
      duration: duration,
      showProgressBar: showProgressBar,
      enableHaptics: enableHaptics,
      iconStyle: iconStyle,
      style: style,
      action: action,
      onTap: onTap,
    );
  }

  /// Convenience method to display a social / chat avatar notification.
  static void showAvatar(
    BuildContext context, {
    required String senderName,
    required String message,
    required SnackBubbleAvatar avatar,
    SnackBubbleVariant variant = SnackBubbleVariant.glassmorphic,
    SnackBubblePosition position = SnackBubblePosition.top,
    Duration duration = const Duration(seconds: 5),
    bool showProgressBar = true,
    bool enableHaptics = true,
    SnackBubbleIconStyle iconStyle = SnackBubbleIconStyle.animated,
    SnackBubbleStyle? style,
    SnackBubbleAction? action,
    VoidCallback? onTap,
  }) {
    show(
      context,
      title: senderName,
      message: message,
      avatar: avatar,
      type: SnackBubbleType.info,
      variant: variant,
      position: position,
      duration: duration,
      showProgressBar: showProgressBar,
      enableHaptics: enableHaptics,
      iconStyle: iconStyle,
      style: style,
      action: action,
      onTap: onTap,
    );
  }

  /// Dismisses active bubble immediately.
  static void hide() {
    _currentEntry?.remove();
    _currentEntry = null;
  }
}
