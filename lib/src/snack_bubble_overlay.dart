import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'enums.dart';
import 'snack_bubble_style.dart';
import 'snack_bubble_widget.dart';

/// Overlay container that orchestrates dynamic spring entrance, touch-to-pause, and dismiss transitions.
class SnackBubbleOverlay extends StatefulWidget {
  final String? title;
  final String message;
  final SnackBubbleType type;
  final SnackBubbleVariant variant;
  final SnackBubblePosition position;
  final SnackBubbleStyle? style;
  final SnackBubbleAvatar? avatar;
  final Widget? leading;
  final SnackBubbleAction? action;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback onDismiss;
  final Duration duration;
  final bool showProgressBar;
  final bool showCloseButton;
  final bool enableHaptics;
  final bool pauseOnTouch;
  final SnackBubbleIconStyle iconStyle;
  final EdgeInsetsGeometry margin;

  const SnackBubbleOverlay({
    super.key,
    this.title,
    required this.message,
    required this.type,
    this.variant = SnackBubbleVariant.glassmorphic,
    required this.position,
    this.style,
    this.avatar,
    this.leading,
    this.action,
    this.trailing,
    this.onTap,
    required this.onDismiss,
    required this.duration,
    required this.showProgressBar,
    required this.showCloseButton,
    this.enableHaptics = true,
    this.pauseOnTouch = true,
    this.iconStyle = SnackBubbleIconStyle.animated,
    required this.margin,
  });

  @override
  State<SnackBubbleOverlay> createState() => _SnackBubbleOverlayState();
}

class _SnackBubbleOverlayState extends State<SnackBubbleOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  AnimationController? _progressController;

  bool _isDismissed = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    if (widget.enableHaptics) {
      HapticFeedback.mediumImpact();
    }

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
      reverseDuration: const Duration(milliseconds: 260),
    );

    final isTop = widget.position == SnackBubblePosition.top;
    final slideBegin = isTop ? const Offset(0.0, -0.65) : const Offset(0.0, 0.65);

    _slideAnimation = Tween<Offset>(
      begin: slideBegin,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeInBack,
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.88,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      ),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );

    // Auto-dismiss countdown
    if (widget.duration > Duration.zero) {
      _progressController = AnimationController(
        vsync: this,
        duration: widget.duration,
      );

      _progressController!.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          dismiss();
        }
      });

      _progressController!.forward();
    }

    _animController.forward();
  }

  void _handlePointerDown() {
    if (!widget.pauseOnTouch) return;
    setState(() => _isPressed = true);
    _progressController?.stop();
    if (widget.enableHaptics) {
      HapticFeedback.lightImpact();
    }
  }

  void _handlePointerUp() {
    if (!widget.pauseOnTouch) return;
    setState(() => _isPressed = false);
    if (!_isDismissed && _progressController != null) {
      _progressController!.forward();
    }
  }

  /// Triggers dismissal with haptic feedback.
  Future<void> dismiss() async {
    if (_isDismissed) return;
    _isDismissed = true;
    _progressController?.stop();

    if (widget.enableHaptics) {
      HapticFeedback.mediumImpact();
    }

    if (mounted) {
      await _animController.reverse();
    }
    widget.onDismiss();
  }

  @override
  void dispose() {
    _progressController?.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Positioned(
      top: widget.position == SnackBubblePosition.top
          ? mediaQuery.padding.top + 16
          : null,
      bottom: widget.position == SnackBubblePosition.bottom
          ? mediaQuery.padding.bottom + 16
          : null,
      left: 0,
      right: 0,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: widget.margin,
          child: Align(
            alignment: Alignment.center,
            child: Listener(
              onPointerDown: (_) => _handlePointerDown(),
              onPointerUp: (_) => _handlePointerUp(),
              onPointerCancel: (_) => _handlePointerUp(),
              child: Dismissible(
                key: const ValueKey('snack_bubble_dismissible'),
                direction: DismissDirection.horizontal,
                onDismissed: (_) {
                  _isDismissed = true;
                  _progressController?.stop();
                  if (widget.enableHaptics) {
                    HapticFeedback.mediumImpact();
                  }
                  widget.onDismiss();
                },
                child: SlideTransition(
                  position: _slideAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: AnimatedBuilder(
                        animation: _progressController ?? _animController,
                        builder: (context, child) {
                          final progress = _progressController != null &&
                                  widget.showProgressBar
                              ? 1.0 - _progressController!.value
                              : null;

                          return SnackBubbleWidget(
                            title: widget.title,
                            message: widget.message,
                            type: widget.type,
                            variant: widget.variant,
                            style: widget.style,
                            avatar: widget.avatar,
                            leading: widget.leading,
                            action: widget.action,
                            trailing: widget.trailing,
                            onTap: widget.onTap,
                            onDismiss: dismiss,
                            showCloseButton: widget.showCloseButton,
                            progress: progress,
                            isPressed: _isPressed,
                            iconStyle: widget.iconStyle,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
