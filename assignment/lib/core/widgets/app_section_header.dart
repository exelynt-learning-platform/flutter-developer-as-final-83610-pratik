import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_typography.dart';

/// Standardized section header with icon, title, and optional badge or trailing widget.
/// Guarantees flex-safe rendering across all system font scalers.
class AppSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final Widget? trailing;

  const AppSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: iconColor ?? AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: AppDimensions.space12),
            ],
            Expanded(
              child: Text(
                title,
                style: AppTypography.title(context),
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: AppDimensions.space8),
              trailing!,
            ],
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AppDimensions.space4),
          Text(
            subtitle!,
            style: AppTypography.caption(context),
          ),
        ],
      ],
    );
  }
}
