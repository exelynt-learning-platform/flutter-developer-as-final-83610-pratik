import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';
import '../utils/app_responsive.dart';

/// Reusable brand logo squircle with custom Hero flight shuttle and arc tween.
class AppBrandLogo extends StatelessWidget {
  final double size;
  final double iconSize;
  final double borderRadius;
  final double? shadowBlur;
  final double? shadowOffset;

  const AppBrandLogo({
    super.key,
    this.size = 58.0,
    this.iconSize = 28.0,
    this.borderRadius = 16.0,
    this.shadowBlur,
    this.shadowOffset,
  });

  /// Custom flight shuttle that smoothly interpolates size, radius, icon size, and shadow during transition.
  static Widget flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOutCubic,
    );

    return AnimatedBuilder(
      animation: curved,
      builder: (context, child) {
        final t = flightDirection == HeroFlightDirection.push
            ? curved.value
            : 1.0 - curved.value;

        // Interpolate between splash (76, 40, 22) and header (58, 28, 16) dimensions
        final currentSize = Tween<double>(begin: 76.0, end: 58.0).transform(t);
        final currentIconSize = Tween<double>(begin: 40.0, end: 28.0).transform(t);
        final currentRadius = Tween<double>(begin: 22.0, end: 16.0).transform(t);
        final currentBlur = Tween<double>(begin: 24.0, end: 16.0).transform(t);
        final currentOffsetY = Tween<double>(begin: 10.0, end: 6.0).transform(t);

        return Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              width: AppResponsive.scale(context, currentSize),
              height: AppResponsive.scale(context, currentSize),
              decoration: BoxDecoration(
                color: const Color(0xFF4F46E5),
                borderRadius: BorderRadius.circular(
                  AppResponsive.scale(context, currentRadius),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4F46E5).withValues(alpha: 0.35),
                    blurRadius: AppResponsive.scale(context, currentBlur),
                    offset: Offset(0, AppResponsive.scale(context, currentOffsetY)),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.people_outline_rounded,
                  size: AppResponsive.scale(context, currentIconSize),
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Creates a smooth, natural arc tween for the logo's path.
  static RectTween createRectTween(Rect? begin, Rect? end) {
    return MaterialRectCenterArcTween(begin: begin, end: end);
  }

  @override
  Widget build(BuildContext context) {
    final scaledSize = AppResponsive.scale(context, size);
    final scaledRadius = AppResponsive.scale(context, borderRadius);
    final scaledIconSize = AppResponsive.scale(context, iconSize);
    final blur = AppResponsive.scale(
      context,
      shadowBlur ?? (size > 60 ? 24.0 : 16.0),
    );
    final offsetY = AppResponsive.scale(
      context,
      shadowOffset ?? (size > 60 ? 10.0 : 6.0),
    );

    return Hero(
      tag: 'app_brand_logo',
      createRectTween: createRectTween,
      flightShuttleBuilder: flightShuttleBuilder,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: scaledSize,
          height: scaledSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(scaledRadius),
            color: const Color(0xFF4F46E5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4F46E5).withValues(alpha: 0.35),
                blurRadius: blur,
                offset: Offset(0, offsetY),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.people_outline_rounded,
              size: scaledIconSize,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

/// Reusable brand header component.
/// Centers the PeopleFlow squircle icon, centered title, and centered subtitle.
class AppBrandHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? badgeText;

  const AppBrandHeader({
    super.key,
    this.title = 'PeopleFlow',
    this.subtitle = 'Employee Management',
    this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Squircle Icon Container with Hero transition
        const AppBrandLogo(),
        SizedBox(height: AppResponsive.scale(context, 14.0)),

        // Centered Brand Title
        if (badgeText != null && badgeText!.isNotEmpty)
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppResponsive.scale(context, 8.0),
            runSpacing: 4.0,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppResponsive.fontSize(context, 22.0),
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                  color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.scale(context, 8.0),
                  vertical: AppResponsive.scale(context, 3.0),
                ),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF312E81) : const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Text(
                  badgeText!,
                  style: TextStyle(
                    color: isDark ? const Color(0xFFC7D2FE) : const Color(0xFF4F46E5),
                    fontSize: AppResponsive.fontSize(context, 11.0),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          )
        else
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppResponsive.fontSize(context, 23.0),
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
            ),
          ),
        SizedBox(height: AppResponsive.scale(context, 4.0)),

        // Centered Subtitle
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: AppTypography.subtitle(
            context,
            color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }
}
