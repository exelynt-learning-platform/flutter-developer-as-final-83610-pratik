import 'package:flutter/material.dart';

/// Centralized responsive engine for dynamic UI scaling across all device form factors.
/// Scales fonts, text field heights, button sizes, spacing, and containers dynamically
/// based on device screen dimensions and accessibility text scaling.
class AppResponsive {
  AppResponsive._();

  /// Standard reference width (iPhone 14 / modern Android viewport width)
  static const double baseScreenWidth = 390.0;
  static const double baseScreenHeight = 844.0;

  /// Breakpoint and scaling constants
  static const double tabletBreakpoint = 600.0;
  static const double smallMobileBreakpoint = 360.0;
  static const double shortScreenBreakpoint = 680.0;
  static const double tabletScaleFactor = 1.0;
  static const double minScaleFactor = 0.88;
  static const double maxScaleFactor = 1.12;
  static const double minTextScale = 0.9;
  static const double maxTextScale = 1.2;
  static const double compressedSpacingFactor = 0.7;

  /// Current screen width
  static double width(BuildContext context) => MediaQuery.sizeOf(context).width;

  /// Current screen height
  static double height(BuildContext context) => MediaQuery.sizeOf(context).height;

  /// Returns true if device is tablet/desktop (width >= tabletBreakpoint)
  static bool isTablet(BuildContext context) => width(context) >= tabletBreakpoint;

  /// Returns true if device has a compact screen (width < smallMobileBreakpoint)
  static bool isSmallMobile(BuildContext context) => width(context) < smallMobileBreakpoint;

  /// Dynamic scale factor clamped to prevent undersized or oversized elements
  static double scaleFactor(BuildContext context) {
    final w = width(context);
    if (w >= tabletBreakpoint) {
      return tabletScaleFactor;
    }
    final factor = w / baseScreenWidth;
    return factor.clamp(minScaleFactor, maxScaleFactor);
  }

  /// Dynamically scale any dimension (paddings, margins, icon sizes, heights)
  static double scale(BuildContext context, double baseDimension) {
    return (baseDimension * scaleFactor(context)).roundToDouble();
  }

  /// Dynamically scale font size according to screen width and user accessibility scale
  static double fontSize(BuildContext context, double baseFontSize) {
    final factor = scaleFactor(context);
    final textScale = MediaQuery.textScalerOf(context).scale(baseFontSize) / baseFontSize;
    final combined = baseFontSize * factor * textScale.clamp(minTextScale, maxTextScale);
    return combined.roundToDouble();
  }

  /// Dynamic vertical spacing between UI sections
  static double verticalSpacing(BuildContext context, double baseSpacing) {
    final h = height(context);
    if (h < shortScreenBreakpoint) {
      return (baseSpacing * compressedSpacingFactor).roundToDouble();
    }
    return scale(context, baseSpacing);
  }

  /// Dynamic padding scaled to screen size
  static double padding(BuildContext context, double basePadding) =>
      scale(context, basePadding);

  /// Dynamic horizontal screen padding for pages
  static double horizontalPadding(BuildContext context) {
    final w = width(context);
    if (w >= 600) {
      return 24.0;
    }
    // Mobile: 6% of screen width (clamped between 18px and 24px)
    return (w * 0.06).clamp(18.0, 24.0);
  }

  /// Maximum readable content width for forms and cards
  static double maxContentWidth(BuildContext context) => 440.0;

  /// Dynamic height for interactive form controls (text fields, primary buttons)
  static double controlHeight(BuildContext context, {double baseHeight = 50.0}) {
    return scale(context, baseHeight).clamp(48.0, 54.0);
  }
}
