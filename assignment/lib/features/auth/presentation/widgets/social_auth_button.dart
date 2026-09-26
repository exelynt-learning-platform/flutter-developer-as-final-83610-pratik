import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_responsive.dart';

/// Social auth button matching the PeopleFlow reference screen.
/// Features dynamic responsive height, crisp 12px border radius, and authentic 4-color Google G icon.
class SocialAuthButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const SocialAuthButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dynamicHeight = AppResponsive.controlHeight(context);
    final dynamicFontSize = AppResponsive.fontSize(context, 14.5);
    final dynamicIconSize = AppResponsive.scale(context, 20.0);

    return SizedBox(
      height: dynamicHeight,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
          side: BorderSide(
            color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
            width: 1.1,
          ),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppResponsive.scale(context, 16.0),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _GoogleLogoIcon(size: dynamicIconSize),
                  SizedBox(width: AppResponsive.scale(context, 12.0)),
                  Flexible(
                    child: Text(
                      'Continue with Google',
                      style: TextStyle(
                        fontSize: dynamicFontSize,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _GoogleLogoIcon extends StatelessWidget {
  final double size;
  const _GoogleLogoIcon({required this.size});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/icons/google_logo.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => Icon(
        Icons.g_mobiledata,
        size: size,
        color: AppColors.primary,
      ),
    );
  }
}

