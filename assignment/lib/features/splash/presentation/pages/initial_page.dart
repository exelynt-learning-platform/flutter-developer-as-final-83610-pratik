import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/utils/responsive_layout.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appTitle),
        actions: [
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, mode) {
              return IconButton(
                icon: Icon(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                ),
                tooltip: 'Toggle Theme',
                onPressed: () => context.read<ThemeCubit>().toggleTheme(),
              );
            },
          ),
          const SizedBox(width: AppDimensions.space8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.space24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 540),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.space32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppDimensions.space16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.badge_rounded,
                          size: 48,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.space20),
                      Text(
                        AppStrings.appTitle,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppDimensions.space8),
                      Text(
                        AppStrings.appTagline,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppDimensions.space24),
                      const Divider(),
                      const SizedBox(height: AppDimensions.space16),
                      _StatusRow(
                        label: 'Phase',
                        value: 'Phase 1 — Foundation',
                        icon: Icons.check_circle_rounded,
                        color: AppColors.success,
                      ),
                      const SizedBox(height: AppDimensions.space12),
                      _StatusRow(
                        label: 'Architecture',
                        value: 'Clean Architecture (Core Layer)',
                        icon: Icons.layers_rounded,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: AppDimensions.space12),
                      _StatusRow(
                        label: 'Device Layout',
                        value: ResponsiveLayout.isDesktop(context)
                            ? 'Desktop'
                            : ResponsiveLayout.isTablet(context)
                            ? 'Tablet'
                            : 'Mobile',
                        icon: Icons.devices_rounded,
                        color: AppColors.accent,
                      ),
                      const SizedBox(height: AppDimensions.space24),
                      BlocBuilder<ThemeCubit, ThemeMode>(
                        builder: (context, currentMode) {
                          return OutlinedButton.icon(
                            onPressed: () =>
                                context.read<ThemeCubit>().toggleTheme(),
                            icon: Icon(
                              isDark
                                  ? Icons.wb_sunny_rounded
                                  : Icons.nightlight_round,
                            ),
                            label: Text(
                              'Switch to ${isDark ? 'Light' : 'Dark'} Theme',
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatusRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: AppDimensions.space12),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: AppDimensions.space12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
