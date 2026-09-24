import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../utils/app_responsive.dart';

/// Global responsive container ensuring optimal layouts across screen sizes.
/// On mobile viewports, provides clean edge-to-edge padding without awkward
/// nested cards. On tablet/desktop viewports, neatly centers inside a card.
class AppCardContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;

  const AppCardContainer({
    super.key,
    required this.child,
    this.maxWidth = 440.0,
    this.padding,
    this.margin,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTabletOrDesktop = AppResponsive.isTablet(context);

    if (!isTabletOrDesktop) {
      return Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Padding(
            padding: padding ??
                EdgeInsets.symmetric(
                  horizontal: AppResponsive.horizontalPadding(context),
                  vertical: AppResponsive.scale(context, 16.0),
                ),
            child: child,
          ),
        ),
      );
    }

    final cardBg = color ?? (isDark ? AppColors.cardDark : AppColors.cardLight);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Container(
          margin: margin ?? const EdgeInsets.symmetric(vertical: 24.0),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(
              color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.3)
                    : const Color(0x0A0F172A),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: padding ??
                const EdgeInsets.symmetric(
                  horizontal: 28.0,
                  vertical: 32.0,
                ),
            child: child,
          ),
        ),
      ),
    );
  }
}
