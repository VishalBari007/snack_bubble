import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'enums.dart';

/// Highly optimized, self-animating badge for [SnackBubbleType].
class AnimatedBubbleIcon extends StatefulWidget {
  final SnackBubbleType type;
  final Color accentColor;
  final IconData? fallbackIcon;
  final double size;

  const AnimatedBubbleIcon({
    super.key,
    required this.type,
    required this.accentColor,
    this.fallbackIcon,
    this.size = 38.0,
  });

  @override
  State<AnimatedBubbleIcon> createState() => _AnimatedBubbleIconState();
}

class _AnimatedBubbleIconState extends State<AnimatedBubbleIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.25, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              widget.accentColor.withValues(alpha: 0.28),
              widget.accentColor.withValues(alpha: 0.10),
            ],
          ),
          border: Border.all(
            color: widget.accentColor.withValues(alpha: 0.38),
            width: 1.2,
          ),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            switch (widget.type) {
              case SnackBubbleType.success:
                return CustomPaint(
                  painter: _CheckmarkPainter(
                    progress: _progressAnimation.value,
                    color: widget.accentColor,
                  ),
                );
              case SnackBubbleType.error:
                return CustomPaint(
                  painter: _CrossPainter(
                    progress: _progressAnimation.value,
                    color: widget.accentColor,
                  ),
                );
              case SnackBubbleType.warning:
                return Transform.scale(
                  scale: 0.85 + (0.15 * math.sin(_controller.value * math.pi)),
                  child: Icon(
                    Icons.warning_rounded,
                    color: widget.accentColor,
                    size: widget.size * 0.52,
                  ),
                );
              case SnackBubbleType.info:
                return Transform.rotate(
                  angle: math.sin(_controller.value * math.pi * 3) * 0.12 * (1.0 - _controller.value),
                  child: Icon(
                    Icons.info_rounded,
                    color: widget.accentColor,
                    size: widget.size * 0.52,
                  ),
                );
              case SnackBubbleType.neutral:
                return Transform.scale(
                  scale: 0.9 + (0.1 * math.sin(_controller.value * math.pi)),
                  child: Icon(
                    widget.fallbackIcon ?? Icons.notifications_rounded,
                    color: widget.accentColor,
                    size: widget.size * 0.52,
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}

/// Custom painter for an animated checkmark stroke.
class _CheckmarkPainter extends CustomPainter {
  final double progress;
  final Color color;

  _CheckmarkPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0.0) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    final path = Path()
      ..moveTo(w * 0.30, h * 0.52)
      ..lineTo(w * 0.44, h * 0.66)
      ..lineTo(w * 0.70, h * 0.38);

    for (final metric in path.computeMetrics()) {
      final extractLength = metric.length * progress;
      final extractPath = metric.extractPath(0.0, extractLength);
      canvas.drawPath(extractPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CheckmarkPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

/// Custom painter for an animated X cross stroke.
class _CrossPainter extends CustomPainter {
  final double progress;
  final Color color;

  _CrossPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0.0) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;

    // First diagonal: top-left to bottom-right
    final p1 = Path()
      ..moveTo(w * 0.34, h * 0.34)
      ..lineTo(w * 0.66, h * 0.66);

    // Second diagonal: top-right to bottom-left
    final p2 = Path()
      ..moveTo(w * 0.66, h * 0.34)
      ..lineTo(w * 0.34, h * 0.66);

    final halfProgress1 = (progress * 2.0).clamp(0.0, 1.0);
    for (final metric in p1.computeMetrics()) {
      final extractPath = metric.extractPath(0.0, metric.length * halfProgress1);
      canvas.drawPath(extractPath, paint);
    }

    if (progress > 0.5) {
      final halfProgress2 = ((progress - 0.5) * 2.0).clamp(0.0, 1.0);
      for (final metric in p2.computeMetrics()) {
        final extractPath = metric.extractPath(0.0, metric.length * halfProgress2);
        canvas.drawPath(extractPath, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CrossPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
