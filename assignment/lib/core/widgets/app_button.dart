import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../utils/app_responsive.dart';

enum AppButtonVariant { primary, secondary, outlined }

/// Global standardized button matching the PeopleFlow design system.
/// Features dynamic responsive height, ambient glow shadow, and built-in loading state.
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final AppButtonVariant variant;
  final double? width;
  final double? height;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.width = double.infinity,
    this.height,
  });

  const AppButton.outlined({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width = double.infinity,
    this.height,
  }) : variant = AppButtonVariant.outlined;

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = isLoading ? null : onPressed;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dynamicHeight = height ?? AppResponsive.controlHeight(context);
    final dynamicFontSize = AppResponsive.fontSize(context, 15.0);

    Widget childContent;
    if (isLoading) {
      childContent = SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.2,
          valueColor: AlwaysStoppedAnimation<Color>(
            variant == AppButtonVariant.outlined
                ? AppColors.primary
                : Colors.white,
          ),
        ),
      );
    } else if (icon != null) {
      childContent = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: AppResponsive.scale(context, 20)),
          SizedBox(width: AppResponsive.scale(context, 8.0)),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: dynamicFontSize,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.1,
                color: variant == AppButtonVariant.outlined
                    ? (isDark ? Colors.white : const Color(0xFF1E293B))
                    : Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    } else {
      childContent = Text(
        label,
        style: TextStyle(
          fontSize: dynamicFontSize,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
          color: variant == AppButtonVariant.outlined
              ? (isDark ? Colors.white : const Color(0xFF1E293B))
              : Colors.white,
        ),
        overflow: TextOverflow.ellipsis,
      );
    }

    final isPrimary = variant == AppButtonVariant.primary;

    if (variant == AppButtonVariant.outlined) {
      return SizedBox(
        width: width,
        height: dynamicHeight,
        child: OutlinedButton(
          onPressed: effectiveOnPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
              width: 1.2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
          ),
          child: childContent,
        ),
      );
    }

    return Container(
      width: width,
      height: dynamicHeight,
      decoration: isPrimary && effectiveOnPressed != null
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4F46E5).withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            )
          : null,
      child: ElevatedButton(
        onPressed: effectiveOnPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: childContent,
      ),
    );
  }
}
