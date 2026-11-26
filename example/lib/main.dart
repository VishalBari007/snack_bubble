import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snack_bubble/snack_bubble.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SnackBubbleApp());
}

class SnackBubbleApp extends StatefulWidget {
  const SnackBubbleApp({super.key});

  @override
  State<SnackBubbleApp> createState() => _SnackBubbleAppState();
}

class _SnackBubbleAppState extends State<SnackBubbleApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _updateThemeMode(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnackBubble',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,

      // Light Theme
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF059669),
          surface: Colors.white,
          surfaceContainerHighest: Color(0xFFF1F5F9),
        ),
        dividerColor: const Color(0xFFE2E8F0),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),

      // Dark Theme
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF09090B),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF10B981),
          surface: Color(0xFF141417),
          surfaceContainerHighest: Color(0xFF222227),
        ),
        dividerColor: const Color(0xFF222227),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),

      home: SnackBubbleHomeScreen(
        themeMode: _themeMode,
        onThemeChanged: _updateThemeMode,
      ),
    );
  }
}

class SnackBubbleHomeScreen extends StatefulWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  const SnackBubbleHomeScreen({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
  });

  @override
  State<SnackBubbleHomeScreen> createState() => _SnackBubbleHomeScreenState();
}

class _SnackBubbleHomeScreenState extends State<SnackBubbleHomeScreen> {
  SnackBubbleVariant _variant = SnackBubbleVariant.glassmorphic;
  SnackBubblePosition _position = SnackBubblePosition.top;
  SnackBubbleIconStyle _iconStyle = SnackBubbleIconStyle.animated;
  bool _showProgress = true;
  bool _enableHaptics = true;
  bool _enableAmbientGlow = true;
  double _durationSeconds = 4.0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    final cardBg = isDark ? const Color(0xFF141417) : Colors.white;
    final borderColor = isDark ? const Color(0xFF222227) : const Color(0xFFE2E8F0);
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSecondary = isDark ? const Color(0xFFA1A1AA) : const Color(0xFF64748B);
    final textMuted = isDark ? const Color(0xFF71717A) : const Color(0xFF94A3B8);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: scaffoldBg,
        systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            // Header App Bar
            SliverAppBar(
              expandedHeight: 140,
              floating: false,
              pinned: true,
              backgroundColor: scaffoldBg,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                title: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF10B981), Color(0xFF06B6D4)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF10B981).withValues(alpha: isDark ? 0.4 : 0.2),
                            blurRadius: 12,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'SnackBubble',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: const Color(0xFF10B981).withValues(alpha: 0.4),
                          width: 0.8,
                        ),
                      ),
                      child: const Text(
                        'PRO',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.code_rounded, color: textSecondary),
                  tooltip: 'View Sample Code',
                  onPressed: () => _showCodeSnippetDialog(isDark),
                ),
                const SizedBox(width: 12),
              ],
            ),

            // Main Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Subtitle & Interactive Hint
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF10B981),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Tip: Hold down any notification to freeze countdown timer.',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Configuration Card
                    _buildConfigCard(
                      isDark: isDark,
                      cardBg: cardBg,
                      borderColor: borderColor,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      textMuted: textMuted,
                    ),
                    const SizedBox(height: 28),

                    // Section Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'INTERACTIVE PRESETS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                            color: textMuted,
                          ),
                        ),
                        if (SnackBubble.isVisible)
                          GestureDetector(
                            onTap: () {
                              SnackBubble.hide();
                              setState(() {});
                            },
                            child: const Text(
                              'Dismiss Active',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFF43F5E),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // 1. Social Avatar Notification
                    _buildScenarioTile(
                      isDark: isDark,
                      cardBg: cardBg,
                      borderColor: borderColor,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      title: 'Sarah Connor',
                      subtitle: 'Shared "DesignSystem_v4.fig" with editor access.',
                      category: 'TEAM CHAT',
                      type: SnackBubbleType.info,
                      icon: Icons.person_rounded,
                      accentColor: const Color(0xFF06B6D4),
                      actionLabel: 'Reply',
                      onTrigger: () => SnackBubble.showAvatar(
                        context,
                        senderName: 'Sarah Connor',
                        message: 'Shared "DesignSystem_v4.fig" with editor access.',
                        variant: _variant,
                        position: _position,
                        duration: Duration(seconds: _durationSeconds.round()),
                        showProgressBar: _showProgress,
                        enableHaptics: _enableHaptics,
                        iconStyle: _iconStyle,
                        style: SnackBubbleStyle.fromType(
                          SnackBubbleType.info,
                          isDark: isDark,
                          variant: _variant,
                        ).copyWith(
                          enableAmbientGlow: _enableAmbientGlow,
                        ),
                        avatar: const SnackBubbleAvatar(
                          initials: 'SC',
                          isOnline: true,
                          size: 38,
                        ),
                        action: SnackBubbleAction(
                          label: 'Open',
                          onPressed: () {
                            SnackBubble.hide();
                            _showSnackBarNotice('Opening Figma file...');
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 2. Production Deployment
                    _buildScenarioTile(
                      isDark: isDark,
                      cardBg: cardBg,
                      borderColor: borderColor,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      title: 'Deployment Succeeded',
                      subtitle: 'Release v3.0 is live across 28 global regions.',
                      category: 'SUCCESS',
                      type: SnackBubbleType.success,
                      icon: Icons.check_circle_rounded,
                      accentColor: const Color(0xFF10B981),
                      actionLabel: 'View Logs',
                      onTrigger: () => _triggerBubble(
                        isDark: isDark,
                        title: 'Production Deployed',
                        message: 'Release v3.0 is live across 28 global regions.',
                        type: SnackBubbleType.success,
                        action: SnackBubbleAction(
                          label: 'View Logs',
                          onPressed: () {
                            SnackBubble.hide();
                            _showSnackBarNotice('Navigating to deployment logs...');
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 3. Payment Failed
                    _buildScenarioTile(
                      isDark: isDark,
                      cardBg: cardBg,
                      borderColor: borderColor,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      title: 'Payment Requires Action',
                      subtitle: 'Card ending in 4242 failed auth verification.',
                      category: 'ERROR',
                      type: SnackBubbleType.error,
                      icon: Icons.cancel_rounded,
                      accentColor: const Color(0xFFF43F5E),
                      actionLabel: 'Retry',
                      onTrigger: () => _triggerBubble(
                        isDark: isDark,
                        title: 'Payment Declined',
                        message: 'Card ending in 4242 failed 3D Secure verification.',
                        type: SnackBubbleType.error,
                        action: SnackBubbleAction(
                          label: 'Try Again',
                          onPressed: () {
                            SnackBubble.hide();
                            _showSnackBarNotice('Retrying payment gateway...');
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 4. Storage Alert
                    _buildScenarioTile(
                      isDark: isDark,
                      cardBg: cardBg,
                      borderColor: borderColor,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      title: 'Low Storage Quota',
                      subtitle: 'Device has 1.2 GB remaining. Cloud sync paused.',
                      category: 'WARNING',
                      type: SnackBubbleType.warning,
                      icon: Icons.warning_rounded,
                      accentColor: const Color(0xFFF59E0B),
                      actionLabel: 'Clean Up',
                      onTrigger: () => _triggerBubble(
                        isDark: isDark,
                        title: 'Storage Warning',
                        message: 'Cloud sync paused. Clean up local files.',
                        type: SnackBubbleType.warning,
                        action: SnackBubbleAction(
                          label: 'Clean Up',
                          onPressed: () {
                            SnackBubble.hide();
                            _showSnackBarNotice('Opening storage cleaner...');
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 5. Undo Deletion Action
                    _buildScenarioTile(
                      isDark: isDark,
                      cardBg: cardBg,
                      borderColor: borderColor,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      title: 'Project File Deleted',
                      subtitle: '"roadmap_2026.pdf" moved to trash.',
                      category: 'ACTIONABLE',
                      type: SnackBubbleType.neutral,
                      icon: Icons.delete_outline_rounded,
                      accentColor: isDark ? const Color(0xFFA1A1AA) : const Color(0xFF64748B),
                      actionLabel: 'Undo',
                      onTrigger: () => _triggerBubble(
                        isDark: isDark,
                        title: 'Item Deleted',
                        message: '"roadmap_2026.pdf" moved to trash.',
                        type: SnackBubbleType.neutral,
                        action: SnackBubbleAction(
                          label: 'Undo',
                          textColor: const Color(0xFF10B981),
                          onPressed: () {
                            SnackBubble.hide();
                            _showSnackBarNotice('Restored "roadmap_2026.pdf"');
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 6. Minimal Pill Toast
                    _buildScenarioTile(
                      isDark: isDark,
                      cardBg: cardBg,
                      borderColor: borderColor,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      title: 'Minimal Capsule Toast',
                      subtitle: 'Ultra-compact single-line micro-interaction.',
                      category: 'MINIMAL',
                      type: SnackBubbleType.neutral,
                      icon: Icons.copy_rounded,
                      accentColor: isDark ? const Color(0xFFA1A1AA) : const Color(0xFF64748B),
                      actionLabel: null,
                      onTrigger: () => SnackBubble.show(
                        context,
                        message: 'Copied link to clipboard',
                        type: SnackBubbleType.neutral,
                        variant: SnackBubbleVariant.minimal,
                        position: _position,
                        duration: const Duration(seconds: 3),
                        showProgressBar: _showProgress,
                        enableHaptics: _enableHaptics,
                        iconStyle: _iconStyle,
                        style: SnackBubbleStyle.fromType(
                          SnackBubbleType.neutral,
                          isDark: isDark,
                          variant: SnackBubbleVariant.minimal,
                        ).copyWith(
                          enableAmbientGlow: _enableAmbientGlow,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigCard({
    required bool isDark,
    required Color cardBg,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
    required Color textMuted,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.tune_rounded, color: Color(0xFF10B981), size: 18),
              const SizedBox(width: 8),
              Text(
                'SnackBubble Customizer',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Theme Selector (System, Light, Dark)
          Text(
            'THEME MODE',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildThemeButton(
                  label: 'System',
                  icon: Icons.brightness_auto_rounded,
                  mode: ThemeMode.system,
                  isDark: isDark,
                  borderColor: borderColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildThemeButton(
                  label: 'Light',
                  icon: Icons.light_mode_rounded,
                  mode: ThemeMode.light,
                  isDark: isDark,
                  borderColor: borderColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildThemeButton(
                  label: 'Dark',
                  icon: Icons.dark_mode_rounded,
                  mode: ThemeMode.dark,
                  isDark: isDark,
                  borderColor: borderColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Style Variant
          Text(
            'SURFACE VARIANT',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: textMuted,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildVariantChip(
                  label: 'Frosted Glass',
                  variant: SnackBubbleVariant.glassmorphic,
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _buildVariantChip(
                  label: 'Neon Glow',
                  variant: SnackBubbleVariant.neon,
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _buildVariantChip(
                  label: 'Deep Elevated',
                  variant: SnackBubbleVariant.elevated,
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _buildVariantChip(
                  label: 'Capsule',
                  variant: SnackBubbleVariant.minimal,
                  isDark: isDark,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Screen Position
          Text(
            'SCREEN POSITION',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildPositionButton(
                  label: 'Top Island',
                  icon: Icons.vertical_align_top_rounded,
                  position: SnackBubblePosition.top,
                  isDark: isDark,
                  borderColor: borderColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildPositionButton(
                  label: 'Bottom Dock',
                  icon: Icons.vertical_align_bottom_rounded,
                  position: SnackBubblePosition.bottom,
                  isDark: isDark,
                  borderColor: borderColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Icon Style (Animated vs Simple)
          Text(
            'ICON RENDERING STYLE',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildIconStyleButton(
                  label: '✨ Animated',
                  iconStyle: SnackBubbleIconStyle.animated,
                  isDark: isDark,
                  borderColor: borderColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildIconStyleButton(
                  label: '⚪ Simple',
                  iconStyle: SnackBubbleIconStyle.simple,
                  isDark: isDark,
                  borderColor: borderColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Duration Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'AUTO-DISMISS DURATION',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  color: textMuted,
                ),
              ),
              Text(
                '${_durationSeconds.toStringAsFixed(1)}s',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF10B981),
                ),
              ),
            ],
          ),
          Slider(
            value: _durationSeconds,
            min: 2.0,
            max: 8.0,
            divisions: 12,
            activeColor: const Color(0xFF10B981),
            inactiveColor: isDark ? const Color(0xFF27272A) : const Color(0xFFE2E8F0),
            onChanged: (val) => setState(() => _durationSeconds = val),
          ),
          Divider(color: borderColor, height: 16),

          // Toggles
          SwitchListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Ambient Glow Halo (Backlight)',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: textPrimary,
              ),
            ),
            value: _enableAmbientGlow,
            activeTrackColor: const Color(0xFF10B981),
            onChanged: (val) => setState(() => _enableAmbientGlow = val),
          ),
          SwitchListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Smooth Countdown Bar',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: textPrimary,
              ),
            ),
            value: _showProgress,
            activeTrackColor: const Color(0xFF10B981),
            onChanged: (val) => setState(() => _showProgress = val),
          ),
          SwitchListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Haptic Touch Feedback',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: textPrimary,
              ),
            ),
            value: _enableHaptics,
            activeTrackColor: const Color(0xFF10B981),
            onChanged: (val) => setState(() => _enableHaptics = val),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeButton({
    required String label,
    required IconData icon,
    required ThemeMode mode,
    required bool isDark,
    required Color borderColor,
  }) {
    final isSelected = widget.themeMode == mode;
    return GestureDetector(
      onTap: () => widget.onThemeChanged(mode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8.5),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF10B981).withValues(alpha: 0.18)
              : (isDark ? const Color(0xFF1E1E23) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF10B981) : borderColor,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected
                  ? const Color(0xFF10B981)
                  : (isDark ? const Color(0xFFA1A1AA) : const Color(0xFF64748B)),
            ),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? const Color(0xFF10B981)
                      : (isDark ? Colors.white : const Color(0xFF0F172A)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVariantChip({
    required String label,
    required SnackBubbleVariant variant,
    required bool isDark,
  }) {
    final isSelected = _variant == variant;
    return GestureDetector(
      onTap: () => setState(() => _variant = variant),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7.5),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF10B981).withValues(alpha: 0.18)
              : (isDark ? const Color(0xFF1E1E23) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF10B981)
                : (isDark ? const Color(0xFF2E2E35) : const Color(0xFFE2E8F0)),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? const Color(0xFF10B981)
                : (isDark ? const Color(0xFFA1A1AA) : const Color(0xFF64748B)),
          ),
        ),
      ),
    );
  }

  Widget _buildPositionButton({
    required String label,
    required IconData icon,
    required SnackBubblePosition position,
    required bool isDark,
    required Color borderColor,
  }) {
    final isSelected = _position == position;
    return GestureDetector(
      onTap: () => setState(() => _position = position),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? const Color(0xFF222228) : const Color(0xFFE2E8F0))
              : (isDark ? const Color(0xFF161619) : const Color(0xFFF8FAFC)),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF10B981) : borderColor,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected ? const Color(0xFF10B981) : const Color(0xFF71717A),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? (isDark ? Colors.white : const Color(0xFF0F172A))
                      : const Color(0xFF71717A),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconStyleButton({
    required String label,
    required SnackBubbleIconStyle iconStyle,
    required bool isDark,
    required Color borderColor,
  }) {
    final isSelected = _iconStyle == iconStyle;
    return GestureDetector(
      onTap: () => setState(() => _iconStyle = iconStyle),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? const Color(0xFF222228) : const Color(0xFFE2E8F0))
              : (isDark ? const Color(0xFF161619) : const Color(0xFFF8FAFC)),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF10B981) : borderColor,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? (isDark ? Colors.white : const Color(0xFF0F172A))
                  : const Color(0xFF71717A),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScenarioTile({
    required bool isDark,
    required Color cardBg,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
    required String title,
    required String subtitle,
    required String category,
    required SnackBubbleType type,
    required IconData icon,
    required Color accentColor,
    required String? actionLabel,
    required VoidCallback onTrigger,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTrigger,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Icon Badge
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accentColor.withValues(alpha: 0.12),
                    border: Border.all(
                      color: accentColor.withValues(alpha: 0.35),
                      width: 1.2,
                    ),
                  ),
                  child: Icon(icon, color: accentColor, size: 22),
                ),
                const SizedBox(width: 14),

                // Info Texts
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: textPrimary,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 7),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5.5, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              category,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.3,
                                color: accentColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: textSecondary,
                          height: 1.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),
                Icon(
                  Icons.play_circle_outline_rounded,
                  color: textSecondary.withValues(alpha: 0.6),
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _triggerBubble({
    required bool isDark,
    required String title,
    required String message,
    required SnackBubbleType type,
    SnackBubbleAction? action,
  }) {
    SnackBubble.show(
      context,
      title: title,
      message: message,
      type: type,
      variant: _variant,
      position: _position,
      duration: Duration(seconds: _durationSeconds.round()),
      showProgressBar: _showProgress,
      enableHaptics: _enableHaptics,
      iconStyle: _iconStyle,
      action: action,
      style: SnackBubbleStyle.fromType(
        type,
        isDark: isDark,
        variant: _variant,
      ).copyWith(
        enableAmbientGlow: _enableAmbientGlow,
      ),
    );
  }

  void _showSnackBarNotice(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  void _showCodeSnippetDialog(bool isDark) {
    final dialogBg = isDark ? const Color(0xFF141417) : Colors.white;
    final snippetBg = isDark ? const Color(0xFF09090B) : const Color(0xFFF1F5F9);
    final textTitle = isDark ? Colors.white : const Color(0xFF0F172A);

    showModalBottomSheet(
      context: context,
      backgroundColor: dialogBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Quick Integration',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: textTitle,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: snippetBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? const Color(0xFF27272A) : const Color(0xFFE2E8F0),
                  ),
                ),
                child: const Text(
                  '''SnackBubble.show(
  context,
  title: 'Deployed',
  message: 'Version 3.0 is live.',
  type: SnackBubbleType.success,
  variant: SnackBubbleVariant.glassmorphic,
  position: SnackBubblePosition.top,
  action: SnackBubbleAction(
    label: 'View',
    onPressed: () => openLogs(),
  ),
);''',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    height: 1.45,
                    color: Color(0xFF10B981),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.copy_rounded, size: 16),
                  label: const Text('Copy Snippet'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Clipboard.setData(
                      const ClipboardData(
                        text: "SnackBubble.showSuccess(context, title: 'Success', message: 'Task completed');",
                      ),
                    );
                    Navigator.pop(context);
                    _showSnackBarNotice('Copied snippet to clipboard!');
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
