import 'package:flutter/material.dart';
import '../utils/app_responsive.dart';
import 'app_colors.dart';

/// Centralized typography specifications for the application design system.
/// Automatically applies dynamic responsive scaling across all screen sizes
/// and user accessibility text scales.
class AppTypography {
  AppTypography._();

  // Base Font Sizes (before responsive scaling)
  static const double baseDisplay = 28.0;
  static const double baseHeadline = 24.0;
  static const double baseTitle = 18.0;
  static const double baseSubtitle = 14.5;
  static const double baseBodyLarge = 16.0;
  static const double baseBody = 14.0;
  static const double baseCaption = 12.0;
  static const double baseBadge = 11.0;

  // Responsive Dynamic Font Size Getters
  static double fontSizeDisplay(BuildContext context) =>
      AppResponsive.fontSize(context, baseDisplay);
  static double fontSizeHeadline(BuildContext context) =>
      AppResponsive.fontSize(context, baseHeadline);
  static double fontSizeTitle(BuildContext context) =>
      AppResponsive.fontSize(context, baseTitle);
  static double fontSizeSubtitle(BuildContext context) =>
      AppResponsive.fontSize(context, baseSubtitle);
  static double fontSizeBodyLarge(BuildContext context) =>
      AppResponsive.fontSize(context, baseBodyLarge);
  static double fontSizeBody(BuildContext context) =>
      AppResponsive.fontSize(context, baseBody);
  static double fontSizeCaption(BuildContext context) =>
      AppResponsive.fontSize(context, baseCaption);
  static double fontSizeBadge(BuildContext context) =>
      AppResponsive.fontSize(context, baseBadge);

  // Responsive Typography Styles
  static TextStyle display(BuildContext context, {Color? color, FontWeight? fontWeight}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: fontSizeDisplay(context),
      fontWeight: fontWeight ?? FontWeight.w800,
      letterSpacing: -0.6,
      color: color ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
    );
  }

  static TextStyle headline(BuildContext context, {Color? color, FontWeight? fontWeight}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: fontSizeHeadline(context),
      fontWeight: fontWeight ?? FontWeight.w800,
      letterSpacing: -0.4,
      color: color ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
    );
  }

  static TextStyle title(BuildContext context, {Color? color, FontWeight? fontWeight}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: fontSizeTitle(context),
      fontWeight: fontWeight ?? FontWeight.w700,
      letterSpacing: -0.2,
      color: color ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
    );
  }

  static TextStyle subtitle(BuildContext context, {Color? color, FontWeight? fontWeight}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: fontSizeSubtitle(context),
      fontWeight: fontWeight ?? FontWeight.w400,
      color: color ?? (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
    );
  }

  static TextStyle label(BuildContext context, {Color? color, FontWeight? fontWeight}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: AppResponsive.fontSize(context, 13.5),
      fontWeight: fontWeight ?? FontWeight.w600,
      color: color ?? (isDark ? AppColors.textPrimaryDark : const Color(0xFF1E293B)),
    );
  }

  static TextStyle body(BuildContext context, {Color? color, FontWeight? fontWeight}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: fontSizeBody(context),
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
    );
  }

  static TextStyle caption(BuildContext context, {Color? color, FontWeight? fontWeight}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: fontSizeCaption(context),
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
    );
  }

  static TextStyle button(BuildContext context, {Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontSize: AppResponsive.fontSize(context, 15.0),
      fontWeight: fontWeight ?? FontWeight.w600,
      letterSpacing: 0.1,
      color: color ?? Colors.white,
    );
  }
}
