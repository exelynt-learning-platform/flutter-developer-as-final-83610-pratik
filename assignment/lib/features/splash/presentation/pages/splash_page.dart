import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/widgets/core_widgets.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

/// Splash page with hand-crafted doodle-like animations and sketch strokes.
/// Displays an animated squircle, drawing doodle rings, floating doodle elements,
/// and smoothly transitions to Dashboard or Login.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _doodleController;
  late final AnimationController _floatController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _doodleDrawAnimation;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    _doodleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _scaleAnimation = CurvedAnimation(
      parent: _doodleController,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    );

    _doodleDrawAnimation = CurvedAnimation(
      parent: _doodleController,
      curve: const Interval(0.2, 0.9, curve: Curves.easeInOutCubic),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _doodleController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
    );

    _doodleController.forward();

    // Navigate smoothly after doodle animation completes
    _navigationTimer = Timer(const Duration(milliseconds: 2300), () {
      if (!mounted) return;
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthenticatedState) {
        context.go(RouteNames.dashboard);
      } else {
        context.go(RouteNames.login);
      }
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _doodleController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(0xFF4F46E5);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
      body: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: Listenable.merge([_doodleController, _floatController]),
            builder: (context, child) {
              final floatOffset = math.sin(_floatController.value * math.pi) * 6;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Central Doodle Canvas & Logo
                  SizedBox(
                    width: AppResponsive.scale(context, 220),
                    height: AppResponsive.scale(context, 200),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Hand-drawn animated doodle sketch ring & sparks (floating gently)
                        Transform.translate(
                          offset: Offset(0, floatOffset),
                          child: CustomPaint(
                            size: Size(
                              AppResponsive.scale(context, 210),
                              AppResponsive.scale(context, 190),
                            ),
                            painter: _DoodleSketchPainter(
                              progress: _doodleDrawAnimation.value,
                              floatPhase: _floatController.value,
                              color: primaryColor,
                            ),
                          ),
                        ),

                        // Animated Brand Squircle with Hero transition (anchored steadily for smooth flight)
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: const AppBrandLogo(
                            size: 76.0,
                            iconSize: 40.0,
                            borderRadius: 22.0,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppResponsive.scale(context, 16)),

                  // Brand Title & Tagline with Fade & Slide
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        Text(
                          'PeopleFlow',
                          style: TextStyle(
                            fontSize: AppResponsive.fontSize(context, 28),
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.6,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        SizedBox(height: AppResponsive.scale(context, 6)),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Employee Management',
                              style: TextStyle(
                                fontSize: AppResponsive.fontSize(context, 14),
                                color: const Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: AppResponsive.scale(context, 6)),
                            const _BlinkingDoodleDot(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Blinking doodle dot pulse
class _BlinkingDoodleDot extends StatefulWidget {
  const _BlinkingDoodleDot();

  @override
  State<_BlinkingDoodleDot> createState() => _BlinkingDoodleDotState();
}

class _BlinkingDoodleDotState extends State<_BlinkingDoodleDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _pulseController,
      child: Container(
        width: 7,
        height: 7,
        decoration: const BoxDecoration(
          color: Color(0xFF0D9488),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

/// Custom painter for sketching hand-drawn doodle circles, squiggles, and sparkles.
class _DoodleSketchPainter extends CustomPainter {
  final double progress;
  final double floatPhase;
  final Color color;

  _DoodleSketchPainter({
    required this.progress,
    required this.floatPhase,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0.0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final paintDoodle = Paint()
      ..color = color.withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    final paintAccent = Paint()
      ..color = const Color(0xFF0D9488).withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    // 1. Hand-drawn wobbly circle surrounding the squircle
    final double radius = 56.0 + math.sin(floatPhase * math.pi) * 2;
    final Path circlePath = Path();
    final int points = 36;
    final double sweep = progress * 2 * math.pi;

    for (int i = 0; i <= points; i++) {
      final double theta = (i / points) * sweep;
      if (theta > sweep) break;
      // Slight wobble to simulate natural hand drawing
      final double wobble = math.sin(i * 1.5) * 2.5;
      final double r = radius + wobble;
      final double x = center.dx + r * math.cos(theta);
      final double y = center.dy + r * math.sin(theta);
      if (i == 0) {
        circlePath.moveTo(x, y);
      } else {
        circlePath.lineTo(x, y);
      }
    }
    canvas.drawPath(circlePath, paintDoodle);

    // 2. Animated doodle sparkles (Four-point star doodles)
    if (progress > 0.4) {
      final double starScale = ((progress - 0.4) / 0.6).clamp(0.0, 1.0);

      // Top-right sparkle
      _drawDoodleSparkle(
        canvas,
        Offset(center.dx + 64, center.dy - 48 + math.sin(floatPhase * math.pi) * 3),
        10 * starScale,
        paintDoodle,
      );

      // Bottom-left sparkle
      _drawDoodleSparkle(
        canvas,
        Offset(center.dx - 68, center.dy + 36 - math.cos(floatPhase * math.pi) * 3),
        8 * starScale,
        paintAccent,
      );

      // Top-left mini doodle loop
      _drawDoodleLoop(
        canvas,
        Offset(center.dx - 60, center.dy - 42),
        starScale,
        paintDoodle,
      );

      // Bottom-right underline squiggle
      _drawDoodleSquiggle(
        canvas,
        Offset(center.dx + 40, center.dy + 45),
        starScale,
        paintAccent,
      );
    }
  }

  void _drawDoodleSparkle(
    Canvas canvas,
    Offset pos,
    double radius,
    Paint paint,
  ) {
    if (radius <= 1) return;
    final Path star = Path()
      ..moveTo(pos.dx, pos.dy - radius)
      ..quadraticBezierTo(pos.dx, pos.dy, pos.dx + radius, pos.dy)
      ..quadraticBezierTo(pos.dx, pos.dy, pos.dx, pos.dy + radius)
      ..quadraticBezierTo(pos.dx, pos.dy, pos.dx - radius, pos.dy)
      ..quadraticBezierTo(pos.dx, pos.dy, pos.dx, pos.dy - radius);
    canvas.drawPath(star, paint);
  }

  void _drawDoodleLoop(
    Canvas canvas,
    Offset pos,
    double scale,
    Paint paint,
  ) {
    final Path loop = Path()
      ..moveTo(pos.dx, pos.dy)
      ..cubicTo(
        pos.dx - 12 * scale,
        pos.dy - 14 * scale,
        pos.dx + 4 * scale,
        pos.dy - 20 * scale,
        pos.dx + 10 * scale,
        pos.dy - 6 * scale,
      );
    canvas.drawPath(loop, paint);
  }

  void _drawDoodleSquiggle(
    Canvas canvas,
    Offset pos,
    double scale,
    Paint paint,
  ) {
    final Path squiggle = Path()
      ..moveTo(pos.dx, pos.dy)
      ..quadraticBezierTo(pos.dx + 8 * scale, pos.dy - 6 * scale, pos.dx + 16 * scale, pos.dy)
      ..quadraticBezierTo(pos.dx + 24 * scale, pos.dy + 6 * scale, pos.dx + 32 * scale, pos.dy);
    canvas.drawPath(squiggle, paint);
  }

  @override
  bool shouldRepaint(covariant _DoodleSketchPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.floatPhase != floatPhase;
  }
}
