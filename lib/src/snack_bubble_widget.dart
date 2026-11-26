import 'dart:ui';
import 'package:flutter/material.dart';
import 'animated_icons.dart';
import 'enums.dart';
import 'snack_bubble_style.dart';

/// Ultra-premium visual card for notifications and toast bubbles.
class SnackBubbleWidget extends StatelessWidget {
  /// Optional bold headline above [message].
  final String? title;

  /// Main message description.
  final String message;

  /// Semantic theme category (success, error, warning, info, neutral).
  final SnackBubbleType type;

  /// Visual aesthetic styling variant.
  final SnackBubbleVariant variant;

  /// Custom style overrides.
  final SnackBubbleStyle? style;

  /// Optional avatar widget or configuration.
  final SnackBubbleAvatar? avatar;

  /// Optional widget replacing the default leading icon badge.
  final Widget? leading;

  /// Optional action button or custom trailing widget.
  final SnackBubbleAction? action;

  /// Generic trailing widget (takes precedence over [action]).
  final Widget? trailing;

  /// Tap callback on the bubble.
  final VoidCallback? onTap;

  /// Dismiss callback.
  final VoidCallback? onDismiss;

  /// Whether to show the close 'X' button if no action is provided.
  final bool showCloseButton;

  /// Normalized progress countdown (0.0 to 1.0).
  final double? progress;

  /// Whether the card is currently held/pressed down by user.
  final bool isPressed;

  /// Icon rendering mode: animated spring drawing or clean static icon.
  final SnackBubbleIconStyle iconStyle;

  const SnackBubbleWidget({
    super.key,
    this.title,
    required this.message,
    this.type = SnackBubbleType.neutral,
    this.variant = SnackBubbleVariant.glassmorphic,
    this.style,
    this.avatar,
    this.leading,
    this.action,
    this.trailing,
    this.onTap,
    this.onDismiss,
    this.showCloseButton = true,
    this.progress,
    this.isPressed = false,
    this.iconStyle = SnackBubbleIconStyle.animated,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedStyle = style ??
        SnackBubbleStyle.fromType(
          type,
          isDark: isDark,
          variant: variant,
        );

    final isCapsule = resolvedStyle.variant == SnackBubbleVariant.minimal;

    Widget cardBody = Material(
      color: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 440, minHeight: 56),
        decoration: BoxDecoration(
          color: resolvedStyle.backgroundColor,
          borderRadius: resolvedStyle.borderRadius,
          border: resolvedStyle.borderColor != null
              ? Border.all(
                  color: resolvedStyle.borderColor!,
                  width: resolvedStyle.borderWidth,
                )
              : null,
          boxShadow: resolvedStyle.shadows,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: resolvedStyle.borderRadius,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isCapsule ? 14 : 16,
                  vertical: isCapsule ? 10 : 13,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Leading: Avatar OR Glowing Icon Badge
                    leading ??
                        (avatar != null
                            ? _buildAvatar(avatar!, resolvedStyle)
                            : (iconStyle == SnackBubbleIconStyle.animated
                                ? AnimatedBubbleIcon(
                                    type: type,
                                    accentColor: resolvedStyle.accentColor,
                                    fallbackIcon: resolvedStyle.icon,
                                  )
                                : _buildLeadingBadge(resolvedStyle))),
                    const SizedBox(width: 13),

                    // Title & Description
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (title != null && title!.trim().isNotEmpty) ...[
                            Text(
                              title!,
                              style: resolvedStyle.titleStyle ??
                                  TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    letterSpacing: -0.3,
                                    color: resolvedStyle.foregroundColor,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                          ],
                          Text(
                            message,
                            style: resolvedStyle.messageStyle ??
                                TextStyle(
                                  fontSize: 13,
                                  height: 1.35,
                                  letterSpacing: -0.1,
                                  color: resolvedStyle.foregroundColor.withValues(
                                    alpha: isDark ? 0.88 : 0.78,
                                  ),
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // Action Button or Trailing
                    if (trailing != null) ...[
                      const SizedBox(width: 10),
                      trailing!,
                    ] else if (action != null) ...[
                      const SizedBox(width: 10),
                      _buildActionButton(action!, resolvedStyle),
                    ] else if (showCloseButton && onDismiss != null) ...[
                      const SizedBox(width: 6),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        iconSize: 18,
                        icon: Icon(
                          Icons.close_rounded,
                          color: resolvedStyle.foregroundColor.withValues(alpha: 0.45),
                        ),
                        onPressed: onDismiss,
                        splashRadius: 18,
                      ),
                    ],
                  ],
                ),
              ),

              // Sleek Embedded Progress Bar with rounded glowing cap
              if (progress != null)
                Container(
                  height: 2.5,
                  width: double.infinity,
                  color: Colors.transparent,
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: progress!.clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            resolvedStyle.accentColor.withValues(alpha: 0.4),
                            resolvedStyle.progressBarColor ?? resolvedStyle.accentColor,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [
                          BoxShadow(
                            color: resolvedStyle.accentColor.withValues(alpha: 0.6),
                            blurRadius: 4,
                            spreadRadius: 0.5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    // Apply frosted blur if configured
    if (resolvedStyle.blurSigma > 0.0) {
      cardBody = ClipRRect(
        borderRadius: resolvedStyle.borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: resolvedStyle.blurSigma,
            sigmaY: resolvedStyle.blurSigma,
          ),
          child: cardBody,
        ),
      );
    }

    // Wrap with Ambient Halo Glow if enabled
    Widget finalWidget = cardBody;
    if (resolvedStyle.enableAmbientGlow) {
      final glowColor = resolvedStyle.ambientGlowColor ??
          resolvedStyle.accentColor.withValues(alpha: isDark ? 0.38 : 0.22);

      finalWidget = Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: resolvedStyle.borderRadius,
                boxShadow: [
                  BoxShadow(
                    color: glowColor,
                    blurRadius: 36,
                    spreadRadius: 8,
                  ),
                ],
              ),
            ),
          ),
          cardBody,
        ],
      );
    }

    // Micro-scale feedback when held down
    return AnimatedScale(
      scale: isPressed ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOutCubic,
      child: finalWidget,
    );
  }

  Widget _buildLeadingBadge(SnackBubbleStyle resolvedStyle) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            resolvedStyle.accentColor.withValues(alpha: 0.28),
            resolvedStyle.accentColor.withValues(alpha: 0.10),
          ],
        ),
        border: Border.all(
          color: resolvedStyle.accentColor.withValues(alpha: 0.38),
          width: 1.2,
        ),
      ),
      child: Icon(
        resolvedStyle.icon ?? Icons.notifications_rounded,
        color: resolvedStyle.accentColor,
        size: 20,
      ),
    );
  }

  Widget _buildAvatar(SnackBubbleAvatar avatar, SnackBubbleStyle style) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: avatar.size,
          height: avatar.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: style.accentColor.withValues(alpha: 0.4),
              width: 1.5,
            ),
            image: avatar.imageUrl != null
                ? DecorationImage(
                    image: NetworkImage(avatar.imageUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
            gradient: avatar.imageUrl == null
                ? LinearGradient(
                    colors: [
                      style.accentColor.withValues(alpha: 0.3),
                      style.accentColor.withValues(alpha: 0.1),
                    ],
                  )
                : null,
          ),
          alignment: Alignment.center,
          child: avatar.imageUrl == null
              ? (avatar.initials != null
                  ? Text(
                      avatar.initials!,
                      style: TextStyle(
                        fontSize: avatar.size * 0.38,
                        fontWeight: FontWeight.w700,
                        color: style.foregroundColor,
                      ),
                    )
                  : Icon(
                      avatar.icon ?? Icons.person_rounded,
                      size: avatar.size * 0.52,
                      color: style.accentColor,
                    ))
              : null,
        ),
        if (avatar.isOnline)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 11,
              height: 11,
              decoration: BoxDecoration(
                color: const Color(0xFF10B981), // Emerald online dot
                shape: BoxShape.circle,
                border: Border.all(
                  color: style.backgroundColor,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildActionButton(SnackBubbleAction action, SnackBubbleStyle style) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: action.backgroundColor ?? style.accentColor.withValues(alpha: 0.18),
        border: Border.all(
          color: style.accentColor.withValues(alpha: 0.35),
          width: 0.9,
        ),
      ),
      child: InkWell(
        onTap: action.onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
          child: Text(
            action.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.1,
              color: action.textColor ?? style.accentColor,
            ),
          ),
        ),
      ),
    );
  }
}
